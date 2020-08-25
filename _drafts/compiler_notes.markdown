---
layout: post
title:  "Compiler notes"
subtitle: 
date:   2020-08-16 15:49:24 +0530
tags: engineering compilers
category: engineering
---


- Natural language has ambiguities. Progamming language shouldn't have any ambiguity. Ambiguous statements have no meaning.
- interpreters take a executable specification, executes it and returns the output. Compare with compilers, which takes one executable specification and converts to another executable specification.
- mixed modes are there - Java compiles into bytecode, and then this is interpreted by the JVM. For more complicated examples, consider Some implementations of JVM which include a JIT which compiles the bytecode into machine executable instructions at runtime.
- Techniques to analyze whole programs are moving from compilation to linking time, where the entire compiled codebase is available, which opens up new insights which were not present at compile time. Similarly, compiler are being invoked at runtime to generate native instructions with knowledge which were not simply present at compile or link time.
- The optimizers can have several objectives - fast compilation, smaller executable size, lesser page faults, less energy usage.
- optimizations: consists of analysis (if a particular transformation will be 'efficient') and transformation.  
Data flow analysis, reasons the flow of code at runtime.
