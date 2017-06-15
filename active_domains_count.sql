CREATE OR REPLACE FUNCTION active_domains_count()
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
 PERFORM active_domains_count();
END;
$$;