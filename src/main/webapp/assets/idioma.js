(() => {
    const selector = document.getElementById('idioma');
    const aviso = document.getElementById('errorIdioma');
    selector.value = document.documentElement.lang;
    const catalogos = new Map();
    let mensajes;

    async function cargar(idioma) {
        if (!catalogos.has(idioma)) {
            const url = new URL(selector.dataset.url, location.origin);
            url.searchParams.set('idioma', idioma);
            const respuesta = await fetch(url);
            if (!respuesta.ok) throw new Error(String(respuesta.status));
            const xml = new DOMParser().parseFromString(await respuesta.text(), 'application/xml');
            const entradas = Array.from(xml.querySelectorAll('properties > entry'),
                entrada => [entrada.getAttribute('key'), entrada.textContent]);
            if (!entradas.length) throw new Error('properties');
            catalogos.set(idioma, new Map(entradas));
        }
        return catalogos.get(idioma);
    }

    // Solo los elementos marcados por la vista contienen traducciones.
    function traducir(textos) {
        for (const nodo of document.querySelectorAll('[data-i18n]')) {
            const plantilla = textos.get(nodo.dataset.i18n);
            if (plantilla !== undefined) {
                nodo.textContent = plantilla.replace(/\{(\d+)\}/g,
                    (_, indice) => nodo.getAttribute('data-arg-' + indice));
            }
        }
        for (const atributo of ['placeholder', 'alt', 'content', 'aria-label', 'data-label']) {
            const marca = 'data-i18n-' + atributo;
            for (const nodo of document.querySelectorAll('[' + marca + ']')) {
                nodo.setAttribute(atributo, textos.get(nodo.getAttribute(marca)));
            }
        }
    }

    selector.addEventListener('change', async () => {
        const idioma = selector.value;
        selector.disabled = true;
        aviso.hidden = true;
        try {
            const textos = await cargar(idioma);
            traducir(textos);
            mensajes = textos;
            document.documentElement.lang = idioma;
            // Cookie de sesión independiente del inicio y cierre de sesión del cliente.
            document.cookie = 'inkfinityIdioma=' + idioma + '; Path=' + selector.dataset.ruta + '; SameSite=Lax';
            document.dispatchEvent(new CustomEvent('inkfinity:languagechange', {detail: {language: idioma}}));
        } catch {
            selector.value = document.documentElement.lang;
            aviso.hidden = false;
        } finally {
            selector.disabled = false;
            selector.focus();
        }
    });

    // Los mensajes nativos del navegador pueden usar un idioma distinto al de la página.
    cargar(document.documentElement.lang).then(textos => {
        if (!mensajes) mensajes = textos;
    }).catch(() => { /* La validación HTML sigue disponible. */ });

    document.addEventListener('invalid', evento => {
        const campo = evento.target;
        if (!mensajes || !campo.validity) return;
        campo.setCustomValidity('');
        const estado = campo.validity;
        let clave, argumento;
        if (estado.valueMissing) {
            clave = campo.type === 'radio' || campo.tagName === 'SELECT' ? 'seleccion' : 'requerido';
        } else if (estado.rangeUnderflow) {
            clave = 'minimo'; argumento = campo.min;
        } else if (estado.rangeOverflow) {
            clave = 'maximo'; argumento = campo.max;
        } else if (estado.tooShort) {
            clave = 'longitudMin'; argumento = campo.minLength;
        } else if (estado.tooLong) {
            clave = 'longitudMax'; argumento = campo.maxLength;
        } else if (estado.stepMismatch) {
            clave = 'paso'; argumento = campo.step;
        } else if (!estado.valid) {
            clave = 'formato';
        }
        if (clave) campo.setCustomValidity(mensajes.get('validacion.' + clave).replace('{0}', argumento));
    }, true);

    // Un cambio de radio valida todo su grupo. Elimina los errores personalizados anteriores.
    document.addEventListener('input', evento => {
        const campo = evento.target;
        if (!campo.setCustomValidity) return;
        campo.setCustomValidity('');
        if (campo.type === 'radio' && campo.form) {
            for (const radio of campo.form.elements) {
                if (radio.type === 'radio' && radio.name === campo.name) radio.setCustomValidity('');
            }
        }
    });
})();
