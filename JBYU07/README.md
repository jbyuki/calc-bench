A simple recursive descent parser.

It _should_ be blazingly fast compared to other implementations.

Grammar rules which were transformed to remove any left recursion.

```
E -> T E'
E' -> + T E'
E' -> - T E'
E' -> eps
T -> F T'
T' -> * F T'
T' -> eps
F -> ( E )
F -> id
```
