
/*
SELECT registrant_city
FROM whois_sample
WHERE registrant_postalCode = '32258' AND registrant_country = 'UNITED STATES'
ORDER BY registrant_city ASC
LIMIT 1 OFFSET  (SELECT (COUNT(registrant_city)/2)+1
                 FROM whois_sample
                 WHERE registrant_postalCode = '32258' AND registrant_country = 'UNITED STATES')
                 */

CREATE OR REPLACE FUNCTION prueba(IN country TEXT, IN postalCode TEXT)
RETURNS VOID
AS $$ 
DECLARE
  rta TEXT;
BEGIN
SELECT registrant_city INTO rta
FROM whois_sample
 WHERE registrant_postalCode = postalCode AND registrant_country = country
 ORDER BY registrant_city ASC
 LIMIT 1 OFFSET  (SELECT (COUNT(registrant_city)/2)+1
                  FROM whois_sample
                  WHERE registrant_postalCode = postalCode AND registrant_country = country);

Raise notice '%',rta;
END;
$$ LANGUAGE plpgsql;

DO $$
BEGIN
 PERFORM prueba('UNITED STATES', '32258');
END;
$$;