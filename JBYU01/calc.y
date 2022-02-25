%{
// ref: https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html
#include <stdio.h>
%}

%token NUM
%token ADD SUB MUL
%token EOL
%token OP CP

%%

calclist:
        | calclist exp EOL { printf("%d\n", $2); }
        ;

exp: factor
   | exp ADD factor { $$ = $1 + $3; }
   | exp SUB factor { $$ = $1 - $3; }
   ;

factor: term
      | factor MUL term { $$ = $1 * $3; }
      ;

term: NUM
    | OP exp CP { $$ = $2; }
    ;

%%

main(int argc, char** argv) 
{
  yyparse();
}

yyerror(char *s)
{
  fprintf(stderr, "error: %s\n", s);
}
