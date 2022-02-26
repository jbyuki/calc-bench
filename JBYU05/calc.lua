local line = io.read()
while line do
  local f = loadstring("return " .. line)
  print(f())
  line = io.read()
end
