CREATE OR REPLACE FUNCTION inserta_estado(IN country TEXT, IN postalCode TEXT)
RETURNS VOID
AS $$ 
DECLARE
  activeCityAns TEXT;
  expiredCityAns TEXT;
  activeQuantity INTEGER;
  expiredQuantity INTEGER;
BEGIN

IF EXISTS (SELECT 1 FROM whois_sample WHERE postalCode = registrant_postalCode AND registrant_country = country) THEN
        SELECT count(*) INTO activeQuantity 
                FROM whois_sample 
                WHERE postalCode = registrant_postalCode 
                AND registrant_country = country
                AND  expiresDate >= (select CURRENT_TIMESTAMP);
                
        SELECT count(*) INTO expiredQuantity 
                FROM whois_sample 
                WHERE postalCode = registrant_postalCode 
                AND registrant_country = country
                AND expiresDate < (select CURRENT_TIMESTAMP);
                
                
        SELECT registrant_city INTO ActiveCityAns
        FROM whois_sample
         WHERE registrant_postalCode = postalCode 
         AND registrant_country = country
         AND  expiresDate >= (select CURRENT_TIMESTAMP)
         ORDER BY registrant_city ASC
         LIMIT 1 OFFSET  activeQuantity/2;
        
        IF NOT FOUND THEN
                 INSERT INTO muestra VALUES (country, postalCode, '', 'ACTIVO', 0 );
        ELSE
                INSERT INTO muestra VALUES (country, postalCode, activeCityAns, 'ACTIVO', activeQuantity );
        END IF;
                          
        SELECT registrant_city INTO ExpiredCityAns
        FROM whois_sample
         WHERE registrant_postalCode = postalCode 
         AND registrant_country = country
         AND  expiresDate < (select CURRENT_TIMESTAMP)
         ORDER BY registrant_city ASC
         LIMIT 1 OFFSET  expiredQuantity/2;
                          
        IF NOT FOUND THEN
                INSERT INTO muestra VALUES (country, postalCode, '', 'EXPIRADO', 0 );
        ELSE
                INSERT INTO muestra VALUES (country, postalCode, expiredCityAns, 'EXPIRADO', expiredQuantity );
        END IF;
        
END IF;
        EXCEPTION
        
        WHEN SQLSTATE '23505' THEN
         raise notice '% % ', SQLSTATE, SQLERRM;
        WHEN OTHERS THEN
        raise notice 'error';
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION nvecinos(IN country TEXT, IN postalCode TEXT, IN num INTEGER)
RETURNS VOID
AS $$ 
DECLARE
 postalCodeValues TEXT;
 pc TEXT;
 pcNext TEXT;
myCursor CURSOR FOR
 SELECT  registrant_postalCode
FROM (SELECT DISTINCT registrant_postalCode FROM whois_sample WHERE registrant_country = country ) AS pc1
ORDER BY registrant_postalCode ASC
 LIMIT num+1 OFFSET (SELECT RowNr
                FROM (
                    SELECT 
                         ROW_NUMBER() OVER (ORDER BY registrant_postalCode ASC) AS RowNr , registrant_postalCode
                    FROM (SELECT DISTINCT registrant_postalCode, registrant_country FROM whois_sample WHERE registrant_country = country ) AS pc2
                ) sub
                WHERE sub.registrant_postalCode = postalCode )-1;
BEGIN
        TRUNCATE muestra;
     IF num > 0 THEN   
        SELECT registrant_postalCode INTO pc
        FROM whois_sample
        WHERE registrant_postalCode = postalCode;
        
        IF NOT FOUND THEN
               SELECT MIN(registrant_postalCode) INTO pcNext
               FROM (SELECT DISTINCT registrant_postalCode FROM whois_sample WHERE registrant_country = country) AS pc1
               WHERE registrant_postalCode > postalCode;
                                        
                                        IF NOT FOUND THEN
                                        ELSE    
                                                PERFORM nvecinos( country, pcNext, num); 
                                        END IF;
                
        ELSE
                OPEN myCursor;
                        LOOP
                                FETCH myCursor INTO postalCodeValues;
                                EXIT WHEN NOT FOUND;
                                PERFORM inserta_estado(country, postalCodeValues); 
                        END LOOP;
                CLOSE myCursor;
        END IF;
     ELSEIF num = 0 THEN
          PERFORM inserta_estado(country, postalCode); 
     END IF;   

END;
$$ LANGUAGE plpgsql;
        




