import fileinput

for line in fileinput.input():
    print(eval(line))
