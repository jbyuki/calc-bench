all: calc

calc: calc.l calc.y
	bison -d calc.y
	flex calc.l
	gcc -O2 -o $@ calc.tab.c lex.yy.c -lfl

clean:
	rm *.c *.h calc
