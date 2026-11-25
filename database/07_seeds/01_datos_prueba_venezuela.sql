-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/07_seeds/01_datos_prueba_venezuela.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Carga realista y coherente de datos de prueba en el contexto
--           turístico y urbano venezolano cubriendo las 31 tablas del esquema.
-- ============================================================================

-- 1. Jerarquía Político-Territorial (incluye homónimos en distintos estados - HU-09)
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'Catedral');
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'Altagracia');
CALL sp_registrar_jerarquia_territorial('Distrito Capital', 'Libertador', 'San José');
CALL sp_registrar_jerarquia_territorial('Miranda', 'Chacao', 'Chacao');
CALL sp_registrar_jerarquia_territorial('Miranda', 'Sucre', 'Petare');
CALL sp_registrar_jerarquia_territorial('Mérida', 'Libertador', 'El Sagrario');
CALL sp_registrar_jerarquia_territorial('Falcón', 'Miranda', 'Santa Ana');
CALL sp_registrar_jerarquia_territorial('Sucre', 'Sucre', 'Santa Inés');
CALL sp_registrar_jerarquia_territorial('La Guaira', 'Vargas', 'Macuto');

-- 2. Hitos Turísticos y Culturales en 3D (HU-10 a HU-14)
CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Casa Natal del Libertador',
    10.506080, -66.912690, 908.00,
    'disponible', FALSE,
    'Residencia colonial del siglo XVIII donde nació Simón Bolívar el 24 de julio de 1783. Conserva piezas originales de la época independentista y murales de Tito Salas.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Domingo 09:00-16:30'],
    ARRAY['Recorrido guiado teatralizado: Sábados 11:00', 'Tertulia Bolivariana: Jueves 15:00']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Plaza Bolívar de Caracas',
    10.506180, -66.914630, 910.00,
    'disponible', TRUE,
    'Plaza mayor fundacional de Santiago de León de Caracas (1567), centro neurálgico histórico rodeado por la Catedral de Caracas, el Palacio Municipal y la Casa Amarilla.',
    ARRAY['historico', 'recreativo', 'descanso'],
    ARRAY['Acceso libre 24 horas'],
    ARRAY['Retreta dominical de la Banda Marcial: Domingos 10:00']
);

-- Prueba explícita de HU-13: Misma latitud y longitud que Plaza Bolívar de Caracas, distinta elevación/altitud
CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Catedral',
    'Estatua Ecuestre del Libertador',
    10.506180, -66.914630, 914.50,
    'disponible', TRUE,
    'Monumento en bronce inaugurado en 1874 sobre pedestal escalonado en el centro exacto de la Plaza Bolívar de Caracas, obra del escultor Adamo Tadolini.',
    ARRAY['historico'],
    ARRAY['Acceso libre 24 horas'],
    ARRAY['Ofrenda floral conmemorativa: 24 de julio 08:30']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'Altagracia',
    'Panteón Nacional',
    10.511750, -66.911450, 935.00,
    'disponible', FALSE,
    'Santuario cívico nacional ubicado en el antiguo solar de la Iglesia de la Santísima Trinidad, donde reposan los restos de Simón Bolívar y próceres de la República.',
    ARRAY['historico', 'religioso'],
    ARRAY['Martes a Domingo 09:00-16:00'],
    ARRAY['Cambio de guardia de honor: Sábados 12:00']
);

CALL sp_registrar_hito_completo(
    'Distrito Capital', 'Libertador', 'San José',
    'Museo de Arte Colonial Quinta de Anauco',
    10.508200, -66.899400, 920.00,
    'en restauracion', FALSE,
    'Hacienda cafetalera del siglo XVIII en San Bernardino que exhibe mobiliario, platería y arte sacro del período colonial venezolano.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Miércoles a Domingo 09:30-16:00 (sujeto a obra)'],
    ARRAY['Jornada de conservación preventiva de techos coloniales']
);

CALL sp_registrar_hito_completo(
    'Miranda', 'Chacao', 'Chacao',
    'Estación Warairarepano Pico Ávila',
    10.543200, -66.885500, 2105.00,
    'disponible', FALSE,
    'Estación superior del teleférico de Caracas en la cima del Parque Nacional Warairarepano, punto de partida para senderismo ecológico y gastronomía de montaña.',
    ARRAY['natural', 'recreativo', 'gastronomico'],
    ARRAY['Miércoles a Domingo 09:00-19:00'],
    ARRAY['Feria artesanal y chocolate caliente: Viernes a Domingo']
);

-- Segundo ejemplo HU-13: Misma coordenada horizontal en la cima del Ávila con distinta altitud
CALL sp_registrar_hito_completo(
    'Miranda', 'Chacao', 'Chacao',
    'Mirador Circular Hotel Humboldt',
    10.543200, -66.885500, 2140.00,
    'disponible', FALSE,
    'Emblemática torre cilíndrica modernista diseñada por Tomás José Sanabria en 1956, con vista panorámica de 360 grados sobre Caracas y el mar Caribe.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Jueves a Domingo 10:00-18:00'],
    ARRAY['Visita arquitectónica comentada: Sábados 15:00']
);

CALL sp_registrar_hito_completo(
    'Falcón', 'Miranda', 'Santa Ana',
    'Catedral Basílica de Santa Ana de Coro',
    11.409167, -69.676389, 21.00,
    'disponible', FALSE,
    'Templo católico más antiguo de Venezuela en pie (iniciado en 1583), núcleo del Patrimonio Cultural de la Humanidad declarado por la UNESCO en Coro.',
    ARRAY['religioso', 'historico'],
    ARRAY['Lunes a Domingo 08:00-12:00 y 15:00-18:30'],
    ARRAY['Misa patrimonial y concierto coral: Domingos 10:00']
);

CALL sp_registrar_hito_completo(
    'Mérida', 'Libertador', 'El Sagrario',
    'Basílica Menor Inmaculada Concepción de Mérida',
    8.597778, -71.144167, 1630.00,
    'disponible', TRUE,
    'Catedral neobarroca inspirada en la Catedral de Toledo, ubicada frente a la Plaza Bolívar de Mérida en plena cordillera andina.',
    ARRAY['religioso', 'historico'],
    ARRAY['Lunes a Domingo 07:30-19:00'],
    ARRAY['Recorrido de vitrales y cripta: Sábados 16:00']
);

CALL sp_registrar_hito_completo(
    'Sucre', 'Sucre', 'Santa Inés',
    'Castillo San Antonio de la Eminencia',
    10.464444, -64.171111, 68.00,
    'disponible', FALSE,
    'Fortificación militar colonial de planta estrellada construida en piedra coralina entre 1659 y 1686 para defender la ciudad de Cumaná y el Golfo de Cariaco.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Domingo 09:00-17:00'],
    ARRAY['Atardecer histórico sobre el Golfo de Cariaco: Viernes 17:00']
);

CALL sp_registrar_hito_completo(
    'Miranda', 'Sucre', 'Petare',
    'Centro Histórico y Museo Bárbaro Rivas',
    10.476944, -66.803889, 855.00,
    'disponible', FALSE,
    'Conjunto colonial de calles empedradas en lo alto de Petare, sede del Museo de Arte Popular Bárbaro Rivas y la Iglesia Dulce Nombre de Jesús.',
    ARRAY['historico', 'recreativo'],
    ARRAY['Martes a Sábado 09:30-16:00'],
    ARRAY['Taller de pintura ingenua comunitaria: Sábados 10:30']
);

-- 3. Puntos de Anclaje de Realidad Aumentada
INSERT INTO punto_anclaje_ra (
    nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, codigo_recurso_3d,
    latitud_ra, longitud_ra, altitud_suelo, azimut, inclinacion, rotacion, radio_activacion_m, escala_visual
) VALUES
('Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 'AR-CASA-NATAL-PATIO-01',
 10.506082, -66.912688, 1.80, 125.50, 5.00, 0.00, 25.00, 1.000),
('Distrito Capital', 'Libertador', 'Catedral', 'Estatua Ecuestre del Libertador', 'AR-BOLIVAR-EC-1874',
 10.506180, -66.914630, 4.50, 180.00, 12.00, 0.00, 35.00, 1.150),
('Sucre', 'Sucre', 'Santa Inés', 'Castillo San Antonio de la Eminencia', 'AR-CASTILLO-CUMANA-3D',
 10.464446, -64.171108, 2.20, 270.00, 0.00, 15.00, 50.00, 1.250);

-- 4. Red de Vías y Modos de Recorrido
INSERT INTO via (codigo_via, nombre_via, tipo_via, condicion_terreno, desnivel_pendiente_3d, estado_via) VALUES
('VIA-CCS-01', 'Bulevar Panteón - San Jacinto', 'bulevar', 'Adoquín plano en buen estado', 1.50, 'habilitada'),
('VIA-CCS-02', 'Esquina La Torre a Principal', 'calle', 'Pavimento urbano llano', 0.80, 'habilitada'),
('VIA-CCS-03', 'Avenida Urdaneta Tramo Catedral', 'avenida', 'Asfalto con rampas accesibles', 1.20, 'habilitada'),
('VIA-MIR-01', 'Sendero Turístico Galipán - Humboldt', 'sendero', 'Empedrado de montaña con escalinatas', 18.50, 'habilitada'),
('VIA-MIR-02', 'Calle Lino de Clemente Petare', 'calle', 'Empedrado colonial inclinado', 7.40, 'habilitada'),
('VIA-FAL-01', 'Paseo Talavera Casco Colonial', 'bulevar', 'Ladrillo peatonal nivelado', 0.40, 'habilitada'),
('VIA-MER-01', 'Avenida 3 Independencia Mérida', 'avenida', 'Asfalto urbano con pendiente suave', 4.20, 'habilitada'),
('VIA-SUC-01', 'Subida Cerro Pan de Azúcar', 'camineria', 'Escalinata de piedra consolidada', 14.00, 'habilitada'),
('VIA-CCS-04', 'Callejón Sur Anauco (Obras)', 'calle', 'En reparación por drenaje', 2.00, 'cierre total por mantenimiento');

INSERT INTO modo_recorrido_via (codigo_via, modos_recorrido) VALUES
('VIA-CCS-01', 'a pie'),
('VIA-CCS-01', 'vehiculo adaptado'),
('VIA-CCS-02', 'a pie'),
('VIA-CCS-02', 'bicicleta'),
('VIA-CCS-03', 'a pie'),
('VIA-CCS-03', 'transporte publico'),
('VIA-CCS-03', 'vehiculo adaptado'),
('VIA-MIR-01', 'a pie'),
('VIA-MIR-02', 'a pie'),
('VIA-FAL-01', 'a pie'),
('VIA-FAL-01', 'vehiculo adaptado'),
('VIA-MER-01', 'a pie'),
('VIA-MER-01', 'transporte publico'),
('VIA-SUC-01', 'a pie');

-- 5. Paradas de Transporte y Cercanía a Hitos
INSERT INTO parada_transporte (
    codigo_terminal, nombre_descriptivo, modalidad_transp, tarifa_basica_bs, nivel_accesibilidad,
    latitud_parada, longitud_parada, altitud_parada, hora_apertura, hora_cierre, estado_disponib,
    frecuencia_paso_min, capacidad_max_espera, tiene_techo, iluminacion_nocturna, tiene_taquilla,
    vigilancia_permanente, estacionamiento_transferencia, codigo_via
) VALUES
('TERM-CCS-CAP', 'Estación Metro Capitolio', 'metro', 10.00, 'Ascensor y rampas podotáctiles',
 10.505500, -66.916200, 902.00, '05:30', '23:00', 'activa', 4.00, 350, TRUE, TRUE, TRUE, TRUE, FALSE, 'VIA-CCS-03'),
('TERM-MIR-AVILA', 'Terminal Teleférico Warairarepano', 'teleferico', 450.00, 'Cabinas adaptadas para silla de ruedas',
 10.517800, -66.889100, 995.00, '09:00', '20:00', 'activa', 6.00, 220, TRUE, TRUE, TRUE, TRUE, TRUE, 'VIA-MIR-01'),
('TERM-MER-CEN', 'Parada Trolmérida Plaza Bolívar', 'autobus superficial', 15.00, 'Plataforma a nivel para silla de ruedas',
 8.597100, -71.144900, 1625.00, '06:00', '21:00', 'activa', 10.00, 90, TRUE, TRUE, TRUE, FALSE, FALSE, 'VIA-MER-01'),
('TERM-FAL-CORO', 'Parada Casco Histórico Coro', 'autobus superficial', 20.00, 'Acceso peatonal básico con rampa',
 11.408500, -69.675800, 20.00, '06:00', '20:00', 'activa', 15.00, 60, TRUE, TRUE, FALSE, TRUE, FALSE, 'VIA-FAL-01');

INSERT INTO parada_cercana_hito (
    codigo_terminal, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, distancia_metros
) VALUES
('TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas', 185.00),
('TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', 390.00),
('TERM-MIR-AVILA', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila', 2950.00),
('TERM-MER-CEN', 'Mérida', 'Libertador', 'El Sagrario', 'Basílica Menor Inmaculada Concepción de Mérida', 110.00),
('TERM-FAL-CORO', 'Falcón', 'Miranda', 'Santa Ana', 'Catedral Basílica de Santa Ana de Coro', 95.00);

-- 6. Visitantes (HU-01, HU-02)
CALL sp_registrar_visitante(
    'V-28451902', 'ClaveVisitante2026!', 'Valeria Sofía', 'Mendoza Ríos',
    'Venezuela', 'Español', '+58-412-5550192', 'O+',
    'valeria.mendoza@correo.ve', '+58-414-5550101',
    ARRAY['Silla de ruedas', 'Rampas de acceso continuo']
);

CALL sp_registrar_visitante(
    'V-30821466', 'GabrielClave2026!', 'Gabriel', 'López',
    'Venezuela', 'Español', '+58-424-5550200', 'A+',
    'gabriel.lopez@ucab.edu.ve', '+58-424-5550201',
    ARRAY[]::TEXT[]
);

CALL sp_registrar_visitante(
    'P-FR994821', 'JeanLucParis2026!', 'Jean-Luc', 'Moreau',
    'Francia', 'Francés', '+33-612-889900', 'B+',
    'jeanluc.moreau@voyage.fr', '+58-412-5550998',
    ARRAY['Audio guía descriptiva', 'Asistencia visual']
);

-- 7. Rutas Turísticas (Fijas, Dinámica y Pasos de Itinerario)
INSERT INTO ruta_turistica (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta,
    duracion_estimada, mejor_hora_inicio, nivel_dificultad, categoria_tematica
) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 180.00, '09:00', 'bajo', 'Patrimonio Histórico'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', 150.00, '08:30', 'medio', 'Patrimonio Andino'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 240.00, '09:30', 'medio', 'Ecoturismo y Cacao'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', 210.00, '14:30', 'medio', 'Historia y Gastronomía'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 120.00, '10:00', 'bajo', 'Accesible');

INSERT INTO ruta_fija (nombre_estado_origen, nombre_municipio_origen, nombre_ruta, fecha_curaduria, resena_experto) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', '2026-10-15',
 'Circuito peatonal curado por cronistas de Caracas que enlaza la Plaza Bolívar, la Casa Natal y el Panteón Nacional con acceso por Metro Capitolio.'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', '2026-10-18',
 'Recorrido patrimonial por el casco fundacional merideño destacando la Basílica Menor y la arquitectura republicana.'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', '2026-10-20',
 'Ascenso en teleférico hasta el Pico Ávila con degustación de cacao de Barlovento y visita al Hotel Humboldt.'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', '2026-10-22',
 'Itinerario cultural cumanés desde las faldas del Castillo San Antonio hasta talleres chocolateros artesanales.');

INSERT INTO ruta_dinamica (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta,
    pref_transporte, fecha_generacion, cedula_pasaporte_creador
) VALUES
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 'vehiculo adaptado', '2026-11-10 09:45:00', 'V-28451902');

INSERT INTO paso_itinerario (
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta, nro_orden_secuencia,
    tiempo_estancia_min, codigo_via, codigo_terminal,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito
) VALUES
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 1, 15.00, 'VIA-CCS-03', 'TERM-CCS-CAP', NULL, NULL, NULL, NULL),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 2, 45.00, 'VIA-CCS-02', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 3, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador'),
('Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora', 4, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Altagracia', 'Panteón Nacional'),
('Mérida', 'Libertador', 'Ruta Histórica Libertadora', 1, 90.00, 'VIA-MER-01', 'TERM-MER-CEN', 'Mérida', 'Libertador', 'El Sagrario', 'Basílica Menor Inmaculada Concepción de Mérida'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 1, 60.00, 'VIA-MIR-01', 'TERM-MIR-AVILA', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila'),
('Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila', 2, 90.00, 'VIA-MIR-01', NULL, 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt'),
('Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental', 1, 90.00, 'VIA-SUC-01', NULL, 'Sucre', 'Sucre', 'Santa Inés', 'Castillo San Antonio de la Eminencia'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 1, 45.00, 'VIA-CCS-02', 'TERM-CCS-CAP', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Distrito Capital', 'Libertador', 'Mi Paseo por Catedral', 2, 60.00, 'VIA-CCS-01', NULL, 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador');

-- 8. Guías Turísticos (HU-03, HU-04, RM-13)
CALL sp_registrar_guia_turistico(
    'RTN-CCS-1042', 'LIC-MINTUR-881', 'GuiaCaracas2026!',
    'Carlos Eduardo', 'Rivas Briceño',
    'Guía Nacional Certificado INATUR Nro. 881', 12, 250.00,
    'Distrito Capital', 'Libertador',
    ARRAY['Historia Colonial', 'Arquitectura Republicana', 'Turismo Accesible'],
    ARRAY['Español', 'Inglés', 'Francés'],
    'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora',
    'carlos.rivas@guias.ve', '+58-414-2201188', '+58-412-2209900'
);

CALL sp_registrar_guia_turistico(
    'RTN-MIR-2075', 'LIC-MINTUR-914', 'GuiaAvila2026!',
    'Mariana del Valle', 'Quintero Peña',
    'Baqueana Comunitaria Warairarepano - Mintur 914', 8, 220.00,
    'Miranda', 'Chacao',
    ARRAY['Ecoturismo de Montaña', 'Cacao Venezolano', 'Observación de Aves'],
    ARRAY['Español', 'Inglés'],
    'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila',
    'mariana.quintero@guias.ve', '+58-416-3304455', '+58-414-3300011'
);

CALL sp_registrar_guia_turistico(
    'RTN-SUC-3190', 'LIC-MINTUR-502', 'GuiaCumana2026!',
    'Rafael Antonio', 'Salazar Marcano',
    'Cronista y Guía Patrimonial de Cumaná Nro. 502', 15, 190.00,
    'Sucre', 'Sucre',
    ARRAY['Fortificaciones Coloniales', 'Gastronomía Oriental'],
    ARRAY['Español', 'Portugués'],
    'Sucre', 'Sucre', 'Ruta del Cacao y Fortaleza Oriental',
    'rafael.salazar@guias.ve', '+58-424-8807711', '+58-412-8807700'
);

-- 9. Comercios Aliados (HU-05)
CALL sp_registrar_comercio_aliado(
    'J-40123456-7', 'ComercioSanJacinto26!',
    'Chocolatería y Café San Jacinto C.A.', 'Gastronomía y Cacao', 45,
    'PS-DC-2026-0091', '01020111220000123456', 'Lunes a Domingo 08:00-19:00',
    'contacto@cafesanjacinto.ve', '+58-212-5553311', '+58-414-5553312'
);

CALL sp_registrar_comercio_aliado(
    'J-50987654-3', 'ComercioAvila2026!',
    'Posada y Fogón Galipán S.R.L.', 'Gastronomía de Montaña', 60,
    'PS-MIR-2026-0412', '01080222330000654321', 'Miércoles a Domingo 09:00-20:00',
    'reservas@fogongalipan.ve', '+58-212-5554422', '+58-424-5554423'
);

-- 10. Entes Públicos Patrimoniales (HU-06)
CALL sp_registrar_ente_publico(
    'G-20001234-5', 'EnteIpc2026!',
    'Instituto del Patrimonio Cultural de Venezuela', 'nacional',
    'Dra. Beatriz Eugenia Tovar', 'Decreto Nro. 2.145 Gaceta Oficial 41.200',
    'patrimonio@ipc.gob.ve', '+58-212-4821100', '+58-212-4821199'
);

CALL sp_registrar_ente_publico(
    'G-20009876-1', 'EnteCaracas2026!',
    'Fundación para la Cultura y las Artes de Caracas', 'municipal',
    'Lic. Andrés Felipe Zambrano', 'Ordenanza Municipal de Patrimonio 04-2025',
    'enlace@fundarte.gob.ve', '+58-212-5418800', '+58-212-5418899'
);

-- 11. Experiencias Promocionales, Inclusión de Hitos, Visitas, Recorridos, Evaluaciones, Credenciales e Incidencias
INSERT INTO experiencia_promocional (
    titulo_experiencia, fecha_activacion, descripcion_detallada, precio_total, cupo_max_grupo,
    porcentaje_descuento, fecha_vencimiento, codigo_promocional, rif_comercio,
    nro_rtn_guia, cod_licencia_guia, nombre_estado_origen, nombre_municipio_origen, nombre_ruta
) VALUES
('Combo Bolívar y Cacao Mantuanos', '2026-11-01',
 'Recorrido guiado por el Casco Histórico de Caracas con cata de bombones de cacao criollo en Café San Jacinto.',
 850.00, 12, 15.00, '2027-03-31', 'BOLIVAR-CACAO-15', 'J-40123456-7',
 'RTN-CCS-1042', 'LIC-MINTUR-881', 'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora'),
('Travesía Neblina y Chocolate en el Ávila', '2026-11-10',
 'Visita guiada en la cima del Warairarepano y almuerzo típico de montaña en Posada y Fogón Galipán.',
 1450.00, 8, 10.00, '2027-04-30', 'AVILA-NEBLINA-10', 'J-50987654-3',
 'RTN-MIR-2075', 'LIC-MINTUR-914', 'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila');

INSERT INTO experiencia_incluye_hito (
    titulo_experiencia, fecha_activacion, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito
) VALUES
('Combo Bolívar y Cacao Mantuanos', '2026-11-01', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador'),
('Combo Bolívar y Cacao Mantuanos', '2026-11-01', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('Travesía Neblina y Chocolate en el Ávila', '2026-11-10', 'Miranda', 'Chacao', 'Chacao', 'Estación Warairarepano Pico Ávila');

INSERT INTO visita_hito (
    cedula_pasaporte, nombre_estado, nombre_municipio, nombre_parroquia, nombre_hito, fecha_hora_visita
) VALUES
('V-28451902', 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas', '2026-11-12 10:30:00'),
('V-30821466', 'Distrito Capital', 'Libertador', 'Catedral', 'Casa Natal del Libertador', '2026-11-14 11:00:00'),
('P-FR994821', 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt', '2026-11-18 14:20:00');

INSERT INTO recorrido_realizado (
    cedula_pasaporte, fecha_hora_inicio, fecha_hora_fin, completado,
    nombre_estado_origen, nombre_municipio_origen, nombre_ruta
) VALUES
('V-28451902', '2026-11-12 09:15:00', '2026-11-12 12:10:00', TRUE, 'Distrito Capital', 'Libertador', 'Ruta Histórica Libertadora'),
('P-FR994821', '2026-11-18 10:00:00', '2026-11-18 15:00:00', TRUE, 'Miranda', 'Chacao', 'Ruta del Cacao y Neblina Ávila');

INSERT INTO evaluacion_experiencia (
    codigo_resena, calif_estrellas, indice_seguridad, fecha_emision, opinion_detallada,
    cedula_pasaporte, fecha_hora_inicio_rec,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito
) VALUES
('RES-2026-0001', 5, 5, '2026-11-12 13:00:00',
 'Excelente accesibilidad en el bulevar y muy buena atención en la Casa Natal del Libertador.',
 'V-28451902', '2026-11-12 09:15:00',
 'Distrito Capital', 'Libertador', 'Catedral', 'Plaza Bolívar de Caracas'),
('RES-2026-0002', 5, 4, '2026-11-18 16:30:00',
 'Paisaje inolvidable desde el Mirador del Hotel Humboldt y guía bilingüe muy preparado.',
 'P-FR994821', '2026-11-18 10:00:00',
 'Miranda', 'Chacao', 'Chacao', 'Mirador Circular Hotel Humboldt');

INSERT INTO credencial_acceso (
    codigo_verificacion, fecha_hora_programada, monto_abonado, cantidad_beneficiarios,
    estado_pase, cedula_pasaporte, titulo_experiencia, fecha_activacion
) VALUES
('RVZ-PASS-7741A', '2026-11-12 09:00:00', 722.50, 1, 'canjeado', 'V-28451902', 'Combo Bolívar y Cacao Mantuanos', '2026-11-01'),
('RVZ-PASS-8832B', '2026-11-28 10:00:00', 2610.00, 2, 'emitido', 'P-FR994821', 'Travesía Neblina y Chocolate en el Ávila', '2026-11-10');

INSERT INTO reporte_incidencia (
    fecha_hora_deteccion, fecha_est_resolucion, prorroga_justificada, narrativa_evento,
    estado_reporte, nivel_severidad,
    cedula_pasaporte_reporta, nro_rtn_reporta, cod_licencia_reporta, rif_gub_reporta,
    rif_gub_validador, codigo_via_afectada,
    nombre_estado_hito, nombre_municipio_hito, nombre_parroquia_hito, nombre_hito_afectado
) VALUES
('2026-11-20 08:30:00', '2026-11-27 17:00:00', NULL,
 'Desprendimiento menor de adoquines frente a la esquina de San Jacinto; paso peatonal reducido.',
 'preliminar', 'bajo',
 'V-28451902', NULL, NULL, NULL,
 NULL, 'VIA-CCS-01', NULL, NULL, NULL, NULL),
('2026-11-15 09:00:00', '2026-12-15 18:00:00', 'Prórroga aprobada por trabajos estructurales de drenaje en San José.',
 'Cierre total de Callejón Sur Anauco por sustitución de colector pluvial.',
 'activo', 'medio',
 NULL, NULL, NULL, 'G-20009876-1',
 'G-20009876-1', 'VIA-CCS-04', NULL, NULL, NULL, NULL);
