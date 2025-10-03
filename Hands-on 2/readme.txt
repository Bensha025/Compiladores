Este proyecto es una variante de la actividad original, cuyo propósito es validar un archivo JSON que contenga únicamente los campos obligatorios:
firstName
lastName
El programa permite ingresar n cantidad de entradas en el JSON, hasta que el usuario decida detener el proceso.

El siguiente codigo es la actividad, la cual está diseñado para validar datos en formato JSON que representen una lista de empleados.
Puede introducir n cantidad de parámetros
El JSON debe tener la estructura:

{"employees":[{"firstName":"John","lastName":"Doe"}]}
o
{"employees":[{"firstName":"John","lastName":"Doe"},{"firstName":"Anna","lastName":"Smith"}]}

Ejemplo de entrada inválida:
{"employees":[{"firstName":"John","lastName":"Doe"},{"firstName":"Anna1","lastName":"121"}]}