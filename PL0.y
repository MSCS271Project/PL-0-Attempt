%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(char *);
    int yylex(void);

    float sym[26];
%}

%token DECLARATION 
%token EOF 
%token IF
%token ELSE
%token WHILE
%token PROCEDURE 
%token CALL
%token THEN
%token DO
%token GEQ 
%token LEQ 
%token EQQ 
%token ASG 
%token ODD
%token <floatValue> FLOAT 
%token <floatValue> VARIABLE
%type <floatValue> statement expression
%left '+' '-'
%left '*' '/'
%nonassoc UMINUS
%union 
{
	float floatValue;
	int stringValue;
}

%%

program:
        block EOF'\n'
        ;

block:	decs code;

decs:	| DECLARATION VARIABLE ';'
		DECLARATION VARIABLE moreDecs ';'
		;
		
moreDecs: ',' VARIABLE
		| ',' VARIABLE moreDecs
		;
		
code:	statement
		| procedures statement
		;
		
procedures:
		PROCEDURE VARIABLE ':' block ';' procedures
		| PROCEDURE VARIABLE ':' block ';'
		;

statement:
		VARIABLE ASG expression
		| '?' VARIABLE						{$$ = 0;}
		| CALL VARIABLE						{$$ = 0;}
		| '!' expression					{$$ = 0;}
		| '{' statement moreStatement '}'   {$$ = 0;}
		| IF condition THEN statement		{$$ = 0;}
		| WHILE condition DO statement		{$$ = 0;}
        ;
        
moreStatement:
		';' statement moreStatement | ;
		
condition: ODD VARIABLE
		| expression EQQ expression
		| expression GEQ expression
		| expression LEQ expression
		| expression '#' expression
		| expression '<' expression
		| expression '>' expression
		;

expression: '+' term moreExpression		{$<int>$=0;}
		| '-' term moreExpression		{$<int>$=0;}
		;
		
moreExpression: '+' term moreExpression	{$<int>$=0;}
		| '+' term
		| '-' term moreExpression		{$<int>$=0;}
		| '-' term
		;
		
term:	factor moreTerm;

moreTerm: '*' factor moreTerm
		| '/' factor moreTerm
		| '*' factor
		| '/' factor
		;
		
factor: VARIABLE
		| FLOAT
		| '(' expression ')';

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    freopen ("a.txt", "r", stdin);  //a.txt holds the expression
    yyparse();
}


