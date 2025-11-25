%option noyywrap

%{
#include "parser.tab.h"
#include "symbol_table.h"

int line_num = 1;
%}

%%

"int"        return INT;
"float"      return FLOAT;
"char"       return CHAR;
"void"       return VOID;

"if"         return IF;
"else"       return ELSE;
"while"      return WHILE;
"for"        return FOR;
"return"     return RETURN;

"=="         return EQ;
"!="         return NE;
"<="         return LE;
">="         return GE;
"||"         return OR;
"&&"         return AND;

[0-9]+"."[0-9]+  { yylval.real = atof(yytext); return REAL; }
[0-9]+           { yylval.num = atoi(yytext); return INTEGER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.str = strdup(yytext); return IDENTIFIER; }

[ \t]+       ;
\n           { line_num++; }

.            return yytext[0];

%%

