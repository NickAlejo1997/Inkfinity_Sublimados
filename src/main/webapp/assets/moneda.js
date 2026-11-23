(() => {
    'use strict';

    const monedas = {es: 'PEN', en: 'USD', fr: 'EUR', ja: 'JPY'};
    const formatos = {es: 'es-PE', en: 'en-US', fr: 'fr-FR', ja: 'ja-JP'};
    const estado = document.getElementById('estadoMoneda');
    let tasasPendientes;
    let revision = 0;
    let tasaActual = 1;

    async function obtenerTasas() {
        if (!tasasPendientes) {
            const url = 'https://api.frankfurter.dev/v2/rates?base=PEN&quotes=USD%2CEUR%2CJPY';
            tasasPendientes = fetch(url, {headers: {Accept: 'application/json'}, signal: AbortSignal.timeout(8000)})
                .then(respuesta => {
                    if (!respuesta.ok) throw new Error(`HTTP ${respuesta.status}`);
                    return respuesta.json();
                })
                .then(filas => {
                    if (!Array.isArray(filas)) throw new Error('Respuesta JSON inesperada');
                    const tasas = new Map(filas.map(fila => [fila.quote, Number(fila.rate)]));
                    for (const codigo of ['USD', 'EUR', 'JPY']) {
                        if (!Number.isFinite(tasas.get(codigo)) || tasas.get(codigo) <= 0) {
                            throw new Error(`Tasa no disponible: ${codigo}`);
                        }
                    }
                    return tasas;
                })
                .catch(error => {
                    tasasPendientes = undefined;
                    throw error;
                });
        }
        return tasasPendientes;
    }

    function formatear(monto, moneda, locale) {
        return new Intl.NumberFormat(locale, {
            style: 'currency',
            currency: moneda,
            maximumFractionDigits: moneda === 'JPY' ? 0 : 2
        }).format(monto);
    }

    function actualizarInputs(moneda, locale, tasa) {
        for (const input of document.querySelectorAll('[data-money-input]')) {
            if (!input.dataset.moneyInitialized) {
                if (input.value !== '') input.dataset.originalPen = input.value;
                input.dataset.moneyInitialized = 'true';
                input.addEventListener('input', () => { input.dataset.moneyDirty = 'true'; });
            }

            const actual = Number(input.value);
            const base = input.dataset.moneyDirty === 'true'
                ? (Number.isFinite(actual) ? actual / tasaActual : NaN)
                : Number(input.dataset.originalPen);
            if (Number.isFinite(base)) {
                input.value = (base * tasa).toFixed(moneda === 'JPY' ? 0 : 2);
            }

            const etiqueta = input.closest('label');
            const texto = etiqueta?.querySelector('[data-i18n]');
            if (etiqueta && texto) {
                let codigo = etiqueta.querySelector('[data-money-code]');
                if (!codigo) {
                    codigo = document.createElement('small');
                    codigo.dataset.moneyCode = '';
                    texto.insertAdjacentElement('afterend', codigo);
                }
                codigo.textContent = ` (${moneda})`;
            }
        }
    }

    function pintar(moneda, locale, tasa) {
        for (const nodo of document.querySelectorAll('[data-money-pen]')) {
            if (nodo.matches('option[data-money-product]')) {
                const monto = Number(nodo.dataset.moneyPen);
                nodo.textContent = `${nodo.dataset.productName} — ${formatear(monto * tasa, moneda, locale)}`;
                continue;
            }
            if (nodo.matches('option[data-money-arg]')) continue;
            const montoPen = Number(nodo.dataset.moneyPen);
            if (Number.isFinite(montoPen)) {
                nodo.textContent = formatear(montoPen * tasa, moneda, locale);
                nodo.dataset.displayCurrency = moneda;
            }
        }
        for (const option of document.querySelectorAll('option[data-money-arg]')) {
            const montoPen = Number(option.dataset.moneyArg);
            if (!Number.isFinite(montoPen)) continue;
            const anterior = option.dataset.arg2;
            const nuevo = formatear(montoPen * tasa, moneda, locale);
            if (anterior && option.textContent.includes(anterior)) {
                option.textContent = option.textContent.replace(anterior, nuevo);
            }
            option.dataset.arg2 = nuevo;
        }
        actualizarInputs(moneda, locale, tasa);
        document.body.dataset.currency = moneda;
        document.body.dataset.numberLocale = locale;
        tasaActual = tasa;
    }

    async function actualizar(idioma) {
        const actualizacion = ++revision;
        const moneda = monedas[idioma] || 'PEN';
        const locale = formatos[idioma] || 'es-PE';
        estado.hidden = true;

        if (moneda === 'PEN') {
            pintar(moneda, locale, 1);
            return;
        }

        try {
            const tasas = await obtenerTasas();
            if (actualizacion !== revision) return;
            pintar(moneda, locale, tasas.get(moneda));
        } catch (error) {
            if (actualizacion !== revision) return;
            // Conserva los importes de la base en soles si el servicio no responde.
            pintar('PEN', 'es-PE', 1);
            estado.hidden = false;
            console.error('No se pudo convertir la moneda; se muestran importes PEN.', error);
        }
    }

    document.addEventListener('inkfinity:languagechange', event => {
        actualizar(event.detail?.language || document.documentElement.lang);
    });

    document.addEventListener('submit', event => {
        for (const input of event.target.querySelectorAll('[data-money-input]')) {
            if (input.value === '') continue;
            if (input.dataset.moneyDirty === 'true') {
                const enPen = Number(input.value) / tasaActual;
                if (Number.isFinite(enPen)) input.value = enPen.toFixed(2);
            } else if (input.dataset.originalPen) {
                input.value = input.dataset.originalPen;
            }
        }
    }, true);

    actualizar(document.documentElement.lang);
})();
