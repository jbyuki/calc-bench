// Generated using ntangle.nvim
#include <fstream>
#include <iostream>

#include <string>
#include <iostream>

#include <vector>


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
  std::string line;
  while(std::getline(std::cin, line)) {
    tokens.clear();

    for(int i=0; i<line.size();) {
      switch(line[i]) {
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
          res = 10*res + (int)(line[i]-'0');
          ++i;
        } while(i < line.size() && std::isdigit(line[i]));

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
        ++i;

      }
      break;

      case ')':
      {
        Token token;
        token.type = Token::CLOSE_PAR_TOKEN;
        tokens.push_back(token);
        ++i;

      }
      break;

      case '+':
      {
        Token token;
        token.type = Token::ADD_TOKEN;
        tokens.push_back(token);
        ++i;
      }
      break;

      case '-':
      {
        Token token;
        token.type = Token::SUB_TOKEN;
        tokens.push_back(token);
        ++i;
      }
      break;

      case '*':
      {
        Token token;
        token.type = Token::MUL_TOKEN;
        tokens.push_back(token);
        ++i;
      }
      break;

      }
    }

    Token token;
    token.type = Token::END_TOKEN;
    tokens.push_back(token);


    stack.clear();
    stack.push_back(0);

    nums.clear();

    int i=0;
    while(true) {
      Token& s = tokens[i];

      int8_t t = stack.back();
      int8_t action = action_table[t*7+s.type];

      if(action>0) {
        stack.push_back(action-1);
        if(s.type == Token::NUM_TOKEN) {
          nums.push_back(s.num);
        }

        ++i;
      }

      else if(action<0) {
        int r = rhs_len[-(action+1)];

        for(int8_t j=0; j<r; ++j) {
          stack.pop_back();
        }

        t = stack.back();
        stack.push_back(goto_table[t*3+lhs[-(action+1)]]-1);


        switch(-(action+1)) {
        // 0 E -> E + T
        case 0:
          right = nums.back();
          nums.pop_back();
          left = nums.back();
          nums.pop_back();
          nums.push_back(left+right);
          break;
        case 1: // 1 E -> E - T
          right = nums.back();
          nums.pop_back();
          left = nums.back();
          nums.pop_back();
          nums.push_back(left-right);
          break;
        case 3: // 3 T -> T * F
          right = nums.back();
          nums.pop_back();
          left = nums.back();
          nums.pop_back();
          nums.push_back(left*right);
          break;
        }
      }

      else {
        std::cout << nums[0] << std::endl;
        break;
      }

    }
  }


  return 0;
}

