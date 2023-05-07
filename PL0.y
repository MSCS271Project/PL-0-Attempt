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
%type <floatValue> term factor
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

decs:	DECLARATION VARIABLE moreDecs ';'
		| DECLARATION VARIABLE ASG FLOAT ';'	{sym[$<stringValue>2] = $4;}
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
		VARIABLE ASG expression				{sym[$<stringValue>1] = $3;}
		| '?' VARIABLE						{$$ = 0;}
		| CALL VARIABLE						{$$ = 0;}
		| '!' expression					{$$ = 0;}
		| '{' statement ';' moreStatement '}'   {$$ = 0;}
		| IF condition THEN statement		{$$ = 0;}
		| WHILE condition DO statement		{$$ = 0;}
		| VARIABLE						{printf("%g\n",sym[$<stringValue>1]);}
        ;
        
moreStatement:
		| statement ';' moreStatement ;
		
condition: ODD VARIABLE
		| expression EQQ expression
		| expression GEQ expression
		| expression LEQ expression
		| expression '#' expression
		| expression '<' expression
		| expression '>' expression
		;

expression: term '+' expression		{$$=$1+$3;}
		| term '-' expression		{$$=$1-$3;}
		| term							{$$=$1;}
		;
		
term:	factor '*' term				{$$=$1*$3;}
		| factor '/' term			{if($3 == 0){
												yyerror("Division by 0");
											}else{
												$$ = $1/$3;
											}
										}	
		| factor;
		
factor: VARIABLE						{$$=sym[$<stringValue>1];}
		| FLOAT							{$$=$1;}
		| '(' expression ')'			{$$=$2;}
		;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    freopen ("PL0.txt", "r", stdin);  //a.txt holds the expression
    yyparse();
}


