#!/usr/bin/python3

#+---+------------------+------------------+
#| A |       abs()      |    aiter()       |
#|   |      all()       |     any()        |
#|   |      anext()     |    ascii()       |
#+---+------------------+------------------+
#| B |      bin()       |     bool()       |
#|   |  breakpoint()    |  bytearray()    |
#|   |      bytes()     |                  |
#+---+------------------+------------------+
#| C |   callable()     |      chr()       |
#|   | classmethod()    |    compile()     |
#|   |   complex()      |                  |
#+---+------------------+------------------+
#| D |   delattr()      |     dict()       |
#|   |      dir()       |    divmod()      |
#+---+------------------+------------------+
#| E |  enumerate()     |      eval()      |
#|   |      exec()      |                  |
#+---+------------------+------------------+
#| F |    filter()      |     float()      |
#|   |    format()      |  frozenset()     |
#+---+------------------+------------------+
#| G |   getattr()      |    globals()     |
#+---+------------------+------------------+
#| H |   hasattr()      |      hash()      |
#|   |      help()      |      hex()       |
#+---+------------------+------------------+
#| I |      id()        |     input()      |
#|   |      int()       | isinstance()    |
#|   | issubclass()     |      iter()      |
#+---+------------------+------------------+
#| L |      len()       |     list()       |
#|   |    locals()      |                  |
#+---+------------------+------------------+
#| M |      map()       |     max()        |
#|   | memoryview()     |     min()        |
#+---+------------------+------------------+
#| N |     next()       |                  |
#+---+------------------+------------------+
#| O |    object()      |      oct()       |
#|   |      open()      |      ord()       |
#+---+------------------+------------------+
#| P |      pow()       |     print()      |
#|   |   property()     |                  |
#+---+------------------+------------------+
#| R |    range()       |     repr()       |
#|   |  reversed()      |     round()      |
#+---+------------------+------------------+
#| S |      set()       |    setattr()     |
#|   |     slice()      |    sorted()      |
#|   | staticmethod()   |      str()       |
#|   |      sum()       |     super()      |
#+---+------------------+------------------+
#| T |     tuple()      |     type()       |
#+---+------------------+------------------+
#| V |      vars()      |                  |
#+---+------------------+------------------+
#| Z |      zip()       |                  |
#+---+------------------+------------------+
#| _ |  __import__()   |                  |
#+---+------------------+------------------+



# 1. A
#+---+------------------+------------------+
#| A |      abs()       |    aiter()       |
#|   |      all()       |    any()         |
#|   |      anext()     |    ascii()       |
#+---+------------------+------------------+
# abs(): Returns the absolute value of a number
num = -10
absolute_value = abs(num)
print("Absolute value:", absolute_value)

# all(): Returns True if all elements in an iterable are true
my_list = [True, True, False]
all_true = all(my_list)
print("All elements are true:", all_true)

# ascii(): Returns a string containing a printable representation of an object
text = "Hello, World!"
ascii_representation = ascii(text)
print("ASCII representation:", ascii_representation)

# Async generator providing an asynchronous iterable
async def async_range(n):
    for i in range(n):
        yield i
        await asyncio.sleep(0.1)  # Simulating an asynchronous operation

# Async function using async for loop
async def iterate_async():
    # Async iterable example
    async for i in async_range(5):
        print(i)

# Run the async function
import asyncio
asyncio.run(iterate_async())

from printer import print_columns
# Get the names defined in the asyncio module
print_columns('asyncio', num_columns=3)



