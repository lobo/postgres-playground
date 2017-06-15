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

CREATE OR REPLACE FUNCTION prueba(IN country TEXT, IN postalCode TEXT)
RETURNS VOID
AS $$ 
DECLARE
  cityAns TEXT;
  activeQuantity INTEGER;
  expiredQuantity INTEGER;
BEGIN


SELECT count(*) INTO activeQuantity 
  FROM whois_sample 
  WHERE postalCode = registrant_postalCode AND  expiresDate >= (select CURRENT_TIMESTAMP);
  
SELECT count(*) INTO expiredQuantity 
  FROM whois_sample 
  WHERE postalCode = registrant_postalCode AND expiresDate < (select CURRENT_TIMESTAMP);
  
  
SELECT registrant_city INTO cityAns
FROM whois_sample
 WHERE registrant_postalCode = postalCode AND registrant_country = country
 ORDER BY registrant_city ASC
 LIMIT 1 OFFSET  (SELECT (COUNT(registrant_city)/2)+1
                  FROM whois_sample
                  WHERE registrant_postalCode = postalCode AND registrant_country = country)-1;
IF NOT FOUND THEN 
ELSE
INSERT INTO muestra VALUES (country, postalCode, cityAns, 'ACTIVO', activeQuantity );
INSERT INTO muestra VALUES (country, postalCode, cityAns, 'EXPIRADO', expiredQuantity ); 
END IF;

EXCEPTION

WHEN SQLSTATE '23505' THEN
 raise notice '% % ', SQLSTATE, SQLERRM;
WHEN OTHERS THEN
raise notice 'error';
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
 PERFORM prueba('AUSTRALIA', '2142');
END;
$$;






