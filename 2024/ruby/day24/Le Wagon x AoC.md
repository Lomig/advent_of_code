# Le Wagon x Advent of Code — Solution Sharing
## Part One
* Very straightforward puzzle:
    * you need to activate gates which inputs are all active
    * new inputs will be activated: new gates can be activated afterward
    * repeat and profit
* I used the active wires as a base, only taking gates from them to avoid unnecessary iterations

## Part Two
As per the puzzle description,
* quote: "**the system you're simulating is trying to add two binary numbers**"
* the system only deals with `AND`, `OR`, and `XOR` gates

It means that we are building a very simple ALU with just an adder
  * [Ben Eater video about building an ALU Part 1](https://www.youtube.com/watch?v=mOVOS9AjgFs)
  * [Ben Eater video about building an ALU Part 2](https://www.youtube.com/watch?v=S-3fXU3FZQc)
  * [Ben Eater video about building an adder](https://www.youtube.com/watch?v=wvJc9CZcvBc)
  * (Look the whole series, it is very instructive!)

### Building an Adder
#### 1-bit Half Adder
Imagine we want to add 2 bits `A` and `B`
* We can represent the operation through a truth table
* We can put together logic gates to resolve the truth table


```text
SUM(A, B)

 A │ B ║ Sum │ Carry
═══╪═══╬═════╪═══════
 0 │ 0 ║  0  │   0
 0 │ 1 ║  1  │   0
 1 │ 0 ║  1  │   0
 1 │ 1 ║  0  │   1
 
 
               ┌─────┐
 A ━━━━━━━━┳━━━┥     │
           ┃   │ XOR ┝━━━ SUM
 B ━━━━┳━━━━━━━┥     │
       ┃   ┃   └─────┘
       ┃   ┃   ┌─────┐
       ┃   ┗━━━┥     │    
       ┃       │ AND ┝━━━ CARRY
       ┗━━━━━━━┥     │
               └─────┘

Demonstration:

   CASE (0, 0)                          CASE (0, 1)
               ┌─────┐                              ┌─────┐
 A ━0━━━━━━┳━━0┥     │                A ━0━━━━━━┳━━0┥     │
           ┃   │ XOR ┝0━━ SUM                   ┃   │ XOR ┝1━━ SUM
 B ━0━━┳━━━━━━0┥     │                B ━1━━┳━━━━━━1┥     │
       ┃   ┃   └─────┘                      ┃   ┃   └─────┘
       ┃   ┃   ┌─────┐                      ┃   ┃   ┌─────┐
       ┃   ┗━━0┥     │                      ┃   ┗━━0┥     │ 
       ┃       │ AND ┝0━━ CARRY             ┃       │ AND ┝0━━ CARRY
       ┗━━━━━━0┥     │                      ┗━━━━━━1┥     │
               └─────┘                              └─────┘
 
   CASE (1, 0)                          CASE (1, 1) 
               ┌─────┐                              ┌─────┐
 A ━1━━━━━━┳━━1┥     │                A ━1━━━━━━┳━━1┥     │
           ┃   │ XOR ┝1━━ SUM                   ┃   │ XOR ┝0━━ SUM
 B ━0━━┳━━━━━━0┥     │                B ━1━━┳━━━━━━1┥     │
       ┃   ┃   └─────┘                      ┃   ┃   └─────┘
       ┃   ┃   ┌─────┐                      ┃   ┃   ┌─────┐
       ┃   ┗━━1┥     │                      ┃   ┗━━1┥     │ 
       ┃       │ AND ┝0━━ CARRY             ┃       │ AND ┝1━━ CARRY
       ┗━━━━━━0┥     │                      ┗━━━━━━1┥     │
               └─────┘                              └─────┘
```
Half adder can add 2 bits, but we need more than that to add 2 numbers, because of the carry!

#### 1-bit Full Adder
Imagine we want to add 2 bits `A` and `B`, but the previous adder had a carry `C` to take into account
* We can represent the operation through a truth table
* We can put together logic gates to resolve the truth table
* 2 half adders can be used to build a full adder (thus the name)


```text
SUM(A, B, C)

 A │ B │ C ║ Sum │ Carry
═══╪═══╪═══╬═════╪═══════
 0 │ 0 │ 0 ║  0  │   0
 0 │ 1 │ 0 ║  1  │   0
 1 │ 0 │ 0 ║  1  │   0
 1 │ 1 │ 0 ║  0  │   1
 0 │ 0 │ 1 ║  1  │   0
 0 │ 1 │ 1 ║  0  │   1
 1 │ 0 │ 1 ║  0  │   1
 1 │ 1 │ 1 ║  1  │   1
 
 
                       ┌────────────┐
 C ━━━━━━━━━━━━━━━━━━━━┥            ┝━━━━━━━━━━━━━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━━┥            ┝━━━┥            ┝━━━┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━━━ CARRY
 B ━━━┥            ┝━━━━━━━━━━━━━━━━━━━━┥     │
      └────────────┘                    └─────┘


Demonstration:

   CASE (0, 0, 0)
                       ┌────────────┐
 C ━━0━━━━━━━━━━━━━━━━0┥            ┝0━━━━━━━━━━0━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━0┥            ┝━━0┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━0━ CARRY
 B ━━0┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (0, 1, 0)
                       ┌────────────┐
 C ━━0━━━━━━━━━━━━━━━━0┥            ┝1━━━━━━━━━━1━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━0┥            ┝━━1┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━0━ CARRY
 B ━━1┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (1, 0, 0)
                       ┌────────────┐
 C ━━0━━━━━━━━━━━━━━━━0┥            ┝1━━━━━━━━━━1━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━0┥            ┝━━1┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━0━ CARRY
 B ━━1┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (1, 1, 0)
                       ┌────────────┐
 C ━━0━━━━━━━━━━━━━━━━0┥            ┝0━━━━━━━━━━0━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━1┥            ┝━━0┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━1━ CARRY
 B ━━1┥            ┝1━━━━━━━━━━━━━━━━━━1┥     │
      └────────────┘                    └─────┘


    CASE (0, 0, 1)
                       ┌────────────┐
 C ━━1━━━━━━━━━━━━━━━━1┥            ┝1━━━━━━━━━━1━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━0┥            ┝━━0┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━0━ CARRY
 B ━━0┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (0, 1, 1)
                       ┌────────────┐
 C ━━1━━━━━━━━━━━━━━━━1┥            ┝0━━━━━━━━━━0━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━0┥            ┝━━1┥            ┝━━1┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━1━ CARRY
 B ━━1┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (1, 0, 1)
                       ┌────────────┐
 C ━━1━━━━━━━━━━━━━━━━1┥            ┝0━━━━━━━━━━0━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━1┥            ┝━━1┥            ┝━━1┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━1━ CARRY
 B ━━0┥            ┝0━━━━━━━━━━━━━━━━━━0┥     │
      └────────────┘                    └─────┘


    CASE (1, 1, 1)
                       ┌────────────┐
 C ━━1━━━━━━━━━━━━━━━━1┥            ┝1━━━━━━━━━━1━ SUM
      ┌────────────┐   │ HALF ADDER │   ┌─────┐ 
 A ━━1┥            ┝━━0┥            ┝━━0┥     │
      │ HALF ADDER │   └────────────┘   │ OR  ┝━1━ CARRY
 B ━━1┥            ┝1━━━━━━━━━━━━━━━━━━1┥     │
      └────────────┘                    └─────┘
```
#### n-bit Adder: The Ripple-Carry Adder
* We can chain full adders to add n bits
* The puzzle should represent such a `RCA`
```text
Exemple from the puzzle adding 3-bits numbers
(Carry at bottom)


       ┌────────────┐   
X00 ━━━┥            ┝━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Z00
       │ HALF ADDER │
Y00 ━━━┥            ┝━┓         ┌────────────┐
       └────────────┘ ┃  X01 ━━━┥            ┝━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ Z01
                      ┃         │            │
                      ┃  Y01 ━━━┥ FULL ADDER │            ┌────────────┐
                      ┃         │            │     X02 ━━━┥            ┝━━━ Z02
                      ┗━━━━━━━━━┥            ┝━━┓         │            │ 
                                └────────────┘  ┃  Y01 ━━━┥ FULL ADDER │
                                                ┃         │            │
                                                ┗━━━━━━━━━┥            ┝━━━ Z03
                                                          └────────────┘
```

The puzzle would be translated as "which Full Adder is not wired correctly?"

### Wiring rules
From above schematics:
* `z_max` is a `carry` of a `FULL ADDER` gate
  * it should be the output of a `OR` gate
* `z.. < z_max` are the `sum` of a `FULL ADDER` gate
  * they should be the `sum` of a `HALF ADDER` gate
  * they should be the output of a `XOR` gate
* `x..` `XOR` `y..` **cannot** output any `z` (They are gated through a `FULL ADDER`)
* `x..`, `y..` and `z..` are the inputs / outputs of some `HALF ADDER`
  * `XOR` gates should always connect at least a `x..`, a `y..` or a `z..`
* the output of a `AND` gate is never the input of a `XOR` gate (but if `x00` as input)
* the output of a `XOR` gate is never the input of an `OR` gate (but if `x00` as input)

Maybe there are other rules, maybe some are unnecessary, but I decided to try my luck with these.

### Algorithm
We just get to implement those rules and get the output of failing ones, without taking care of swaps or anything.
* For all Gates, select gates
  * if *not* `OR` and output is `z_max`
  * if *not* `XOR` and output is `z.. < z_max`
  * if `XOR` with `x..` and `y..` as inputs and `z..` as output
  * if `XOR` without `x..` or `y..` as inputs or `z..` as output
  * if `AND` without `x00` as input, and with output being used in `XOR` gate
  * if `XOR` without `x00` as input, and with output being used in a `OR` gate
* Map to its output
* Sort
