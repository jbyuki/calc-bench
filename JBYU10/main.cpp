// Generated using ntangle.nvim
#include <fstream>
#include <iostream>

#include <string>
#include <cstdio>

#include <vector>

#include <stdio.h>

#include <array>


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
  // @read_all_at_once
  constexpr int BUFFER_SIZE = 4096;
  std::array<char, BUFFER_SIZE> buffer;
  while(fgets(buffer, BUFFER_SIZE, stdin)) {
  }
  // @parse_each_line_and_display_result


  return 0;
}

