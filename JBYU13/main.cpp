// Generated using ntangle.nvim
#include <array>

#include <cstdio>



auto main() -> int
{
  // @read_all_at_once
  constexpr int BUFFER_SIZE = 4096;
  std::array<char, BUFFER_SIZE> buffer;

  while(fgets(buffer.data(), BUFFER_SIZE, stdin)) {
    printf("0\n");
  }

  return 0;
}

