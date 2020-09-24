---
layout: post
title:  "Implementing Streams in Swift"
subtitle: 
date:   2020-09-12 15:49:24 +0530
tags: swift iOS functional-programming streams engineering
category: engineering
---

**Streams are delayed lists.**



// streams are coming from functional programming languages. delayed lists. Feature big time in functional programming languages. The elements are computed on demand (or lazily) rather than eagerly. Because of their delayed nature, they allow for interesting properties like recursive definitions and infinite lists.
// I've been wondering if I can implement it in swift.
// Swift has Lazy views around collections which allows on-demand generation of results in operations like  map and filter. It's a good optimization trick.
// examples:


// why should user care about streams?
- efficient use of memory: implementing as lists mean intermediate structures must hold all data even though they might be accumulated or filtered later on.
- The right way to do this would be to interleave the enumeration and filtering, preventing using up large amounts of memory
- Streams are a clever idea to get the best of both worlds - formulating our expressions elegantly using higher order expressions, while having the efficiency of incremental computations.


// take a bit of inspiration from the way java implemented it: https://www.baeldung.com/java-inifinite-streams
