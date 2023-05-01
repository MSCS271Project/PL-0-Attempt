calc: calc.l calc.y
	bison -dv calc.y
	flex calc.l
	gcc -o $@ calc.tab.c lex.yy.c -lfl

PL0: PL0.l PL0.y
	bison -dv PL0.y
	flex PL0.l
	gcc -o $@ PL0.tab.c lex.yy.c -lfl
