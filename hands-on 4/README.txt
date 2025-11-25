# Analizador Léxico para Subconjunto de C

## Integrantes del Equipo
- Benjamin Ordaz Garcia
- [Nombre de tu compañero si lo tienes]

## Descripción
Este analizador léxico implementado en Flex es capaz de reconocer los tokens fundamentales de un subconjunto del lenguaje C, incluyendo:

- **Palabras reservadas**: `int`, `float`, `double`, `char`, `void`, `short`, `return`, `include`, `define`
- **Identificadores**: Nombres de variables, funciones, macros y librerías
- **Literales numéricos**: Enteros y flotantes
- **Operadores**: `+`, `-`, `*`, `/`, `++`, `=`
- **Delimitadores**: `(){};,<>`
- **Comentarios**: `/* ... */` y `//`
- **Directivas de preprocesador**: `#include`, `#define`

## Instrucciones de Compilación y Ejecución

### Prerrequisitos
- WinFlexBison instalado y en el PATH
- Compilador C (GCC)

### Compilación
1. Abrir línea de comandos en la carpeta del proyecto
2. Ejecutar los siguientes comandos:

```cmd
win_flex lexer.l
gcc -o lexer.exe lex.yy.c

###Ejecución
lexer.exe input.c
