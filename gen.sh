#!/bin/bash
max_depth=4
num_seq=10000
function gen_expr() {
  depth=$(($depth + 1))
  if [[ $depth -gt $max_depth ]]; then
    depth=$(($depth - 1))
    retval=$(($RANDOM % 10 + 1))
    return
  fi

  choice=$(($RANDOM % 100))
  if [[ $choice -lt 40 ]]; then # Number
    retval=$(($RANDOM % 10 + 1))
  elif [[ $choice -lt 55 ]]; then # Add
    gen_expr
    local left=$retval
    gen_expr
    local right=$retval
    retval="$left+$right"
  elif [[ $choice -lt 70 ]]; then # Sub
    gen_expr
    local left=$retval
    gen_expr
    local right=$retval
    retval="$left-$right"
  elif [[ $choice -lt 85 ]]; then # Mul
    gen_expr
    local left=$retval
    gen_expr
    local right=$retval
    retval="$left*$right"
  else # Paren
    gen_expr
    retval="($retval)"
  fi
  depth=$(($depth - 1))
}
for i in $(seq 1 $num_seq); do
  depth=0
  gen_expr
  echo "$retval"
done
