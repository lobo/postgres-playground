create table muestra(
country  	TEXT,
postalcode	TEXT,
city		TEXT,
quantity	TEXT,
status	TEXT CHECK( status IN ('ACTIVO', 'EXPIRADO')),
PRIMARY KEY(postalcode, country, status));
