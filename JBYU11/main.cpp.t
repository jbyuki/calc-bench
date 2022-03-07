@./main.cpp=
@includes

@declare
@global_variables
@functions

auto main() -> int
{
  @read_all_at_once
  @parse_each_line_and_display_result

  return 0;
}


@includes+=
#include <fstream>

@includes+=
#include <string>
#include <iostream>

@read_all_at_once+=
std::istreambuf_iterator<char> begin(std::cin), end;
std::string buffer(begin, end);

@global_variables+=
int i=0;

@functions+=
auto get(std::string& buffer) -> char
{
  return buffer[i];
}

auto finish(std::string& buffer) -> bool
{
  return i >= buffer.size();
}

auto eol(std::string& buffer) -> bool
{
  return finish(buffer) || get(buffer) == '\n';
}

auto next() -> void
{
  ++i;
}
 
@parse_each_line_and_display_result+=
while(!finish(buffer)) {
  int result = exp(buffer);
  printf("%d\n", result);
  next();
}

@declare+=
auto exp(std::string& str) -> int;

@functions+=
auto exp(std::string& str) -> int
{
  int result = term(str);
  result = exp_p(result, str);
  return result;
}

@declare+=
auto term(std::string& str) -> int;

@functions+=
auto term(std::string& str) -> int
{
  int result = factor(str);
  result = term_p(result, str);
  return result;
}

@declare+=
auto factor(std::string& str) -> int;

@functions+=
auto factor(std::string& str) -> int
{
  switch(get(str)) {
  @if_first_char_number_parse
  @if_first_char_paren_parse
  }
  return 0;
}

@if_first_char_number_parse+=
case '0':
case '1':
case '2':
case '3':
case '4':
case '5':
case '6':
case '7':
case '8':
case '9':
{
  @parse_number
}

@parse_number+=
int result = 0;
int i=0;
do
{
  result = 10*result + (int)(get(str)-'0');
  next();
} while(!eol(str) && std::isdigit(get(str)));
return result;

@includes+=
#include <cassert>

@if_first_char_paren_parse+=
case '(':
{
  next();
  int result = exp(str);
  next(); // ')'
  return result;
}
break;

@declare+=
auto exp_p(int left, std::string& str) -> int;

@functions+=
auto exp_p(int left, std::string& str) -> int
{
  // epsilon case
  if(eol(str)) {
    return left;
  }

  switch(get(str)) {
    case '+':
      @handle_plus_operation
    case '-':
      @handle_minus_operation
  }
  return left;
}

@handle_plus_operation+=
{
  next();
  int right = term(str);
  int result = left + right;
  return exp_p(result, str);
}
break;

@handle_minus_operation+=
{
  next();
  int right = term(str);
  int result = left - right;
  return exp_p(result, str);
}
break;

@declare+=
auto term_p(int left, std::string& str) -> int;

@functions+=
auto term_p(int left, std::string& str) -> int
{
  // epsilon case
  if(eol(str)) {
    return left;
  }

  if(get(str) == '*') {
    @handle_mul_operation
  }
  return left;
}

@handle_mul_operation+=
next();
int right = factor(str);
int result = left * right;
return term_p(result, str);
