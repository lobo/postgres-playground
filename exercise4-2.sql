/*
Se pide escribir la función inserta_estado que recibe como parámetro un país y un código postal
 e inserta en la tabla MUESTRA dos tuplas representativas con la siguiente información:

CREATE OR REPLACE FUNCTION inserta_estado(IN TEXT nombre_pais, IN TEXT codigo_postal)
RETURNS TEXT AS
$$
  BEGIN
  	-- TUPLA 1:
    INSERT INTO muestra VALUES(nombre_pais, codigo_postal, city, 'ACTIVO', quantity);
    -- TUPLA 2:
    INSERT INTO muestra VALUES(nombre_pais, codigo_postal, city, 'EXPIRADO', quantity);
  END;
$$ LANGUAGE plpgSQL;
*/

CREATE OR REPLACE FUNCTION inserta_estado(IN TEXT nombre_pais, IN TEXT codigo_postal)
RETURNS VOID
AS $$ 
DECLARE
  rta TEXT;
BEGIN

	SELECT count(*) INTO rta 
	FROM whois_sample 
	where expiresDate >= (select CURRENT_TIMESTAMP);

Raise notice '%',rta;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
 PERFORM inserta_estado('UNITED STATES', '32258');
END;
$$;









