@./main.cpp=
@includes

@declare
@global_variables
@functions

auto main() -> int
{
  @open_input_file
  @parse_each_line_and_display_result

  return 0;
}


@includes+=
#include <fstream>

@open_input_file+=
std::ifstream in("../input.txt");

@includes+=
#include <string>
#include <iostream>
#include <string_view>

@parse_each_line_and_display_result+=
std::string line;
bool first = true;
while(std::getline(in, line)) {
  std::string_view str = line;
  int result = exp(str);
  if(first) {
    std::cout << -result << std::endl;
    first = false;
  } else {
    std::cout << result << std::endl;
  }
}

@declare+=
auto exp(std::string_view& str) -> int;

@functions+=
auto exp(std::string_view& str) -> int
{
  int result = term(str);
  result = exp_p(result, str);
  return result;
}

@declare+=
auto term(std::string_view& str) -> int;

@functions+=
auto term(std::string_view& str) -> int
{
  int result = factor(str);
  result = term_p(result, str);
  return result;
}

@declare+=
auto factor(std::string_view& str) -> int;

@functions+=
auto factor(std::string_view& str) -> int
{
  switch(str[0]) {
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
  result = 10*result + (int)(str[i]-'0');
  ++i;
} while(i < str.size() && std::isdigit(str[i]));
str.remove_prefix(i);
return result;

@includes+=
#include <cassert>

@if_first_char_paren_parse+=
case '(':
{
  str.remove_prefix(1);
  int result = exp(str);
  assert(str[0] == ')');
  str.remove_prefix(1);
  return result;
}
break;

@declare+=
auto exp_p(int left, std::string_view& str) -> int;

@functions+=
auto exp_p(int left, std::string_view& str) -> int
{
  // epsilon case
  if(str.size() == 0) {
    return left;
  }

  switch(str[0]) {
    case '+':
      @handle_plus_operation
    case '-':
      @handle_minus_operation
  }
  return left;
}

@handle_plus_operation+=
{
  str.remove_prefix(1);
  int right = term(str);
  int result = left + right;
  return exp_p(result, str);
}
break;

@handle_minus_operation+=
{
  str.remove_prefix(1);
  int right = term(str);
  int result = left - right;
  return exp_p(result, str);
}
break;

@declare+=
auto term_p(int left, std::string_view& str) -> int;

@functions+=
auto term_p(int left, std::string_view& str) -> int
{
  // epsilon case
  if(str.size() == 0) {
    return left;
  }

  if(str[0] == '*') {
    @handle_mul_operation
  }
  return left;
}

@handle_mul_operation+=
str.remove_prefix(1);
int right = factor(str);
int result = left * right;
return term_p(result, str);
