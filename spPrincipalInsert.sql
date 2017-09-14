CREATE OR REPLACE FUNCTION formularios.spPrincipalInsert
(
	IN _expediente varchar(30) default ''
	, IN _expediente_origen varchar(30) default ''
	, IN _region integer default 0::integer
	, IN _id_tipo_propiedad integer default 0::integer
	, IN _representante_actual varchar(255) default ''
	, IN _representante_original varchar(255) default ''
	, IN _rfc varchar(15) default ''
	, IN _domicilio varchar(255) default ''
	, IN _responsable_tecnico_ejecucion_vigente integer default 0::integer
	, IN _responsable_tecnico_ejecucion_original integer default 0::integer
	, IN _tipo_autorizacion integer default 0::integer
	, IN _dependencia_expide integer default 0::integer
	, IN _codigo_semarnat varchar(200) default ''
	, IN _oficio_autorizacion varchar(60) default ''
	, IN _fecha_expedicion varchar(15) default ''
	, IN _fecha_vencimiento varchar(15) default ''
	, IN _usufructuarios numeric(10,2) default ''
	, IN _metodo_manejo integer default 0::integer
	, IN _superficie_total numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_anp_federal numeric(10,2) default 0::numeric(10,2) 
	, IN _superficie_conservacion numeric(10,2) default 0::numeric(10,2)
	, IN _franja_protectora numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_pendientes numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_msnm numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_bosque_mesofilo numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_produccion numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_restauracion numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_otros_usos numeric(10,2) default 0::numeric(10,2)
	, IN _superficie_arbolada numeric(10,2) default 0::numeric(10,2)
	, IN _nombre_apn integer default 0::integer
	, IN _nivel_programa_manejo_forestal integer default 0::integer
	, IN _num_intervenciones numeric(8,2) default 0::numeric(8,2)
	, IN _situacion_especial_predio varchar(80) default ''
	, IN _fecha_situacion varchar(15) default ''
	, IN _anio integer default 0::integer
	, IN _modulopredio_estado integer default 0::integer
	, IN _modulopredio_municipio integer default 0::integer
	, IN _modulopredio_localidad integer default 0::integer
	, IN _modulopredio_cup varchar(20) default ''
	, IN _latitud_utm numeric(7,0) default 0::numeric(7,0)
	, IN _longitud_utm numeric(6,0) default 0::numeric(6,0)
)
return varchar(15) as

$BODY$
	DECLARE
	SQL_QUERY TEXT;
	vConsecutivo integer;
	vSubFolio varchar(6);
	vFolio varchar(15);
	BEGIN
		vSubFolio:= 'AM'||SUBSTRING(CAST(_anio AS VARCHAR(5)), 3, 4)||'0'||_region;
		
		vConsecutivo:= (SELECT CASE WHEN MAX(CAST(SUBSTRING(folio, 7, 9) AS INTEGER)) IS NULL OR MAX(CAST(substring(folio, 7, 9) AS INTEGER)) = 0 THEN 1 ELSE MAX(CAST(substring(folio, 7, 9) AS INTEGER)) + 1 END
							FROM formularios.principal
						WHERE folio like vSubFolio||'%');

		IF(vConsecutivo < 10)
			THEN
				vFolio:= vSubFolio||'00'||vConsecutivo;
			ELSE
			IF(vConsecutivo > 9 AND vConsecutivo < 100)
				THEN
					vFolio:= vSubFolio||'0'||vConsecutivo;
				ELSE
					vFolio:= vSubFolio||vConsecutivo;
			END IF;
		END IF;

		SQL_QUERY = 'INSERT INTO formularios.principal
					(
						folio
						, expediente
						, expediente_origen
						, region
						, id_tipo_propiedad
						, representante_actual
						, representante_original
						, rfc
						, domicilio
						, responsable_tecnico_ejecucion_vigente
						, responsable_tecnico_ejecucion_original
						, tipo_autorizacion
						, dependencia_expide
						, codigo_semarnat
						, oficio_autorizacion
						, fecha_expedicion
						, fecha_vencimiento
						, usufructuarios
						, metodo_manejo
						, superficie_total
						, superficie_anp_federal
						, superficie_conservacion
						, franja_protectora
						, superficie_pendientes
						, superficie_msnm
						, superficie_bosque_mesofilo
						, superficie_produccion
						, superficie_restauracion
						, superficie_otros_usos
						, superficie_arbolada
						, nombre_apn
						, nivel_programa_manejo_forestal
						, num_intervenciones
						, situacion_especial_predio
						, fecha_situacion
						, anio
						, modulopredio_estado
						, modulopredio_municipio
						, modulopredio_localidad
						, modulopredio_cup
						, latitud_utm
						, longitud_utm
					)';

		SQL_QUERY:= SQL_QUERY || 'VALUES ('||vFolio||', ';

		IF(_expediente = NULL OR _expediente = '' OR _expediente = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_expediente||''', ';
		END IF;

		IF(_expediente_origen = NULL OR _expediente_origen = '' OR _expediente_origen = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_expediente_origen||''', ';
		END IF;

		SQL_QUERY:= SQL_QUERY || ''||_region||', ';
		
		IF(_id_tipo_propiedad = NULL OR _id_tipo_propiedad = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_id_tipo_propiedad||', ';
		END IF;

		IF(_representante_actual = NULL OR _representante_actual = '' OR _representante_actual = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_representante_actual||''', ';
		END IF;

		IF(_representante_original = NULL OR _representante_original = '' OR _representante_original = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_representante_original||''', ';
		END IF;

		IF(_rfc = NULL OR _rfc = '' OR _rfc = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_rfc||''', ';
		END IF;

		IF(_domicilio = NULL OR _domicilio = '' OR _domicilio = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_domicilio||''', ';
		END IF;

		IF(_responsable_tecnico_ejecucion_vigente = NULL OR _responsable_tecnico_ejecucion_vigente = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_responsable_tecnico_ejecucion_vigente||', ';
		END IF;

		IF(_responsable_tecnico_ejecucion_original = NULL OR _responsable_tecnico_ejecucion_original = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_responsable_tecnico_ejecucion_original||', ';
		END IF;

		IF(_tipo_autorizacion = NULL OR _tipo_autorizacion = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''_tipo_autorizacion', ';
		END IF;

		IF(_dependencia_expide = NULL OR _dependencia_expide = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''_dependencia_expide', ';
		END IF;

		IF(_codigo_semarnat = NULL OR _codigo_semarnat = '' OR _codigo_semarnat = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_codigo_semarnat||''', ';
		END IF;

		IF(_oficio_autorizacion = NULL OR _oficio_autorizacion = '' OR _oficio_autorizacion = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_oficio_autorizacion||''', ';
		END IF;

		IF(_fecha_expedicion = NULL OR _fecha_expedicion = '' OR _fecha_expedicion = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('''||_fecha_expedicion||''' AS date, ';
		END IF;

		IF(_fecha_vencimiento = NULL OR _fecha_vencimiento = '' OR _fecha_vencimiento = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('''||_fecha_vencimiento||''' AS date, ';
		END IF;

		IF(_usufructuarios = NULL OR _usufructuarios = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_usufructuarios||' AS numeric(10,2), ';
		END IF;

		IF(_metodo_manejo = NULL OR _metodo_manejo = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_metodo_manejo||', ';
		END IF;

		IF(_superficie_total = NULL OR _superficie_total = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_total||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_anp_federal = NULL OR _superficie_anp_federal = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_anp_federal||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_conservacion = NULL OR _superficie_conservacion = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_conservacion||' AS numeric(10,2), ';
		END IF;

		IF(_franja_protectora = NULL OR _franja_protectora = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_franja_protectora||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_pendientes = NULL OR _superficie_pendientes = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_pendientes||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_msnm = NULL OR _superficie_msnm = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_msnm||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_bosque_mesofilo = NULL OR _superficie_bosque_mesofilo = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_bosque_mesofilo||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_produccion = NULL OR _superficie_produccion = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_produccion||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_restauracion = NULL OR _superficie_restauracion = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_restauracion||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_otros_usos = NULL OR _superficie_otros_usos = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_otros_usos||' AS numeric(10,2), ';
		END IF;

		IF(_superficie_arbolada = NULL OR _superficie_arbolada = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_superficie_arbolada||' AS numeric(10,2), ';
		END IF;

		IF(_nombre_apn = NULL OR _nombre_apn = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_nombre_apn||', ';
		END IF;

		IF(_nivel_programa_manejo_forestal = NULL OR _nivel_programa_manejo_forestal = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_nivel_programa_manejo_forestal||', ';
		END IF;

		IF(_num_intervenciones = NULL OR _num_intervenciones = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_num_intervenciones||' AS numeric(8,2), ';
		END IF;

		IF(_situacion_especial_predio = NULL OR _situacion_especial_predio = '' OR _situacion_especial_predio = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_situacion_especial_predio||''', ';
		END IF;

		IF(_fecha_situacion = NULL OR _fecha_situacion = '' OR _fecha_situacion = ' ')
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('''||_fecha_situacion||''' AS date, ';
		END IF;

		SQL_QUERY:= SQL_QUERY || ''||_anio||', ';

		IF(_modulopredio_estado = NULL OR _modulopredio_estado = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_modulopredio_estado||', ';
		END IF;

		IF(_modulopredio_municipio = NULL OR _modulopredio_municipio = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_modulopredio_municipio||', ';
		END IF;

		IF(_modulopredio_localidad = NULL OR _modulopredio_localidad = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_modulopredio_localidad||', ';
		END IF;

		IF(_modulopredio_cup = NULL OR _modulopredio_cup = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_modulopredio_cup||', ';
		END IF;

		IF(_latitud_utm = NULL OR _latitud_utm = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_latitud_utm||' AS numeric(7,0), ';
		END IF;

		IF(_longitud_utm = NULL OR _longitud_utm = 0)
			THEN
				SQL_QUERY:= SQL_QUERY || 'NULL)';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_longitud_utm||' AS numeric(6,0))';
		END IF;

		EXECUTE SQL_QUERY;
		RETURN vFolio;
	END
$BODY$
LANGUAGE 'plpgsql'


