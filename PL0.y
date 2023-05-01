%{
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(char*);
    int yylex(void);

    float sym[26];
%}

%token DECLARATION
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
%token FUCKOFF
%token <floatValue> FLOAT 
%token <floatValue> VARIABLE
%type <floatValue> statement expression
%type <floatValue> moreExpression term factor moreTerm
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
        block FUCKOFF
        ;

block:	decs code;

decs:	| DECLARATION VARIABLE ';'
		DECLARATION VARIABLE moreDecs ';'
		;
		
moreDecs:
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

expression: '+' term moreExpression		{$$=$$+$2;}
		| '-' term moreExpression		{$$=$$-$2;}
		;
		
moreExpression: '+' term moreExpression	{$$=$$+$2;}
		| '+' term						{$$=$$+$2;}
		| '-' term moreExpression		{$$=$$-$2;}
		| '-' term						{$$=$$-$2;}
		;
		
term:	factor moreTerm;

moreTerm: '*' factor moreTerm			{$$=$$*$2;}
		| '/' factor moreTerm			{if($2 == 0){
												yyerror("Division by 0");
											}else{
												$$ = $$/$2;
											}
										}
		| '*' factor					{$$=$$*$2;}
		| '/' factor					{if($2 == 0){
												yyerror("Division by 0");
											}else{
												$$ = $$/$2;
											}
										}
		;
		
factor: VARIABLE						{$$=$1;}
		| FLOAT							{$$=$1;}
		| '(' expression ')'			{$$=$2;}
		;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    freopen ("a.txt", "r", stdin);  //a.txt holds the expression
    yyparse();
}


