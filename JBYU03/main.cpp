// Generated using ntangle.nvim
#include <fstream>
#include <iostream>
#include <string>

#include <vector>
#include <memory>


auto tokenize() -> void;

class Token;

auto get() -> Token*;

auto next() -> Token*;

auto finish() -> bool;

auto parse(int p = 0) -> int;

std::string buffer;

std::vector<Token*> tokens;
int cur_token = 0;

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

struct AddToken : Token
{
  auto prefix() -> int { return parse(priority()); }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left + right;
  }
  auto priority() -> int { return 50; } 
};

struct SubToken : Token
{
  auto prefix() -> int { return -parse(90); }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left - right;
  }
  auto priority() -> int { return 50; } 
};

struct MulToken : Token
{
  auto prefix() -> int { std::cerr << "syntax error" << std::endl; return 0; }
  auto infix(int left) -> int {
    int right = parse(priority());
    return left * right;
  }
  auto priority() -> int { return 60; } 
};

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

struct RParToken : Token
{
  auto priority() -> int { return 10; } 
};

struct LParToken : Token
{
  auto prefix() -> int { 
    int result = parse(20);
    auto rpar = get();
    if(!rpar || !dynamic_cast<RParToken*>(rpar)) {
      std::cerr << "syntax error" << std::endl;
      return result;
    }
    next();

    return result;
  }
  auto priority() -> int { return 100; } 
};

auto tokenize() -> void
{
  for(size_t p = 0; p < buffer.size();) {
    char c = buffer[p];

    switch(c) {
      case ' ':
      case '\t':
        ++p;
        break;

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
        int num = 0;
        do {
          num = num*10 + (int)(c - '0');
          c = buffer[++p];
        } while(p < buffer.size() && std::isdigit(c));

        tokens.emplace_back(new NumToken(num));

        break;
      }

      case '+':
        ++p;
        tokens.emplace_back(new AddToken());
        break;

      case '-':
        ++p;
        tokens.emplace_back(new SubToken());
        break;

      case '*':
        ++p;
        tokens.emplace_back(new MulToken());
        break;

      case '/':
        ++p;
        tokens.emplace_back(new DivToken());
        break;

      case '(':
        ++p;
        tokens.emplace_back(new LParToken());
        break;

      case ')':
        ++p;
        tokens.emplace_back(new RParToken());
        break;

      default:
        std::cout << "Unknown character " << c << " at " << p << std::endl;
        ++p;
        break;

    }
  }
}

auto get() -> Token* 
{
  if(cur_token < tokens.size()) {
    return tokens[cur_token];  
  }
  return nullptr;
}

auto next() -> Token*
{
  auto t = get();
  ++cur_token;
  return t;
}

auto finish() -> bool
{
  return cur_token >= tokens.size();
}

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

auto main(int argc, char** argv) -> int
{
  std::string filename = "../input.txt";
  std::ifstream in(filename);
  if(!in.is_open()) {
    std::cerr << "ERROR: Could not open " << filename << std::endl;
    return EXIT_FAILURE;
  }

  while(std::getline(in, buffer)) {
    for(Token* t : tokens) {
      delete t;
    }
    tokens.clear();
    cur_token = 0;

    tokenize();
    int result = parse();
    std::cout << result << std::endl;
  }

  return 0;
}

