#!/bin/bash

function table_header() {
  echo "| Dirname | Language | Author | Notes | Time | Passed |"
  echo "| --- | --- | --- | --- | --- | --- |"
}

function table_entry() {
  readarray -t lines < bench.txt
  words=(${lines[1]})

  if [[ -f "ok.txt" ]]; then
    passed=":white_check_mark:"
  else
    passed=":x:"
  fi

  readarray -t infos < info.txt
  echo "| $(dirname "$f") | ${infos[0]} | ${infos[1]} | ${infos[2]} | ${words[1]} | $passed |"
}

table_header

for f in */result.txt; do
  cd "$(dirname "$f")"
  if [[ -f "bench.txt" ]] && [[ -f "info.txt" ]]; then
    table_entry
  fi
  cd ..
done
