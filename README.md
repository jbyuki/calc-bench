Calc Bench
==========

> This is an **experimental** project. A lot of improvements can surely be made. Please be aware of it.

The goal is to implement the **same** program using **different** languages and techniques and benchmark it **automatically** using `Github Actions`.

| Dirname | Language | Author | Notes | Time | Passed |
| --- | --- | --- | --- | --- | --- |
| JBYU01 | bison/flex | jbyuki | - | 0m0.006s | :white_check_mark: |
| JBYU02 | c++ | jbyuki | Pratt's parser (with the use of std::shared_ptr) | 0m0.024s | :white_check_mark: |
| JBYU03 | c++ | jbyuki | Pratt's parser (without the use of std::shared_ptr) | 0m0.021s | :white_check_mark: |
| JBYU04 | python | jbyuki | Use `eval()` | 0m0.081s | :white_check_mark: |
| JBYU05 | luajit | jbyuki | Use `loadstring()` | 0m0.017s | :white_check_mark: |
| JBYU06 | javascript | jbyuki | Use `eval()` | 0m0.308s | :white_check_mark: |
| JBYU07 | c++ | jbyuki | Recursive descent parser | 0m0.019s | :white_check_mark: |
| JBYU08 | c++ | jbyuki | Always fails | 0m0.020s | :x: |
| JBYU09 | c++ | jbyuki | SLR Parser | 0m0.022s | :white_check_mark: |
| JBYU10 | c++ | test | test | 0m0.020s | :x: |

Table of Contents
-----------------

* [Introduction](#introduction)
* [Task](#intro)
* [Submission](#submission)
* [Credits](#credits)

Introduction
------------

Why create this project?

This project is primarily about benchmarking a parser. This was meant for my personal use, how to make fast text parser. The baseline will be the `bison/flex` implementation. By progressively becoming better in parsing techniques, the goal is to write a parser which beats this baseline time. This surely won't be easy and maybe just dumb but why not try it.

The project is of course public. So anybody interesting in bringing a contribution is welcome. That's where `Github actions` come into play. By submitting the code to this repository, the program will be automatically compiled, run, checked and benchmarked against other implementations on the **same** environnement (or at least, to the extend of my knowledge, it seems so). So if you want to show your nice little program, this is a great platform to do so.

Task
----

So what is the task exactly?

I tried to stick to an easy task, let's say. The parser should well.. parse a simple arithmetic expression. These are some examples:

```
(2+3)*11
1*10-2*3
```

The operators it should recognize are `+`, `-` and `*`. No divison is present to avoid taking care of the division by 0 problems. With that, the parenthesis should also be supported. The numbers are standard positive integers. As you can see, it's very simple.

The input will be generated by [gen.sh](gen.sh), which will consists of a number of lines which should each be parsed separately. At the moment, the file has 10'000 lines but this can change. The program should for each line print in the result in the standard output.

The parser should respect mathematical precedence.  `( )` > `*` > `+ -`. The operations should be done from left to right. The following operations should give these results:

```
2*2+3*3 = 13
1+1-1 = 1
```

<details>
<summary>Here is an example of <code>input.txt</code>:</summary>
<pre>
8*(3)
(7-9-2-6)+8
10+7+(4)
((4))
(8+9*8)-5-10
(2)*9*8+4-6*6
1
4*2-3-10
3
1
</pre>
</details>

<details>
<summary>And the corresponding <code>output.txt</code>:</summary>
<pre>
24
-2
21
4
65
112
1
-5
3
1
</pre>
</details>

Submission
----------

Now that the task should more be clear comes the question of how it is benchmarked. 

Each submission is contained in a folder. For example : [JBYU01](JBYU01/).

The naming format is not important.

This folder contains the following files:
```
FOLDER
   - install.sh
   - run.sh
   - Makefile
   - info.txt
   - ...
```

**[install.sh](JBYU01/install.sh)**

This bash script will be run before any compilation. It should install any dependencies needed by the program.

**[Makefile](JBYU01/run.sh)**

This will build the executable of the program. If the program is only interpreted, this might not be necessary.

**[run.sh](JBYU01/run.sh)**

This script will run the program with the input. Typically, it only contains a single line such as:
```
./calc < ../input.txt > result.txt
```

The program has to output a `result.txt`. The naming is important. `input.txt` is the file generated by the script [gen.sh](gen.sh) right at the beginning.

**[info.txt](JBYU01/info.txt)**

A convienent little file which should contain metadata about the program. For now, the format is very simple.

```
LANGUAGE_NAME
AUTHOR_NAME
DESCRIPTION
```

The Github Action will scan for `info.txt` files so that it can put it alongside the benchmark time in the results table.

Credits
-------

* It was partially inspired by the [benchmarksgame](https://benchmarksgame-team.pages.debian.net/benchmarksgame/)
