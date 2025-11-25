%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "symbol_table.h"

void yyerror(const char *s);
int yylex(void);

extern int line_num;
extern FILE *yyin;

%}

/* ------------------ TIPOS DEL YACC ------------------ */

%union {
    int num;
    double real;
    char *str;
    int param_count;
}

/* ------------------ TOKENS ------------------ */

%token <str> IDENTIFIER
%token <num> INTEGER
%token <real> REAL

%token INT FLOAT CHAR VOID
%token IF ELSE WHILE FOR RETURN
%token EQ NE LE GE AND OR

%type <str> type
%type <param_count> parameter_list argument_list

%start program

%%

/* ====================== PROGRAMA ======================= */

program
    : global_declarations
    {
        printf("? Análisis sintáctico completado exitosamente.\n");
    }
    ;

global_declarations
    : global_declarations global_declaration
    | /* vacío */
    ;

global_declaration
    : function_definition
    | variable_declaration ';'
    ;

/* ====================== FUNCIONES ======================= */

function_definition
    : type IDENTIFIER '(' parameter_list ')' compound_statement
    {
        insert_symbol($2, FUNC_SYM, $4);
    }
    | type IDENTIFIER '(' ')' compound_statement
    {
        insert_symbol($2, FUNC_SYM, 0);
    }
    ;

parameter_list
    : parameter                 { $$ = 1; }
    | parameter_list ',' parameter { $$ = $1 + 1; }
    ;

parameter
    : type IDENTIFIER
    {
        insert_symbol($2, VAR_SYM, 0);
    }
    ;

/* ====================== VARIABLES ======================= */

variable_declaration
    : type IDENTIFIER
    {
        insert_symbol($2, VAR_SYM, 0);
    }
    | type IDENTIFIER '=' expression
    {
        insert_symbol($2, VAR_SYM, 0);
    }
    ;

type
    : INT     { $$ = "int"; }
    | FLOAT   { $$ = "float"; }
    | CHAR    { $$ = "char"; }
    | VOID    { $$ = "void"; }
    ;

/* ====================== BLOQUES / SCOPES ======================= */

compound_statement
    : '{' 
        { enter_scope(); }
      local_declarations statement_list 
      '}'
        { exit_scope(); }
    ;

/* ====================== DECLARACIONES LOCALES ======================= */

local_declarations
    : local_declarations variable_declaration ';'
    | /* vacío */
    ;

statement_list
    : statement_list statement
    | /* vacío */
    ;

/* ====================== SENTENCIAS ======================= */

statement
    : expression_statement
    | compound_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

/* ------- Sentencias ---------------- */

expression_statement
    : expression ';'
    | ';'
    ;

selection_statement
    : IF '(' expression ')' statement
    | IF '(' expression ')' statement ELSE statement
    ;

iteration_statement
    : WHILE '(' expression ')' statement
    | FOR '(' expression_statement expression_statement expression ')' statement
    ;

jump_statement
    : RETURN ';'
    | RETURN expression ';'
    ;

/* ====================== EXPRESIONES ======================= */

expression
    : assignment_expression
    | simple_expression
    ;

assignment_expression
    : IDENTIFIER '=' expression
    {
        if (!lookup($1))
            printf("? Error: variable '%s' no declarada (línea %d)\n", $1, line_num);
    }
    ;

simple_expression
    : additive_expression relop additive_expression
    | additive_expression
    ;

relop
    : '<'
    | '>'
    | EQ
    | NE
    | LE
    | GE
    ;

/* ------ Expresiones aritméticas ------ */

additive_expression
    : additive_expression addop term
    | term
    ;

addop
    : '+'
    | '-'
    | OR
    ;

term
    : term mulop factor
    | factor
    ;

mulop
    : '*'
    | '/'
    | AND
    ;

/* ====================== FACTORES ======================= */

factor
    : '(' expression ')'
    | IDENTIFIER
    {
        Symbol *s = lookup($1);
        if (!s)
            printf("? Error: variable '%s' no declarada (línea %d)\n", $1, line_num);
    }
    | IDENTIFIER '(' argument_list ')'
    {
        Symbol *f = lookup($1);
        if (!f || f->type != FUNC_SYM)
            printf("? Error: '%s' no es función (línea %d)\n", $1, line_num);
        else if (f->param_count != $3)
            printf("? Error: '%s' espera %d parámetros, recibió %d (línea %d)\n",
                $1, f->param_count, $3, line_num);
    }
    | IDENTIFIER '(' ')'
    {
        Symbol *f = lookup($1);
        if (!f || f->type != FUNC_SYM)
            printf("? Error: '%s' no es función (línea %d)\n", $1, line_num);
        else if (f->param_count != 0)
            printf("? Error: '%s' espera %d parámetros, recibió 0 (línea %d)\n",
                $1, f->param_count, line_num);
    }
    | INTEGER
    | REAL
    ;

argument_list
    : expression                 { $$ = 1; }
    | argument_list ',' expression  { $$ = $1 + 1; }
    ;

%%

/* ====================== ERRORES ======================= */

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", line_num, s);
}

/* ====================== MAIN ======================= */

int main(int argc, char *argv[]) {

    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("No se pudo abrir %s\n", argv[1]);
            return 1;
        }
    } else {
        printf("Ingresa código (Ctrl+Z para terminar):\n");
    }

    init_global_table();
    enter_scope();   // scope global

    yyparse();

    exit_scope();
    return 0;
}

