---
layout: post
title:  "Reading 'Embed Pods Framework' script"
subtitle: 
date:   2020-07-20 15:49:24 +0530
tags: iOS cocoapods engineering
category: engineering
---

Cocoapods is a resounding name in the world of iOS development. It's a dependency manager for Swift/Objc projects. On doing a `pod install` it does a couple of things including a new build phase called 'Embed Pods Framework' in your existing project.

This build phase essentially executes a script - **Pods-\<AppName\>-frameworks.sh**. I've been wondering what it does and started to read it. It turned out to be a light read, but I picked up a few things along the way. What follows is a little summary. There will be a few digressions about things discovered while reading the script.

![Here's the script I'm talking about in Xcode build phase](/assets/images/20-07-2020/script_location.png)


Most of the script is about "installing" the dependency frameworks. Note that by this stage, the dependencies (`.framework` files) have already been built in `${BUILT_PRODUCTS_DIR}`.
  
<br>
## Copying the framework 

This step is about copying the framework from a source to the destination. Copying the framework is essentially about "bundling" the framework together with the app, so that when the app runs, it can find the necessary frameworks.


```bash
# sample source
${BUILT_PRODUCTS_DIR}/XCGLogger/XCGLogger.framework/

# sample destination
${BUILT_PRODUCTS_DIR}/ExperimentalApp.app/Frameworks/ObjcExceptionBridging.framework/
```

Here's the first interesting nugget - the `rsync` command. 
`rsync` command is used to transfer the framework binary and other framework files to the destination. It is used rather than traditional `cp`, since it can detect deltas in the binary and transfer only the diff information to the destination. This ends up being way faster for larger binaries. 

Quoting the `rsync` manpage:
```text
Rsync is a fast and extraordinarily versatile file copying tool. It can copy locally, 
to/from another host over any remote shell, or to/from a remote rsync daemon. 
It offers a large number of options that control every aspect of its behavior and permit 
very flexible specification of the set of files to be copied. It is famous for its 
delta-transfer algorithm, which reduces the amount of data sent over the network by 
sending only the differences between the source files and the existing files in the 
destination. Rsync is widely used for backups and mirroring and as an improved copy 
command for everyday use.
```

Given that a framework binary can easily reach near 100MBs and that there will be multiple such frameworks, the use of rsync totally makes sense.


__Question__: I found that the framework binary at destination was **larger** than the binary at source. That seems weird. The next step strips the unnecessary architecture in the destination binary, and that should actually cause the size to go down. This is answered later.

<br>
## Strip unncessary architectures.

In case there are any unnecessary architectures present in the destination binary, strip them. Usually when building a cocoapod dependency from source, we would just build the relevant architecture and this step is redundant. One case where this is needed is when the cocoapods dependency is downloaded as a already-built framework.

```bash
# Strip non-valid architectures in-place
lipo -remove "$arch" -output "$binary" "$binary"
```

<br>
## Code sign!

Apple needs you to code sign anything you are installing on an actual iPhone. The cocoapods framework is no exception. This is not needed when running/building on a simulator, but only needed when installing on an iPhone.

There is an interesting variable here - `COCOAPODS_PARALLEL_CODE_SIGN`. If this is enabled, the codesign commands for the various frameworks is executed parallely in background (using `&`). A useful thing to enable for shaving off a few seconds.

Coming back to the earlier question of why destination binary saw a size increase--it was because of the code signing step, which embeds the digital signatures (and some other info) to the binary itself.
