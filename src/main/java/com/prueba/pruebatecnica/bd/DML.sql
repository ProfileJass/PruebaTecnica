INSERT INTO eps (nombre, codigo) VALUES
                                     ('SURA', 'EPS001'),
                                     ('SANITAS', 'EPS002'),
                                     ('NUEVA EPS', 'EPS003'),
                                     ('SALUD TOTAL', 'EPS004');

INSERT INTO posiciones (nombre, descripcion) VALUES
                                                 ('Desarrollador Junior', 'Desarrollador de software nivel junior'),
                                                 ('Desarrollador Senior', 'Desarrollador de software nivel senior'),
                                                 ('Analista', 'Analista de sistemas'),
                                                 ('Gerente', 'Gerente de área');

-- Usuario administrador por defecto
INSERT INTO usuarios (username, email, password, primer_nombre, primer_apellido, numero_documento, tipo_documento)
VALUES ('admin', 'admin@empresa.com', '$2a$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewfrgcMsUFXGdyWK', 'Admin', 'Sistema', '1234567890', 'CC');