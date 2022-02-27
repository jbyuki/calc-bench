// Generated using ntangle.nvim
#include <fstream>

#include <string>
#include <iostream>
#include <string_view>

#include <cassert>


auto exp(std::string_view& str) -> int;

auto term(std::string_view& str) -> int;

auto factor(std::string_view& str) -> int;

auto exp_p(int left, std::string_view& str) -> int;

auto term_p(int left, std::string_view& str) -> int;

auto exp(std::string_view& str) -> int
{
  int result = term(str);
  result = exp_p(result, str);
  return result;
}

auto term(std::string_view& str) -> int
{
  int result = factor(str);
  result = term_p(result, str);
  return result;
}

auto factor(std::string_view& str) -> int
{
  switch(str[0]) {
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
    int result = 0;
    int i=0;
    do
    {
      result = 10*result + (int)(str[i]-'0');
      ++i;
    } while(i < str.size() && std::isdigit(str[i]));
    str.remove_prefix(i);
    return result;

  }

  case '(':
  {
    str.remove_prefix(1);
    int result = exp(str);
    assert(str[0] == ')');
    str.remove_prefix(1);
    return result;
  }
  break;

  }
  return 0;
}

auto exp_p(int left, std::string_view& str) -> int
{
  // epsilon case
  if(str.size() == 0) {
    return left;
  }

  switch(str[0]) {
    case '+':
      {
        str.remove_prefix(1);
        int right = term(str);
        int result = left + right;
        return exp_p(result, str);
      }
      break;

    case '-':
      {
        str.remove_prefix(1);
        int right = term(str);
        int result = left - right;
        return exp_p(result, str);
      }
      break;

  }
  return left;
}

auto term_p(int left, std::string_view& str) -> int
{
  // epsilon case
  if(str.size() == 0) {
    return left;
  }

  if(str[0] == '*') {
    str.remove_prefix(1);
    int right = factor(str);
    int result = left * right;
    return term_p(result, str);
  }
  return left;
}


auto main() -> int
{
  std::ifstream in("../input.txt");

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


  return 0;
}


