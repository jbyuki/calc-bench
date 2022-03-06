@./main.cpp=
@includes

@structs
@global_variables

auto main() -> int
{
  // @open_input_file
  @read_all_at_once
  @parse_each_line_and_display_result


  return 0;
}

@includes+=
#include <fstream>
#include <iostream>

@open_input_file+=
std::ifstream in("../input.txt");

@read_all_at_once+=
std::istreambuf_iterator<char> begin(std::cin), end;
std::string buffer(begin, end);

@includes+=
#include <string>
#include <cstdio>

@parse_each_line_and_display_result+=
int m=0;
while(m<buffer.size()) {
  @tokenize_line
  @append_ending_token

  @init_states
  int i=0;
  while(true) {
    Token& s = tokens[i];

    @if_action_is_shift
    @if_action_is_reduce
    @if_action_is_accept
  }
}

@structs+=
struct Token
{
  enum {
    @token_types
  } type;
  @token_data
};

@includes+=
#include <vector>

@global_variables+=
std::vector<Token> tokens;

@includes+=
#include <stdio.h>

@tokenize_line+=
tokens.clear();

bool eol = false;
for(;m<buffer.size()&&!eol;) {
  switch(buffer[m]) {
  @if_character_is_number
  @if_character_is_parenthesis
  @if_character_is_operator
  default:
    eol = true;
    ++m;
    break;
  }
}

@if_character_is_number+=
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
  @parse_number
  @create_number_token
}
break;

@parse_number+=
do
{
  res = 10*res + (int)(buffer[m]-'0');
  ++m;
} while(m < buffer.size() && std::isdigit(buffer[m]));

@token_types+=
NUM_TOKEN = 1,

@token_data+=
int num;

@create_number_token+=
Token token;
token.type = Token::NUM_TOKEN;
token.num = res;
tokens.push_back(token);

@if_character_is_parenthesis+=
case '(':
{
  @create_open_paren_token
}
break;

case ')':
{
  @create_close_paren_token
}
break;

@token_types+=
CLOSE_PAR_TOKEN = 2,
OPEN_PAR_TOKEN = 5,

@create_open_paren_token+=
Token token;
token.type = Token::OPEN_PAR_TOKEN;
tokens.push_back(token);
++m;

@create_close_paren_token+=
Token token;
token.type = Token::CLOSE_PAR_TOKEN;
tokens.push_back(token);
++m;

@token_types+=
ADD_TOKEN = 3,
SUB_TOKEN = 4,
MUL_TOKEN = 0,

@if_character_is_operator+=
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

@token_types+=
END_TOKEN = 6,

@append_ending_token+=
Token token;
token.type = Token::END_TOKEN;
tokens.push_back(token);

@global_variables+=
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

@global_variables+=
std::vector<int8_t> stack;

@init_states+=
stack.clear();
stack.push_back(0);

@if_action_is_shift+=
int8_t t = stack.back();
int8_t action = action_table[t*7+s.type];

@if_action_is_reduce+=
else if(action<0) {
  int r = rhs_len[-(action+1)];

  @reduce_stack
  @perform_goto

  @perform_reduce_action
}

@reduce_stack+=
for(int8_t j=0; j<r; ++j) {
  stack.pop_back();
}

@global_variables+=
const int8_t lhs[] = {
  2, // 1) E -> E + T
  2, // 2) E -> E - T
  2, // 3) E -> T
  0, // 4) T -> T * F
  0, // 5) T -> F
  1, // 6) F -> ( E )
  1 // 7) F -> id
};

@perform_goto+=
t = stack.back();
stack.push_back(goto_table[t*3+lhs[-(action+1)]]-1);

@if_action_is_shift+=
if(action>0) {
  stack.push_back(action-1);
  @push_tokens
  ++i;
}

@if_action_is_accept+=
else {
  printf("%d\n", nums[0]);
  break;
}

@global_variables+=
std::vector<int> nums;

@init_states+=
nums.clear();

@push_tokens+=
if(s.type == Token::NUM_TOKEN) {
  nums.push_back(s.num);
}

@global_variables+=
int left, right;

@perform_reduce_action+=
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
