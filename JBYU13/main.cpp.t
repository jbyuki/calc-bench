@./main.cpp=
@includes

@declare
@global_variables
@functions

auto main() -> int
{
  // @read_all_at_once
  @create_array
  @only_read_and_output_0

  return 0;
}

@includes+=
#include <array>

@create_array+=
constexpr int BUFFER_SIZE = 4096;
std::array<char, BUFFER_SIZE> buffer;

@includes+=
#include <cstdio>

@only_read_and_output_0+=
while(fgets(buffer.data(), BUFFER_SIZE, stdin)) {
  printf("0\n");
}
