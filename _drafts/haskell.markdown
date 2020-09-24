---
layout: post
title:  "Haskell interesting bits"
subtitle: 
date:   2020-09-19 15:49:24 +0530
tags: engineering functional-programming
category: engineering
---

- Typed language with type inference (Oh! I missed this in Scheme!)
- prefix function can be written as infix for better readability
- cool specification of uniformly spaced lists or infinite lists:

```haskell
ghci> [2,4,..20]
[2,4,6,8,10,12,14,16,18,20]

;; infinite lists
ghci> let series=[1,1..]

;; first 25 multiples of 13
ghci> let multiples13 = take 25 [13,26..]
```
- list comprehension: A parallel of set comprehension - mathematical way of defining a set

```haskell
;; find the first 10 right angled triangles (sorted by perimeter)
ghci> let triangles = [(a,b,c) | c<-[1..], b<-[1..c], a<-[1..b]]
ghci> take 5 triangles
[(1,1,1),(1,1,2),(1,2,2),(2,2,2),(1,1,3)]
ghci> let rightTriangles = [(a,b,c) | (a,b,c)<-triangles, c*c == (a*a+b*b)]
ghci> take 10 rightTriangles
[(3,4,5),(6,8,10),(5,12,13),(9,12,15),(8,15,17),(12,16,20),(15,20,25),(7,24,25),(10,24,26),(20,21,29)]

;; I really see this making life easier for projecteuler.net problems
```
- Tuples: A tuple type is made of a) different number of argument, and b) the individual argument types (and their order).
- The type (`:t <expression>`) for a function makes no distinction between paramters and arguments:

```haskell
ghci> :t threeArgFunc
threeArgFunc :: Num a => a -> a -> a -> a
```

- `Int` to represented bounded 32/64-bit values. `Integer` is like BigInt (of java)
- Pattern matching- define different behaviors for a function on different inputs [base conditions first- Order is important!]:

```haskell
factorial 0 = 1
factorial n = n * factorial (n-1)
```
Pattern matching allows you to match the argument to some defined form, and have a way to deconstruct it.  
Also, pattern matching would work great with recursions.

- Polymorphic functions: Functions whose type is composed of a type variable (representing "any" type - similar to generics in other languages, but more general)
- [typeclasses](http://learnyouahaskell.com/types-and-typeclasses): Define a set of functions that have different implementation depending on the type of data they are given. [Kinda seems like protocols, not sure how it's different.]  
Use **type annotations** to remove ambiguity.

- Guards, guards!
```haskell
remainingTime age
  | age < 50               = 70
  | age >= 50 && age <= 70 = 50 + (70-age)*2
  | otherwise              = age + fromIntegral(round(age**0.5))
```

- `Where clauses`, `let in`
```haskell
calcBmis whs = [ bmi weight height | (weight, height) <- whs]
  where bmi weight height = (weight/height^2)
```

- Currying or partial application




## References:
- Useful info/shortcuts on emacs haskell-mode setup - [link](https://haskell.github.io/haskell-mode/manual/latest/)
