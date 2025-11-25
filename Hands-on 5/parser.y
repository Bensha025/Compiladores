%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex();

extern int line_num;
extern FILE *yyin;

int yyparse();

%}

%union {
    int num;
    double real;
    char *str;
}

%token <str> IDENTIFIER
%token <num> INTEGER
%token <real> REAL
%token INT FLOAT CHAR VOID
%token IF ELSE WHILE FOR RETURN
%token EQ NE LE GE AND OR

%type <str> type

%start program

%%

program
    : global_declarations
    {
        printf("Análisis sintáctico completado exitosamente.\n");
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

function_definition
    : type IDENTIFIER '(' parameter_list ')' compound_statement
    | type IDENTIFIER '(' ')' compound_statement
    ;

parameter_list
    : parameter
    | parameter_list ',' parameter
    ;

parameter
    : type IDENTIFIER
    ;

variable_declaration
    : type IDENTIFIER
    | type IDENTIFIER '=' expression
    ;

type
    : INT     { $$ = "int"; }
    | FLOAT   { $$ = "float"; }
    | CHAR    { $$ = "char"; }
    | VOID    { $$ = "void"; }
    ;

compound_statement
    : '{' local_declarations statement_list '}'
    | '{' statement_list '}'
    | '{' local_declarations '}'
    | '{' '}'
    ;

local_declarations
    : local_declarations variable_declaration ';'
    | /* vacío */
    ;

statement_list
    : statement_list statement
    | /* vacío */
    ;

statement
    : expression_statement
    | compound_statement
    | selection_statement
    | iteration_statement
    | jump_statement
    ;

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

expression
    : assignment_expression
    | simple_expression
    ;

assignment_expression
    : IDENTIFIER '=' expression
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

factor
    : '(' expression ')'
    | IDENTIFIER
    | IDENTIFIER '(' argument_list ')'
    | IDENTIFIER '(' ')'
    | INTEGER
    | REAL
    ;

argument_list
    : expression
    | argument_list ',' expression
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error sintáctico en línea %d: %s\n", line_num, s);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "No se puede abrir el archivo: %s\n", argv[1]);
            return 1;
        }
    } else {
        printf("Usando entrada estándar. Escribe el código (Ctrl+Z para terminar):\n");
    }
    
    if (yyparse() == 0) {
        printf("Análisis completado sin errores sintácticos.\n");
    } else {
        printf("Se encontraron errores sintácticos.\n");
    }
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return 0;
}
