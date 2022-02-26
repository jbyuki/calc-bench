@./main.cpp=
@includes

@declare
@global_variables
@token_struct
@functions

auto main(int argc, char** argv) -> int
{
  @open_file
  @parse_and_evaluate_line_by_line
  return 0;
}

@includes+=
#include <fstream>
#include <iostream>
#include <string>

@open_file+=
std::string filename = "../input.txt";
std::ifstream in(filename);
if(!in.is_open()) {
  std::cerr << "ERROR: Could not open " << filename << std::endl;
  return EXIT_FAILURE;
}

@global_variables+=
std::string buffer;

@parse_and_evaluate_line_by_line+=
while(std::getline(in, buffer)) {
  @initialize_parse_state
  tokenize();
  int result = parse();
  std::cout << result << std::endl;
}

@declare+=
auto tokenize() -> void;

@functions+=
auto tokenize() -> void
{
  for(size_t p = 0; p < buffer.size();) {
    char c = buffer[p];

    switch(c) {
      @if_whitespace_skip
      @if_number_add_token
      @if_operator_add_token
      @if_parenthesis_add_token
      @otherwise_show_error
    }
  }
}

@if_whitespace_skip+=
case ' ':
case '\t':
  ++p;
  break;

@if_number_add_token+=
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
  @lex_number
  @add_number_token
  break;
}

@lex_number+=
int num = 0;
do {
  num = num*10 + (int)(c - '0');
  c = buffer[++p];
} while(p < buffer.size() && std::isdigit(c));

@declare+=
class Token;

@token_struct+=
struct Token
{
  virtual auto prefix() -> int {
    std::cerr << "syntax error" << std::endl;
    return 0;
  }

  virtual auto infix(int left) -> int {
    std::cerr << "syntax error" << std::endl;
    return 0;
  }

  virtual auto priority() -> int = 0;
};

struct NumToken : Token
{
  NumToken(int num) : num(num) {}
  auto prefix() -> int { return num; }
  auto infix(int) -> int { std::cerr << "syntax error" << std::endl; return 0; }
  auto priority() -> int { return 0; } // this is never called, always prefix

  int num;
};

@includes+=
#include <vector>
#include <memory>

@global_variables+=
std::vector<Token*> tokens;
int cur_token = 0;

@initialize_parse_state+=
for(Token* t : tokens) {
  delete t;
}
tokens.clear();
cur_token = 0;

@add_number_token+=
tokens.emplace_back(new NumToken(num));

@if_operator_add_token+=
case '+':
  ++p;
  tokens.emplace_back(new AddToken());
  break;

@token_struct+=
struct AddToken : Token
{
  auto prefix() -> int { return parse(priority()); }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left + right;
  }
  auto priority() -> int { return 50; } 
};

@if_operator_add_token+=
case '-':
  ++p;
  tokens.emplace_back(new SubToken());
  break;

@token_struct+=
struct SubToken : Token
{
  auto prefix() -> int { return -parse(90); }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left - right;
  }
  auto priority() -> int { return 50; } 
};

@if_operator_add_token+=
case '*':
  ++p;
  tokens.emplace_back(new MulToken());
  break;

@token_struct+=
struct MulToken : Token
{
  auto prefix() -> int { std::cerr << "syntax error" << std::endl; return 0; }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left * right;
  }
  auto priority() -> int { return 60; } 
};

@if_operator_add_token+=
case '/':
  ++p;
  tokens.emplace_back(new DivToken());
  break;

@token_struct+=
struct DivToken : Token
{
  auto prefix() -> int { std::cerr << "syntax error" << std::endl; return 0; }
  auto infix(int left) -> int {
    int right = parse(priority());
    if(right == 0) {
      return 0;
    }
    return left / right;
  }
  auto priority() -> int { return 60; } 
};

@if_parenthesis_add_token+=
case '(':
  ++p;
  tokens.emplace_back(new LParToken());
  break;

@token_struct+=
struct RParToken : Token
{
  auto priority() -> int { return 10; } 
};

@token_struct+=
struct LParToken : Token
{
  auto prefix() -> int { 
    int result = parse(20);
    @check_rpar
    return result;
  }
  auto priority() -> int { return 100; } 
};

@if_parenthesis_add_token+=
case ')':
  ++p;
  tokens.emplace_back(new RParToken());
  break;

@check_rpar+=
auto rpar = get();
if(!rpar || !dynamic_cast<RParToken*>(rpar)) {
  std::cerr << "syntax error" << std::endl;
  return result;
}
next();

@declare+=
auto get() -> Token*;

@functions+=
auto get() -> Token* 
{
  if(cur_token < tokens.size()) {
    return tokens[cur_token];  
  }
  return nullptr;
}

@declare+=
auto next() -> Token*;

@functions+=
auto next() -> Token*
{
  auto t = get();
  ++cur_token;
  return t;
}

@declare+=
auto finish() -> bool;

@functions+=
auto finish() -> bool
{
  return cur_token >= tokens.size();
}

@otherwise_show_error+=
default:
  std::cout << "Unknown character " << c << " at " << p << std::endl;
  ++p;
  break;

@declare+=
auto parse(int p = 0) -> int;

@functions+=
auto parse(int p) -> int
{
  auto t = next();
  if(!t) {
    std::cerr << "syntax error" << std::endl;
    return 0;
  }

  int result = t->prefix();

  while(!finish() && p < get()->priority()) {
    t = next();
    result = t->infix(result);
  }
  return result;
}
