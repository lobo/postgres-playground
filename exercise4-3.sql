Se pide crear la función nvecinos que recibe como parámetro el nombre de un país, un código postal, 
que llamaremos código postal inicial, y un número e 

inserta en la tabla MUESTRA, dicho código postal más 
sus N códigos postales vecinos, invocando a la función inserta_estado creada en el ítem 4.2.

CREATE OR REPLACE FUNCTION nvecinos(IN VARCHAR nombre_pais, IN VARCHAR codigo_postal_inicial, IN integer numero)
RETURNS varchar AS
$$
  BEGIN
  	-- Dado que la tabla MUESTRA puede no estar vacía, esta función debe ocuparse de vaciarla 
  	-- totalmente antes de comenzar las inserciones.
  	TRUNCATE muestra; -- ver si agregar CASCADE; o no

    -- FOR i IN numero LOOP
   	--	INSERT INTO playtime.meta_random_sample (col_i, col_id) -- use col names
   	--	SELECT i, id
   	--	FROM   tbl
   	--	ORDER  BY random()
   	--	LIMIT  15000;
	-- END LOOP;

	IF numero == 0 THEN
		--Raise exception 'SIN TUPLAS O SUELDOS NULL' USING ERRCODE = 'PP111';
	ELSE IF numero < 0 THEN
		-- NO SE HACE NADA
	END IF;


    INSERT INTO MUESTRA(nombre_pais, codigo_postal_inicial, city, status, quantity)
  END;
$$ LANGUAGE plpgSQL;
