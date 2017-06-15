## Pasos para importar el archivo `.csv` desde una terminal

1. Conectarse a `psql`
2. Usando el comando `\cd` ir hasta la ubicacion del archivo `whois-sample.csv`
3. Una vez en el path correcto, correr: `\copy whois_sample from 'whois-sample.csv' using delimiters ';' csv header ;`
4. Notar que se le deben dar permisos de lectura y ejecución al usuario de la base de datos.
