@./main.cpp=
@includes

@declare
@global_variables
@functions

auto main() -> int
{
  // @read_all_at_once
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

@includes+=
#include <array>

@global_variables+=
constexpr int BUFFER_SIZE = 4096;
std::array<char, BUFFER_SIZE> buffer;
int i=0;
bool done = false;

@functions+=
auto get() -> char
{
  return buffer[i];
}

auto finish() -> bool
{
  return buffer[i] == '\0';
}

auto eol() -> bool
{
  return finish() || get() == '\n';
}

auto buffer_array() -> bool
{
  i = 0;
  char* ret = fgets(buffer.data(), BUFFER_SIZE, stdin);
  if(ret == NULL) {
    buffer[0] = '\0';
    return false;
  }
  return true;
}

auto next() -> void
{
  if(++i == BUFFER_SIZE) {
    buffer_array();
  }
}

 
@parse_each_line_and_display_result+=
while(buffer_array()) {
  int result = exp();
  printf("%d\n", result);
}

@declare+=
auto exp() -> int;

@functions+=
auto exp() -> int
{
  int result = term();
  result = exp_p(result);
  return result;
}

@declare+=
auto term() -> int;

@functions+=
auto term() -> int
{
  int result = factor();
  result = term_p(result);
  return result;
}

@declare+=
auto factor() -> int;

@functions+=
auto factor() -> int
{
  switch(get()) {
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
  result = 10*result + (int)(get()-'0');
  next();
} while(!eol() && std::isdigit(get()));
return result;

@includes+=
#include <cassert>

@if_first_char_paren_parse+=
case '(':
{
  next();
  int result = exp();
  next(); // ')'
  return result;
}
break;

@declare+=
auto exp_p(int left) -> int;

@functions+=
auto exp_p(int left) -> int
{
  // epsilon case
  if(eol()) {
    return left;
  }

  switch(get()) {
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
  int right = term();
  int result = left + right;
  return exp_p(result);
}
break;

@handle_minus_operation+=
{
  next();
  int right = term();
  int result = left - right;
  return exp_p(result);
}
break;

@declare+=
auto term_p(int left) -> int;

@functions+=
auto term_p(int left) -> int
{
  // epsilon case
  if(eol()) {
    return left;
  }

  if(get() == '*') {
    @handle_mul_operation
  }
  return left;
}

@handle_mul_operation+=
next();
int right = factor();
int result = left * right;
return term_p(result);
