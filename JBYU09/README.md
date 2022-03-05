This should be very similar to what bison/flex is doing
but hand written.

The LR table is generated with an external script using the
SLR algorithm.

| * | id | ) | + | - | ( | $ | T | F | E |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
|   |s2 |   |   |   |s6 |   |3  |4  |5  |
|r7 |   |r7 |r7 |r7 |   |r7 |   |   |   |
|s7 |   |r3 |r3 |r3 |   |r3 |   |   |   |
|r5 |   |r5 |r5 |r5 |   |r5 |   |   |   |
|   |   |   |s8 |s9 |   |a  |   |   |   |
|   |s2 |   |   |   |s6 |   |3  |4  |10 |
|   |s2 |   |   |   |s6 |   |   |11 |   |
|   |s2 |   |   |   |s6 |   |12 |4  |   |
|   |s2 |   |   |   |s6 |   |13 |4  |   |
|   |   |s14|s8 |s9 |   |   |   |   |   |
|r4 |   |r4 |r4 |r4 |   |r4 |   |   |   |
|s7 |   |r1 |r1 |r1 |   |r1 |   |   |   |
|s7 |   |r2 |r2 |r2 |   |r2 |   |   |   |
|r6 |   |r6 |r6 |r6 |   |r6 |   |   |   |

* `r2` means **reduce** using rule `2`, see below
* `s4` means **shift** and go to state `4`
* `a` means **accept**

```
1) E -> E + T
2) E -> E - T
3) E -> T
4) T -> T * F
5) T -> F
6) F -> ( E )
7) F -> id
8) E' -> E
```

Reference: Compilers, Principles, Techniques, & Tools. Aho, Lam, Sethi & Ullman
