CREATE DATABASE inkfinity_sublimados
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE inkfinity_sublimados;

CREATE TABLE polo_variante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tejido VARCHAR(10) NOT NULL,
    talla ENUM('S', 'M', 'L', 'XL') NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    UNIQUE KEY uq_polo_tejido_talla (tejido, talla),
    CONSTRAINT chk_polo_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE polo_diseno (
    codigo VARCHAR(30) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    adicional_unitario DECIMAL(10, 2) NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_polo_diseno_adicional CHECK (adicional_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE taza (
    onzas INT PRIMARY KEY,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_taza_onzas CHECK (onzas > 0)
) ENGINE=InnoDB;

CREATE TABLE taza_precio (
    onzas INT NOT NULL,
    unidades_paquete INT NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (onzas, unidades_paquete),
    CONSTRAINT fk_taza_precio_taza FOREIGN KEY (onzas) REFERENCES taza(onzas),
    CONSTRAINT chk_taza_paquete CHECK (unidades_paquete IN (1, 6, 12)),
    CONSTRAINT chk_taza_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE taza_empaque (
    codigo VARCHAR(30) PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL,
    adicional_unitario DECIMAL(10, 2) NOT NULL DEFAULT 0,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT chk_taza_empaque_adicional CHECK (adicional_unitario >= 0)
) ENGINE=InnoDB;

CREATE TABLE descuento_polo (
    cantidad_minima INT PRIMARY KEY,
    porcentaje DECIMAL(5, 2) NOT NULL,
    CONSTRAINT chk_descuento_cantidad CHECK (cantidad_minima > 0),
    CONSTRAINT chk_descuento_porcentaje CHECK (porcentaje >= 0 AND porcentaje <= 100)
) ENGINE=InnoDB;

CREATE TABLE configuracion (
    clave VARCHAR(60) PRIMARY KEY,
    valor DECIMAL(10, 2) NOT NULL,
    descripcion VARCHAR(160) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE administrador (
    id TINYINT NOT NULL PRIMARY KEY,
    dni CHAR(8) NOT NULL UNIQUE,
    nombre VARCHAR(80) NOT NULL,
    sal_contrasena VARBINARY(16) NOT NULL,
    hash_contrasena VARBINARY(32) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_administrador_unico CHECK (id = 1)
) ENGINE=InnoDB;

CREATE TABLE producto_adicional (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    descripcion VARCHAR(180) NOT NULL DEFAULT '',
    precio DECIMAL(10, 2) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_producto_adicional_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE cliente (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    dni CHAR(8) NOT NULL UNIQUE,
    nombres VARCHAR(60) NOT NULL,
    apellidos VARCHAR(60) NOT NULL,
    celular CHAR(9) NOT NULL,
    sal_contrasena VARBINARY(16) NOT NULL,
    hash_contrasena VARBINARY(32) NOT NULL,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE pedido (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NULL,
    cliente VARCHAR(80) NOT NULL,
    celular CHAR(9) NULL,
    tipo_producto ENUM('POLO', 'TAZA', 'OTRO') NOT NULL,
    polo_variante_id INT NULL,
    taza_onzas INT NULL,
    diseno_polo_codigo VARCHAR(30) NULL,
    taza_empaque_codigo VARCHAR(30) NULL,
    producto_adicional_id INT NULL,
    cantidad INT NOT NULL,
    detalle_precio VARCHAR(500) NOT NULL,
    subtotal DECIMAL(12, 2) NOT NULL,
    porcentaje_descuento DECIMAL(5, 2) NOT NULL DEFAULT 0,
    descuento DECIMAL(12, 2) NOT NULL DEFAULT 0,
    base_imponible DECIMAL(12, 2) NOT NULL,
    porcentaje_igv DECIMAL(5, 2) NOT NULL,
    igv DECIMAL(12, 2) NOT NULL,
    total DECIMAL(12, 2) NOT NULL,
    creado_en TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pedido_polo_variante FOREIGN KEY (polo_variante_id) REFERENCES polo_variante(id),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id),
    CONSTRAINT fk_pedido_taza FOREIGN KEY (taza_onzas) REFERENCES taza(onzas),
    CONSTRAINT fk_pedido_diseno_polo FOREIGN KEY (diseno_polo_codigo) REFERENCES polo_diseno(codigo),
    CONSTRAINT fk_pedido_empaque_taza FOREIGN KEY (taza_empaque_codigo) REFERENCES taza_empaque(codigo),
    CONSTRAINT fk_pedido_producto_adicional FOREIGN KEY (producto_adicional_id) REFERENCES producto_adicional(id),
    CONSTRAINT chk_pedido_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_pedido_montos CHECK (subtotal >= 0 AND descuento >= 0 AND base_imponible >= 0 AND igv >= 0 AND total >= 0)
) ENGINE=InnoDB;

INSERT IGNORE INTO polo_variante (tejido, talla, precio) VALUES
    ('24/1', 'S', 22.00),
    ('24/1', 'M', 25.00),
    ('24/1', 'L', 30.00),
    ('24/1', 'XL', 35.00),
    ('20/1', 'M', 28.00),
    ('20/1', 'L', 35.00);

INSERT IGNORE INTO polo_diseno (codigo, nombre, adicional_unitario) VALUES
    ('clasico', 'Diseño clásico', 0.00),
    ('personalizado', 'Diseño personalizado', 2.00);

INSERT IGNORE INTO taza (onzas) VALUES (11), (15);

INSERT IGNORE INTO taza_precio (onzas, unidades_paquete, precio) VALUES
    (11, 1, 8.00),
    (11, 6, 42.00),
    (11, 12, 84.00),
    (15, 1, 13.00),
    (15, 6, 66.00),
    (15, 12, 132.00);

INSERT IGNORE INTO taza_empaque (codigo, nombre, adicional_unitario) VALUES
    ('sin_caja', 'Sin caja', 0.00),
    ('caja_simple', 'Caja simple', 1.00),
    ('caja_personalizada', 'Caja personalizada', 2.00);

INSERT IGNORE INTO descuento_polo (cantidad_minima, porcentaje) VALUES
    (1, 0.00),
    (6, 5.00),
    (12, 10.00),
    (24, 15.00);

INSERT IGNORE INTO configuracion (clave, valor, descripcion) VALUES
    ('igv_porcentaje', 18.00, 'Porcentaje de IGV aplicado a la base imponible');
