CREATE TABLE whois_sample 
(
domainName TEXT PRIMARY KEY,
registrarName TEXT,
contactEmail TEXT,
whoisServer TEXT,
nameServer	TEXT,
createdDate DATE,
updatedDate DATE,
expiresDate DATE,
status		TEXT,
registrant_email TEXT,
registrant_name 	TEXT,
registrant_organization TEXT,
registrant_street1 TEXT, 
registrant_street2 TEXT, 
registrant_city TEXT,
registrant_state TEXT,
registrant_postalCode TEXT,
registrant_country TEXT,
registrant_fax TEXT,
registrant_telephone TEXT
);
