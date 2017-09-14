CREATE OR REPLACE FUNCTION formularios.spPrincipalInsert
(
	IN _tipo_accion integer default 0::integer
	, IN _razon_social TEXT default ''
	, IN _paraje varchar(100) default ''
	, IN _coordenadas_utm_x numeric(7,0) default 0::numeric(7,0)
  	, IN _coordenadas_utm_y numeric(7,0) default 0::numeric(7,0)
  	, IN _metros_sobre_nivel_mar numeric(5,0) default 0::numeric(5,0)
  	, IN _fecha_inicio varchar(15) default ''
  	, IN _fecha_termino varchar(15) default''
  	, IN _zona_critica integer default 0::integer
  	, IN _total_participantes integer default 0::integer
  	, IN _vehiculos_irregularidades numeric(5,0) default 0::numeric(5,0)
  	, IN _vehiculos_sin_irregularidades integer default 0::integer
  	, IN _vehiculos_revisados varchar(255) default ''
  	, IN _total_personas integer default 0::integer
  	, IN _num_orden varchar(80) default ''
  	, IN _tipo_documento integer default 0::integer
  	, IN _num_documento TEXT default ''
  	, IN _dependencia_expide_documento integer default 0::integer
  	, IN _agencia_ministerio_solicita_dictamen integer default 0::integer
  	, IN _medidas_seguridad integer default 0::integer
  	, IN _inspector_forestal integer default 0::integer
  	, IN _valor_comercial numeric(10,2) default 0::numeric(10,2)
  	, IN _impacto_ambiental numeric(10,2) default 0::numeric(10,2)
  	, IN _reparacion_danio numeric(10,2) default 0::numeric(10,2)
  	, IN _total_dictamen numeric(10,2) default 0::numeric(10,2)
  	, IN _observaciones varchar(1000) default ''
  	, IN _anio integer default 0::integer
  	, IN _region integer default 0::integer
  	, IN _modulopredio_estado integer default 0::integer
  	, IN _modulopredio_municipio integer default 0::integer
  	, IN _modulopredio_localidad integer default 0::integer
  	, IN _modulopredio_cup TEXT default ''
  	, IN _codigo_identificacion varchar(80) default ''
  	, IN _registro_forestal_nacional varchar(80) default ''
  	, IN _estatus_industria integer default 0::integer  	
)
returns varchar(15) as

$BODY$
	DECLARE
	SQL_QUERY TEXT;
	vConsecutivo integer;
	vSubFolio varchar(6);
	vFolio varchar(15);
	BEGIN
		vSubFolio:= 'IV'||SUBSTRING(CAST(_anio AS VARCHAR(5)), 3, 4)||'0'||_region;
		
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
  						, tipo_accion
  						, razon_social
  						, paraje
  						, coordenadas_utm_x
  						, coordenadas_utm_y
  						, metros_sobre_nivel_mar
  						, fecha_inicio
  						, fecha_termino
  						, zona_critica
  						, total_participantes
  						, vehiculos_irregularidades
  						, vehiculos_sin_irregularidades
  						, vehiculos_revisados
  						, total_personas
  						, num_orden
  						, tipo_documento
  						, num_documento
  						, dependencia_expide_documento
  						, agencia_ministerio_solicita_dictamen
  						, medidas_seguridad
  						, inspector_forestal
  						, valor_comercial
  						, impacto_ambiental
  						, reparacion_danio
  						, total_dictamen
  						, observaciones
  						, anio
  						, region
  						, modulopredio_estado
  						, modulopredio_municipio
  						, modulopredio_localidad
  						, modulopredio_cup
  						, codigo_identificacion
  						, registro_forestal_nacional
  						, estatus_industria
  						, estatus_juridico
					)';

		SQL_QUERY:= SQL_QUERY || 'VALUES ('''||vFolio||''', ';

		IF(_tipo_accion = NULL OR _tipo_accion = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_tipo_accion||', ';
		END IF;

		IF(_razon_social = NULL OR _razon_social = '' OR _razon_social = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_razon_social||''', ';
		END IF;

		IF(_paraje = NULL OR _paraje = '' OR _paraje = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_paraje||''', ';
		END IF;

		IF(_coordenadas_utm_x = NULL OR _coordenadas_utm_x = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_coordenadas_utm_x||' AS numeric(7,0)), ';
		END IF;

		IF(_coordenadas_utm_y = NULL OR _coordenadas_utm_y = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_coordenadas_utm_y||' AS numeric(7,0)), ';
		END IF;

		IF(_metros_sobre_nivel_mar = NULL OR _metros_sobre_nivel_mar = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_metros_sobre_nivel_mar||' AS numeric(5,0)), ';
		END IF;

		IF(_fecha_inicio = NULL OR _fecha_inicio = '' OR _fecha_inicio = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('''||_fecha_inicio||''' AS date), ';
		END IF;

		IF(_fecha_termino = NULL OR _fecha_termino = '' OR _fecha_termino = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('''||_fecha_termino||''' AS date), ';
		END IF;

		IF(_zona_critica = NULL OR _zona_critica = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_zona_critica||', ';
		END IF;

		IF(_total_participantes = NULL OR _total_participantes = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_total_participantes||', ';
		END IF;

		IF(_vehiculos_irregularidades = NULL OR _vehiculos_irregularidades = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_vehiculos_irregularidades||' AS numeric(5,0)), ';
		END IF;

		IF(_vehiculos_sin_irregularidades = NULL OR _vehiculos_sin_irregularidades = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_vehiculos_sin_irregularidades||', ';
		END IF;

		IF(_vehiculos_revisados = NULL OR _vehiculos_revisados = '' OR _vehiculos_revisados = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_vehiculos_revisados||''', ';
		END IF;

		IF(_total_personas = NULL OR _total_personas = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_total_personas||', ';
		END IF;

		IF(_num_orden = NULL OR _num_orden = '' OR _num_orden = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_num_orden||''', ';
		END IF;

		IF(_tipo_documento = NULL OR _tipo_documento = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_tipo_documento||', ';
		END IF;

		IF(_num_documento = NULL OR _num_documento = '' OR _num_documento = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_num_documento||''', ';
		END IF;

		IF(_dependencia_expide_documento = NULL OR _dependencia_expide_documento = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_dependencia_expide_documento||', ';
		END IF;

		IF(_agencia_ministerio_solicita_dictamen = NULL OR _agencia_ministerio_solicita_dictamen = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_agencia_ministerio_solicita_dictamen||', ';
		END IF;

		IF(_medidas_seguridad = NULL OR _medidas_seguridad = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_medidas_seguridad||', ';
		END IF;

		IF(_inspector_forestal = NULL OR _inspector_forestal = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_inspector_forestal||', ';
		END IF;

		IF(_valor_comercial = NULL OR _valor_comercial = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_valor_comercial||' AS numeric(10,2)), ';
		END IF;

		IF(_impacto_ambiental = NULL OR _impacto_ambiental = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_impacto_ambiental||' AS numeric(10,2)), ';
		END IF;

		IF(_reparacion_danio = NULL OR _reparacion_danio = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_reparacion_danio||' AS numeric(10,2)), ';
		END IF;

		IF(_total_dictamen = NULL OR _total_dictamen = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || 'CAST('||_total_dictamen||' AS numeric(10,2)), ';
		END IF;

		IF(_observaciones = NULL OR _observaciones = '' OR _observaciones = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_observaciones||''', ';
		END IF;

		SQL_QUERY:= SQL_QUERY ||''||_anio||', ';

		SQL_QUERY:= SQL_QUERY ||''||_region||', ';

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

		IF(_modulopredio_cup = NULL OR _modulopredio_cup = '' OR _modulopredio_cup = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_modulopredio_cup||''', ';
		END IF;

		IF(_codigo_identificacion = NULL OR _codigo_identificacion = '' OR _codigo_identificacion = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_codigo_identificacion||''', ';
		END IF;

		IF(_registro_forestal_nacional = NULL OR _registro_forestal_nacional = '' OR _registro_forestal_nacional = ' ')
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''''||_registro_forestal_nacional||''', ';
		END IF;

		IF(_estatus_industria = NULL OR _estatus_industria = 0)
			THEN 
				SQL_QUERY:= SQL_QUERY || 'NULL, ';
			ELSE
				SQL_QUERY:= SQL_QUERY || ''||_estatus_industria||', ';
		END IF;

		SQL_QUERY:= SQL_QUERY || 'FALSE)';

		EXECUTE SQL_QUERY;
		RETURN vFolio;
	END;
$BODY$
LANGUAGE 'plpgsql'

SELECT spPrincipalInsert AS result FROM formularios.spPrincipalInsert(1, 'Prueba 1', 'Prueba 1', 1, 1, 1, '2017-01-01', '2017-01-01', 1, 1, 1, 1, 'Prueba 1', 1
	, 'Prueba 1', 1, 'Prueba 1', 1, 1, 1, 1, 1, 1, 1, 1, 'Prueba 1', 2016, 2, 1, 1, 1, 'Prueba 1', 'Prueba 1', 'Prueba 1', 1)
