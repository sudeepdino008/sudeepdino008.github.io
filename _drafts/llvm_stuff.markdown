---
layout: post
title:  "LLVM explore"
subtitle: 
date:   2020-08-16 15:49:24 +0530
tags: llvm engineering
category: engineering
---


Scared as shit. I don't know how it'll go. 
The only remedy is to just start, explore and engage your curiosity. Trust yourself to find something interesting.
Once you know this, don't be carried away by fear. Hold strong. Stand your ground when there's uncertainty around.
Have faith in your abilities. Have an unwavering faith in your abilties. NEVER DOUBT YOURSELF. In this journey, curiosity and grit is crucial. Use them, keep coming back to them.'

Trying to get the rst documentation going with all the links. TIme bounded, and time up.

Going at the ['My First Language Frontend with LLVM tutorial'](https://llvm.org/docs/tutorial/MyFirstLanguageFrontend/index.html).
- lexer (aka scanner): gives out the tokens
- parser: build the AST

I feel it'll be nice to brush on on c++ (sure) but that's for later.

['llvm-config'](https://llvm.org/docs/CommandGuide/llvm-config.html): printing llvm compilation options, making it easier to compile programs which use llvm.

[Static single assignment (SSA)](https://en.wikipedia.org/wiki/Static_single_assignment_form) : It's a property of IR wherein: declare the variables before use, and assign them only once. Allows compiler optimizations to be done easily.

Clang: the c,c++,obj-c compiler. Essentially a driver which transparently provides options to control preprocessing; parsing and semantic analysis; code gen and optimization; assembler; linker

make\_unique not found in std namespace, but found in llvm namespace: make_unique became a part of standard library since c++14, adding a -std=c++14 flag would suffice. Might consider updating llvm to a version built on c++14 will help too,  


Stop at assemble (don't link): -c option  
Undefined symbol: you are probably missing out some library to link.   

```bash
/// Assemble step
clang++ -O0 parser.cpp lexer.cpp -g $(llvm-config --cxxflags)  -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -std=c++14
```

```bash
/// Link step
clang++ parser.o lexer.o $(llvm-config --ldflags --libs --system-libs) -lLLVMCore -lpthread
```

```bash
/// Alternative (Combined)
clang++ -O0 parser.cpp lexer.cpp -g $(llvm-config --cxxflags --ldflags --libs --system-libs) -isysroot /Library/Developer/CommandLineTools/SDKs/MacOSX.sdk -std=c++14
```


Reading about Rvalues: [link][1], [link][2] and [link][6]
- allow programmers to avoid unnecessary copying and perfect forwaring functions (?). Meant for the design of high performance libraries.
- rvalue is declared with two apersands (&&) while lvalues with single ampersand.
- primary used for std::move: expensive to copy objects (like a list of vectors), can be "moved" from the original location and set to the member variable of the object (for whom the constructor or setter was invoked). 
- although rvalues are more than the move semantics.
- perfect forwarding (using std::forward<T>): it can recognise if a function is being called with lvalue or rvlue, and perform function overloading resolution (lvalue/rvalue accepting function with same name)



Getting debugging working with xcode:
- Provide compile flags for each file in build phase.
- Provide 'Other Linker flags' in build settings.


[Two's complement][3]: Great to unambiguously represent negative integers. Also on example of radix complement (encoding technique by which the negative and positive integers are represented in manner such that the same algorithm (at hardware level) can be used to perform arithmetic operations on them).

[Basic Block][8], [Control flow graph][9]

[Modern compiler design by Anders Hejlsberg][10] - The compiler has to run "live" now to support tooling like syntax highlighting or autocomplete (even thought the program might be syntactically wrong). The approach taken is usually to just discard whatever you know about the current file and rebuild the information around the position where you are typing (information about other files and more distant nodes remain the same).  
There's a different challenge with dynamic languages where types are not available.  
To support various editors to add tooling support for a particular language, there's a language server (running in a different process), with which the editor can interact to get information about autcomplete or errors.  
These then is very different from what is traditionally taught at schools (dragon book), wherein the entire compiler pipeline is run from start to end, rather than as a real-time interactive system which modern IDEs demand.


Kaleidoscope: added IR codegen. Going to add optimizer support and JIT compiler support.

Todos:
unique_ptr  
std::move
[what every c programmer should know about undefined behavior][4] 
[rvalue proposal][5]
At some point add some features from [language reference][7] to kaleidoscope.


[1]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2027.html
[2]: http://thbecker.net/articles/rvalue_references/section_01.html
[3]: https://en.wikipedia.org/wiki/Two%27s_complement
[4]: https://web.archive.org/web/20200702085845/http://blog.llvm.org/2011/05/what-every-c-programmer-should-know.html
[5]: http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2118.html
[6]: https://www.justsoftwaresolutions.co.uk/cplusplus/rvalue_references_and_perfect_forwarding.html
[7]: https://llvm.org/docs/LangRef.html
[8]: https://en.wikipedia.org/wiki/Basic_block
[9]: https://en.wikipedia.org/wiki/Control-flow_graph
[10]: https://channel9.msdn.com/Blogs/Seth-Juarez/Anders-Hejlsberg-on-Modern-Compiler-Construction
