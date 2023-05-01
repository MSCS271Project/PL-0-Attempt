%{
	#include "PL0.tab.h"
	#include <stdlib.h>
	void yyerror(*char);
%}

ident ([a-zA-Z][a-zA-Z0-9]*)
float ([0-9]+("."[0-9]+)?)

%%
"if"		{return IF;}
"then"		{return THEN;}
"else"		{return ELSE;}
"while"		{return WHILE;}
"do"		{return DO;}
"procedure"	{return PROCEDURE;}
"call"		{return CALL;}
"odd"		{return ODD;}

"Goodbye"		{return EOF;}

[ \t]   ;       /* skip whitespace */

"var"		{return DECLARATION;}

">="		{return GEQ;}
"<="		{return LEQ;}
":="		{return ASG;} /*Assignment Operator*/
"=="		{return EQQ;} /*Conditional Equals Operator*/
[<>#?!:;{}]		{return *yytext;}
[-+()/*\n]     {return *yytext;}

{float}		 { yylval.floatValue = atof(yytext);
                   return FLOAT;
			}

{ident}       {
                yylval.stringValue = *yytext - 'a';
                return VARIABLE;
                }

.         yyerror("Unknown Character.\n");

%%

int yywrap(void) {
    return 1;
}
