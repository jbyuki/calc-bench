// Generated using ntangle.nvim
#include <fstream>

#include <string>
#include <iostream>

#include <cassert>


auto exp(std::string& str) -> int;

auto term(std::string& str) -> int;

auto factor(std::string& str) -> int;

auto exp_p(int left, std::string& str) -> int;

auto term_p(int left, std::string& str) -> int;

int i=0;

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
 
auto exp(std::string& str) -> int
{
  int result = term(str);
  result = exp_p(result, str);
  return result;
}

auto term(std::string& str) -> int
{
  int result = factor(str);
  result = term_p(result, str);
  return result;
}

auto factor(std::string& str) -> int
{
  switch(get(str)) {
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
      result = 10*result + (int)(get(str)-'0');
      next();
    } while(!eol(str) && std::isdigit(get(str)));
    return result;

  }

  case '(':
  {
    next();
    int result = exp(str);
    next(); // ')'
    return result;
  }
  break;

  }
  return 0;
}

auto exp_p(int left, std::string& str) -> int
{
  // epsilon case
  if(eol(str)) {
    return left;
  }

  switch(get(str)) {
    case '+':
      {
        next();
        int right = term(str);
        int result = left + right;
        return exp_p(result, str);
      }
      break;

    case '-':
      {
        next();
        int right = term(str);
        int result = left - right;
        return exp_p(result, str);
      }
      break;

  }
  return left;
}

auto term_p(int left, std::string& str) -> int
{
  // epsilon case
  if(eol(str)) {
    return left;
  }

  if(get(str) == '*') {
    next();
    int right = factor(str);
    int result = left * right;
    return term_p(result, str);
  }
  return left;
}


auto main() -> int
{
  std::istreambuf_iterator<char> begin(std::cin), end;
  std::string buffer(begin, end);

  while(!finish(buffer)) {
    int result = exp(buffer);
    printf("%d\n", result);
    next();
  }


  return 0;
}


