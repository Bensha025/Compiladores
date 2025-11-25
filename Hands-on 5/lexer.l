%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();

int line_num = 1;
%}

DIGIT    [0-9]
LETTER   [a-zA-Z]
ID       {LETTER}({LETTER}|{DIGIT}|_)*
NUM      {DIGIT}+
REAL     {DIGIT}+\.{DIGIT}*

%%

"int"       { return INT; }
"float"     { return FLOAT; }
"char"      { return CHAR; }
"void"      { return VOID; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"for"       { return FOR; }
"return"    { return RETURN; }

{ID}        { yylval.str = strdup(yytext); return IDENTIFIER; }
{NUM}       { yylval.num = atoi(yytext); return INTEGER; }
{REAL}      { yylval.real = atof(yytext); return REAL; }

"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"&&"        { return AND; }
"||"        { return OR; }

"="         { return '='; }
"+"         { return '+'; }
"-"         { return '-'; }
"*"         { return '*'; }
"/"         { return '/'; }
"<"         { return '<'; }
">"         { return '>'; }
"!"         { return '!'; }

"("         { return '('; }
")"         { return ')'; }
"{"         { return '{'; }
"}"         { return '}'; }
"["         { return '['; }
"]"         { return ']'; }
";"         { return ';'; }
","         { return ','; }

[ \t]       { /* Ignorar espacios y tabs */ }
\n          { line_num++; }
"//".*      { /* Ignorar comentarios de una línea */ }

.           { printf("Error léxico: carácter inválido '%c' en línea %d\n", yytext[0], line_num); }

%%

int yywrap() {
    return 1;
}
