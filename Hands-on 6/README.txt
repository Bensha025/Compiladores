# Analizador Léxico, Sintáctico y Semántico para Subconjunto de C

## Integrantes del Equipo
- Benjamin Ordaz Garcia  
- Simón César Laguna Lemus

## Descripción
Este proyecto implementa un analizador completo (léxico, sintáctico y semántico) para un subconjunto del lenguaje C, desarrollado con **Flex** y **Bison**. Incluye gestión de tablas de símbolos y validación de scopes anidados.

---

## Características Implementadas

### Análisis Léxico (`lexer.l`)
- **Palabras reservadas**: `int`, `float`, `char`, `void`, `if`, `else`, `while`, `for`, `return`
- **Identificadores** y literales numéricos (enteros y reales)
- **Operadores relacionales**: `==`, `!=`, `<=`, `>=`, `&&`, `||`
- **Símbolos individuales**: `+`, `-`, `*`, `/`, `=`, `;`, `(`, `)`, `{`, `}`, `,`, `<`, `>`

### Análisis Sintáctico (`parser.y`)
**Producciones Principales:**
- `program` → `global_declarations`
- `function_definition` → `type IDENTIFIER '(' parameter_list ')' compound_statement`
- `variable_declaration` → `type IDENTIFIER` | `type IDENTIFIER '=' expression`
- `compound_statement` → `'{' local_declarations statement_list '}'`

**Estructuras de Control:**
- Sentencias `if-else` y `if` simples
- Bucles `while` y `for`
- Sentencias `return` con y sin expresión

### Análisis Semántico (`symbol_table.c/h`)
**Validaciones Implementadas:**
- Variables no declaradas (locales y globales)
- Redeclaración en mismo scope
- Número correcto de parámetros en funciones
- Llamadas a funciones no declaradas
- Scopes anidados para funciones y bloques

## Estructuras de Datos

```c
// Símbolo en la tabla
typedef struct Symbol {
    char *name;
    SymbolType type;      // VAR_SYM o FUNC_SYM
    int param_count;      // Para funciones
    struct Symbol *next;
} Symbol;

// Scope (ámbito anidado)
typedef struct Scope {
    Symbol *symbols;      // Lista de símbolos en este scope
    struct Scope *next;   // Scope padre (pila)
} Scope;

## Instrucciones de Compilación y Ejecución

### Prerrequisitos
- WinFlexBison instalado y en el PATH
- Compilador C (MinGW-w64, GCC, o MSVC)

### Compilación
```cmd
win_bison -d -y parser.y
win_flex lexer.l
gcc -o parser.tab.c y.tab.c lex.yy.c

###Ejecución
parser.exe input.c