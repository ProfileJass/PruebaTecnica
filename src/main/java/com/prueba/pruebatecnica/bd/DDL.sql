CREATE TABLE usuarios (
                          id BIGSERIAL PRIMARY KEY,
                          username VARCHAR(50) UNIQUE NOT NULL,
                          email VARCHAR(100) UNIQUE NOT NULL,
                          password VARCHAR(255) NOT NULL,
                          primer_nombre VARCHAR(50) NOT NULL,
                          segundo_nombre VARCHAR(50),
                          primer_apellido VARCHAR(50) NOT NULL,
                          segundo_apellido VARCHAR(50),
                          numero_documento VARCHAR(20) UNIQUE NOT NULL,
                          tipo_documento VARCHAR(10) NOT NULL,
                          telefono VARCHAR(15),
                          activo BOOLEAN DEFAULT TRUE,
                          fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de EPS
CREATE TABLE eps (
                     id BIGSERIAL PRIMARY KEY,
                     nombre VARCHAR(100) NOT NULL,
                     codigo VARCHAR(10) UNIQUE NOT NULL,
                     activo BOOLEAN DEFAULT TRUE
);

-- Tabla de posiciones/cargos
CREATE TABLE posiciones (
                            id BIGSERIAL PRIMARY KEY,
                            nombre VARCHAR(100) NOT NULL,
                            descripcion TEXT,
                            activo BOOLEAN DEFAULT TRUE
);

-- Tabla de histórico de empleados (salarios y posiciones)
CREATE TABLE historico_empleados (
                                     id BIGSERIAL PRIMARY KEY,
                                     usuario_id BIGINT NOT NULL,
                                     posicion_id BIGINT NOT NULL,
                                     salario DECIMAL(12,2) NOT NULL,
                                     fecha_contratacion DATE NOT NULL,
                                     fecha_inicio DATE NOT NULL,
                                     fecha_fin DATE,
                                     activo BOOLEAN DEFAULT TRUE,
                                     fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                     FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
                                     FOREIGN KEY (posicion_id) REFERENCES posiciones(id)
);

-- Tabla de incapacidades
CREATE TABLE incapacidades (
                               id BIGSERIAL PRIMARY KEY,
                               numero_radicado VARCHAR(20) UNIQUE NOT NULL,
                               usuario_id BIGINT NOT NULL,
                               eps_id BIGINT NOT NULL,
                               historico_empleado_id BIGINT NOT NULL,
                               fecha_inicio DATE NOT NULL,
                               fecha_fin DATE NOT NULL,
                               estado VARCHAR(20) DEFAULT 'pendiente',
                               usuario_creador_id BIGINT NOT NULL,
                               fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
                               FOREIGN KEY (eps_id) REFERENCES eps(id),
                               FOREIGN KEY (historico_empleado_id) REFERENCES historico_empleados(id),
                               FOREIGN KEY (usuario_creador_id) REFERENCES usuarios(id),
                               CHECK (estado IN ('pendiente', 'en_curso', 'completado'))
);

-- Tabla de auditoría de cambios de estado
CREATE TABLE auditoria_estados (
                                   id BIGSERIAL PRIMARY KEY,
                                   incapacidad_id BIGINT NOT NULL,
                                   estado_anterior VARCHAR(20),
                                   estado_nuevo VARCHAR(20) NOT NULL,
                                   usuario_id BIGINT NOT NULL,
                                   fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   observaciones TEXT,
                                   FOREIGN KEY (incapacidad_id) REFERENCES incapacidades(id),
                                   FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de retiros de empleados
CREATE TABLE retiros_empleados (
                                   id BIGSERIAL PRIMARY KEY,
                                   usuario_id BIGINT NOT NULL,
                                   fecha_retiro DATE NOT NULL,
                                   motivo TEXT,
                                   usuario_administrador_id BIGINT NOT NULL,
                                   fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                                   FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
                                   FOREIGN KEY (usuario_administrador_id) REFERENCES usuarios(id)
);

-- Índices para optimizar consultas
CREATE INDEX idx_incapacidades_usuario ON incapacidades(usuario_id);
CREATE INDEX idx_incapacidades_estado ON incapacidades(estado);
CREATE INDEX idx_incapacidades_fecha_inicio ON incapacidades(fecha_inicio);
CREATE INDEX idx_incapacidades_fecha_fin ON incapacidades(fecha_fin);
CREATE INDEX idx_auditoria_incapacidad ON auditoria_estados(incapacidad_id);
CREATE INDEX idx_historico_usuario ON historico_empleados(usuario_id);

-- Función para generar número de radicado
CREATE OR REPLACE FUNCTION generar_numero_radicado() RETURNS VARCHAR(20) AS $$
DECLARE
numero_radicado VARCHAR(20);
BEGIN
SELECT 'RAD-' || LPAD(CAST(COALESCE(MAX(CAST(SUBSTRING(numero_radicado FROM 5) AS INTEGER)), 0) + 1 AS VARCHAR), 8, '0')
INTO numero_radicado
FROM incapacidades
WHERE numero_radicado LIKE 'RAD-%';

RETURN numero_radicado;
END;
$$ LANGUAGE plpgsql;

-- Trigger para generar número de radicado automáticamente
CREATE OR REPLACE FUNCTION set_numero_radicado() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.numero_radicado IS NULL OR NEW.numero_radicado = '' THEN
        NEW.numero_radicado := generar_numero_radicado();
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_generar_radicado
    BEFORE INSERT ON incapacidades
    FOR EACH ROW
    EXECUTE FUNCTION set_numero_radicado();

-- Trigger para auditoría de cambios de estado
CREATE OR REPLACE FUNCTION auditoria_cambio_estado() RETURNS TRIGGER AS $$
BEGIN
    IF OLD.estado != NEW.estado THEN
        INSERT INTO auditoria_estados (incapacidad_id, estado_anterior, estado_nuevo, usuario_id)
        VALUES (NEW.id, OLD.estado, NEW.estado, NEW.usuario_creador_id);
END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_auditoria_estado
    AFTER UPDATE ON incapacidades
    FOR EACH ROW
    EXECUTE FUNCTION auditoria_cambio_estado();