// Generated using ntangle.nvim
#include <fstream>
#include <iostream>

#include <string>
#include <cstdio>

#include <vector>

#include <stdio.h>


struct Token
{
  enum {
    NUM_TOKEN = 1,

    CLOSE_PAR_TOKEN = 2,
    OPEN_PAR_TOKEN = 5,

    ADD_TOKEN = 3,
    SUB_TOKEN = 4,
    MUL_TOKEN = 0,

    END_TOKEN = 6,

  } type;
  int num;

};

std::vector<Token> tokens;

// 0 means ending
// positive means shift
// negative means reduce
const int8_t action_table[]  = {
  // (   +   *    (    -   id   $
     0,  2,  0,   0,   0,  6,   0,
    -7,  0, -7,  -7,  -7,  0,  -7,
     7,  0, -3,  -3, -3,   0,  -3,
    -5,  0, -5,  -5, -5,   0,  -5,
     0,  0,  0,   8,  9,   0,   0,
     0,  2,  0,   0,  0,   6,   0,
     0,  2,  0,   0,  0,   6,   0,
     0,  2,  0,   0,  0,   6,   0,
     0,  2,  0,   0,  0,   6,   0,
     0,  0, 14,   8,  9,   0,   0,
    -4,  0, -4,  -4, -4,   0,  -4,
     7,  0, -1,  -1, -1,   0,  -1,
     7,  0, -2,  -2, -2,   0,  -2,
    -6,  0, -6,  -6, -6,   0,  -6
};

// Length to reduce for each rule
const int8_t rhs_len[] = {
  3, // 1) E -> E + T
  3, // 2) E -> E - T
  1, // 3) E -> T
  3, // 4) T -> T * F
  1, // 5) T -> F
  3, // 6) F -> ( E )
  1, // 7) F -> id
  1 // 8) E' -> E
};

// Goto table
const int8_t goto_table[] = {
  // T   F   E
     3,  4, 5,
     0,  0, 0,
     0,  0, 0,
     0,  0, 0,
     0,  0, 0,
     3,  4,10,
     0, 11, 0,
    12,  4, 0,
    13,  4, 0,
     0,  0, 0,
     0,  0, 0,
     0,  0, 0,
     0,  0, 0,
     0,  0, 0
};

std::vector<int8_t> stack;

const int8_t lhs[] = {
  2, // 1) E -> E + T
  2, // 2) E -> E - T
  2, // 3) E -> T
  0, // 4) T -> T * F
  0, // 5) T -> F
  1, // 6) F -> ( E )
  1 // 7) F -> id
};

std::vector<int> nums;

int left, right;


auto main() -> int
{
  // @open_input_file
  std::istreambuf_iterator<char> begin(std::cin), end;
  std::string buffer(begin, end);

  int m=0;
  while(m<buffer.size()) {
    tokens.clear();

    bool eol = false;
    for(;m<buffer.size()&&!eol;) {
      switch(buffer[m]) {
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
        int res = 0;
        do
        {
          res = 10*res + (int)(buffer[m]-'0');
          ++m;
        } while(m < buffer.size() && std::isdigit(buffer[m]));

        Token token;
        token.type = Token::NUM_TOKEN;
        token.num = res;
        tokens.push_back(token);

      }
      break;

      case '(':
      {
        Token token;
        token.type = Token::OPEN_PAR_TOKEN;
        tokens.push_back(token);
        ++m;

      }
      break;

      case ')':
      {
        Token token;
        token.type = Token::CLOSE_PAR_TOKEN;
        tokens.push_back(token);
        ++m;

      }
      break;

      case '+':
      {
        Token token;
        token.type = Token::ADD_TOKEN;
        tokens.push_back(token);
        ++m;
      }
      break;

      case '-':
      {
        Token token;
        token.type = Token::SUB_TOKEN;
        tokens.push_back(token);
        ++m;
      }
      break;

      case '*':
      {
        Token token;
        token.type = Token::MUL_TOKEN;
        tokens.push_back(token);
        ++m;
      }
      break;

      default:
        eol = true;
        ++m;
        break;
      }
    }

    Token token;
    token.type = Token::END_TOKEN;
    tokens.push_back(token);


    printf("0\n");

    // @init_states
    // int i=0;
    // while(true) {
      // Token& s = tokens[i];

      // @if_action_is_shift
      // @if_action_is_reduce
      // @if_action_is_accept
    // }
  }



  return 0;
}

