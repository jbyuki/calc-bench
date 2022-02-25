%{
  // ref: https://www.oreilly.com/library/view/flex-bison/9780596805418/ch01.html
  #include "calc.tab.h"
%}

%%

"+"    { return ADD; }
"-"    { return SUB; }
"*"    { return MUL; }
"("    { return OP; }
")"    { return CP; }
[0-9]+ { yylval = atoi(yytext); return NUM; }
\n     { return EOL; }
.      { }
%%
