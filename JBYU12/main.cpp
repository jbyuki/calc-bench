// Generated using ntangle.nvim
#include <fstream>

#include <string>
#include <iostream>

#include <array>

#include <cassert>


auto exp() -> int;

auto term() -> int;

auto factor() -> int;

auto exp_p(int left) -> int;

auto term_p(int left) -> int;

constexpr int BUFFER_SIZE = 4096;
std::array<char, BUFFER_SIZE> buffer;
int i=0;
bool done = false;

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

 
auto exp() -> int
{
  int result = term();
  result = exp_p(result);
  return result;
}

auto term() -> int
{
  int result = factor();
  result = term_p(result);
  return result;
}

auto factor() -> int
{
  switch(get()) {
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
      result = 10*result + (int)(get()-'0');
      next();
    } while(!eol() && std::isdigit(get()));
    return result;

  }

  case '(':
  {
    next();
    int result = exp();
    next(); // ')'
    return result;
  }
  break;

  }
  return 0;
}

auto exp_p(int left) -> int
{
  // epsilon case
  if(eol()) {
    return left;
  }

  switch(get()) {
    case '+':
      {
        next();
        int right = term();
        int result = left + right;
        return exp_p(result);
      }
      break;

    case '-':
      {
        next();
        int right = term();
        int result = left - right;
        return exp_p(result);
      }
      break;

  }
  return left;
}

auto term_p(int left) -> int
{
  // epsilon case
  if(eol()) {
    return left;
  }

  if(get() == '*') {
    next();
    int right = factor();
    int result = left * right;
    return term_p(result);
  }
  return left;
}


auto main() -> int
{
  // @read_all_at_once
  while(buffer_array()) {
    int result = exp();
    printf("%d\n", result);
  }


  return 0;
}


