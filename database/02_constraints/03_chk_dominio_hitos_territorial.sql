-- ============================================================================
-- Proyecto: RutasVenezuela (Plataforma de Rutas Turísticas y Culturales)
-- Archivo:  database/02_constraints/03_chk_dominio_hitos_territorial.sql
-- Autor:    Gabriel López (C.I. 30.821.466)
-- Alcance:  Restricciones de dominio, unicidad local y 3D para jerarquía
--           territorial e hitos (HU-09 a HU-14, RE-01, RE-02, RE-03).
-- ============================================================================

-- Jerarquía Político-Territorial (HU-09)
ALTER TABLE estado
    ADD CONSTRAINT chk_estado_nombre_no_vacio
        CHECK (BTRIM(nombre_estado) <> '');

ALTER TABLE municipio
    ADD CONSTRAINT chk_municipio_nombre_no_vacio
        CHECK (BTRIM(nombre_municipio) <> '');

ALTER TABLE parroquia
    ADD CONSTRAINT chk_parroquia_nombre_no_vacio
        CHECK (BTRIM(nombre_parroquia) <> '');

-- Hitos Turísticos y Culturales (HU-10 a HU-14, RE-01, RE-03)
ALTER TABLE hito
    ADD CONSTRAINT chk_hito_campos_no_vacios
        CHECK (BTRIM(nombre_hito) <> '' AND BTRIM(historia) <> ''),
    ADD CONSTRAINT chk_hito_estado_operativo
        CHECK (estado_operativo IN (
            'disponible',
            'en restauracion',
            'clausurado temporalmente',
            'cerrado permanentemente'
        )),
    ADD CONSTRAINT chk_hito_coordenadas_geodesicas
        CHECK (
            latitud BETWEEN -90 AND 90 AND
            longitud BETWEEN -180 AND 180 AND
            altitud_msnm BETWEEN -500 AND 9000
        ),
    -- HU-13: Permite compartir latitud/longitud siempre que difiera la altitud/elevación
    ADD CONSTRAINT uq_hito_coordenada_3d
        UNIQUE (latitud, longitud, altitud_msnm);

-- HU-12: Garantiza unicidad del nombre normalizado dentro del mismo Municipio y Parroquia
CREATE UNIQUE INDEX uq_hito_nombre_normalizado_parroquia
    ON hito (
        LOWER(BTRIM(nombre_estado)),
        LOWER(BTRIM(nombre_municipio)),
        LOWER(BTRIM(nombre_parroquia)),
        LOWER(BTRIM(nombre_hito))
    );

-- Categorías, Horarios y Cronogramas del Hito (HU-10, HU-14, RE-02)
ALTER TABLE categoria_hito
    ADD CONSTRAINT chk_categoria_hito_catalogo
        CHECK (categoria_hito IN (
            'historico',
            'religioso',
            'natural',
            'gastronomico',
            'recreativo',
            'descanso'
        ));

ALTER TABLE horario_hito
    ADD CONSTRAINT chk_horario_hito_no_vacio
        CHECK (BTRIM(horario_visita) <> '');

ALTER TABLE cronograma_evento_hito
    ADD CONSTRAINT chk_cronograma_evento_no_vacio
        CHECK (BTRIM(cronograma_eventos) <> '');
