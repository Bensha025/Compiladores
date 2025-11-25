# Analizador Sintáctico para Subconjunto de C

## Integrantes del Equipo
- Benjamin Ordaz Garcia
- Simón César Laguna Lemus

## Descripción
Este analizador sintáctico implementado con Flex y Bison valida la estructura sintáctica de un subconjunto del lenguaje C según las producciones definidas en la gramática.

### Elementos Sintácticos Validados

#### Producciones Principales
1. **program** → translation_unit
2. **translation_unit** → external_declaration | translation_unit external_declaration
3. **external_declaration** → function_definition | declaration | preprocessor_directive

#### Declaraciones y Definiciones
4. **function_definition** → type_specifier IDENTIFIER ( parameter_list ) compound_statement
5. **declaration** → type_specifier init_declarator_list ;
6. **parameter_list** → parameter_declaration | parameter_list , parameter_declaration

#### Estructuras de Control
7. **compound_statement** → { statement_list }
8. **selection_statement** → if ( expression ) statement | if ( expression ) statement else statement
9. **jump_statement** → return expression ; | return ;

#### Expresiones
10. **expression** → assignment_expression | expression , assignment_expression
11. **assignment_expression** → additive_expression | IDENTIFIER = assignment_expression
12. **additive_expression** → multiplicative_expression | additive_expression + multiplicative_expression
13. **multiplicative_expression** → primary_expression | multiplicative_expression * primary_expression

#### Elementos Básicos
14. **primary_expression** → IDENTIFIER | INTEGER_LITERAL | ( expression ) | IDENTIFIER ( argument_expression_list )

### Capacidades del Analizador
- Validar estructura de programas C completos
- Verificar declaraciones de variables globales y locales
- Validar definiciones de funciones y parámetros
- Comprobar estructuras de control anidadas
- Verificar expresiones aritméticas y asignaciones
- Reconocer directivas de preprocesador

## Instrucciones de Compilación y Ejecución

### Prerrequisitos
- WinFlexBison instalado y en el PATH
- Compilador C (MinGW-w64, GCC, o MSVC)

### Compilación
```cmd
win_bison -d -y parser.y
win_flex lexer.l
gcc -o parser.exe y.tab.c lex.yy.c

###Ejecución
parser.exe input.c