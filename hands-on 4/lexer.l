%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Prototipos de funciones
void print_token(const char* token_type, const char* lexeme);
%}

/* Definiciones de patrones */
DIGIT       [0-9]
LETTER      [a-zA-Z_]
IDENTIFIER  {LETTER}({LETTER}|{DIGIT})*
INT_LITERAL {DIGIT}+
FLOAT_LITERAL {DIGIT}+\.{DIGIT}*
WHITESPACE  [ \t\n]
COMMENT     "//".*|"/*"([^*]|"*"[^/])*"*/"

/* Estados para manejar comentarios multilínea */
%x COMMENT_STATE

%%

"#include"          { print_token("DIRECTIVA_INCLUDE", yytext); }
"#define"           { print_token("DIRECTIVA_DEFINE", yytext); }

"int"               { print_token("PALABRA_RESERVADA", "int"); }
"float"             { print_token("PALABRA_RESERVADA", "float"); }
"double"            { print_token("PALABRA_RESERVADA", "double"); }
"char"              { print_token("PALABRA_RESERVADA", "char"); }
"void"              { print_token("PALABRA_RESERVADA", "void"); }
"short"             { print_token("PALABRA_RESERVADA", "short"); }
"return"            { print_token("PALABRA_RESERVADA", "return"); }
"main"              { print_token("PALABRA_RESERVADA", "main"); }

"+"                 { print_token("OPERADOR", "+"); }
"-"                 { print_token("OPERADOR", "-"); }
"*"                 { print_token("OPERADOR", "*"); }
"/"                 { print_token("OPERADOR", "/"); }
"++"                { print_token("OPERADOR", "++"); }
"="                 { print_token("OPERADOR_ASIGNACION", "="); }

"("                 { print_token("DELIMITADOR", "("); }
")"                 { print_token("DELIMITADOR", ")"); }
"{"                 { print_token("DELIMITADOR", "{"); }
"}"                 { print_token("DELIMITADOR", "}"); }
";"                 { print_token("DELIMITADOR", ";"); }
","                 { print_token("DELIMITADOR", ","); }
"<"                 { print_token("DELIMITADOR", "<"); }
">"                 { print_token("DELIMITADOR", ">"); }

{INT_LITERAL}       { print_token("LITERAL_ENTERO", yytext); }
{FLOAT_LITERAL}     { print_token("LITERAL_FLOTANTE", yytext); }
{IDENTIFIER}        { print_token("IDENTIFICADOR", yytext); }

"/*"                { BEGIN(COMMENT_STATE); }
<COMMENT_STATE>"*/" { BEGIN(INITIAL); print_token("COMENTARIO", "/* ... */"); }
<COMMENT_STATE>.    { /* Ignorar contenido del comentario */ }
<COMMENT_STATE>\n   { /* Ignorar saltos de línea en comentarios */ }

"//".*              { print_token("COMENTARIO_LINEA", yytext); }

{WHITESPACE}+       { /* Ignorar espacios en blanco */ }

.                   { printf("Error léxico: Carácter no reconocido '%s'\n", yytext); }

%%

void print_token(const char* token_type, const char* lexeme) {
    printf("<%s, %s>\n", token_type, lexeme);
}

int main(int argc, char *argv[]) {
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Error: No se pudo abrir el archivo %s\n", argv[1]);
            return 1;
        }
    } else {
        printf("Usando entrada estándar. Para usar archivo: %s archivo.c\n", argv[0]);
    }
    
    printf("=== INICIO DEL ANÁLISIS LÉXICO ===\n");
    yylex();
    printf("=== FIN DEL ANÁLISIS LÉXICO ===\n");
    
    if (yyin != stdin) {
        fclose(yyin);
    }
    
    return 0;
}

int yywrap() {
    return 1;
}
