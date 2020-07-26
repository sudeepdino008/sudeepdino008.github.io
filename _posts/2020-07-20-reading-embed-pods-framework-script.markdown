---
layout: post
title:  "Reading 'Embed Pods Framework' script"
subtitle: 
date:   2020-07-20 15:49:24 +0530
tags: iOS cocoapods engineering
category: engineering
---

Cocoapods - A dependency manager for Swift/Objc projects is a resounding name in the world of iOS development. On doing a `pod install`, a new build phase called 'Embed Pods Framework' is added to your project (among other things).

This build phase executes a script - **Pods-\<AppName\>-frameworks.sh**. I opened it up and started reading it. It's a small script, and what follows is a few nuggets I picked.

![Here's the script I'm talking about in Xcode build phase](/assets/images/20-07-2020/script_location.png)

"Installing" the dependency frameworks is the crux of what the script does. By this stage, the dependencies (`.framework` files) have already been built in `${BUILT_PRODUCTS_DIR}` directory (called "source").
  
<br>
## Copying the framework 

The built framework is copied from the source to the destination folder (so that it can get bundled together with the app).

```bash
# sample source
${BUILT_PRODUCTS_DIR}/XCGLogger/XCGLogger.framework/

# sample destination
${BUILT_PRODUCTS_DIR}/ExperimentalApp.app/Frameworks/ObjcExceptionBridging.framework/
```

Ever wondered how to efficiently copy a big file to a different location? Maybe using diffs, just the way `git` does?  
That's exactly what the `rsync` command does here - It transfers the framework binary and other framework files to the destination. It is used rather than traditional `cp`, since it can detect deltas in the binary and transfer only the diff information to the destination. This ends up being way faster for larger binaries. 

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


__Question__: I noticed that the framework binary at destination was **larger** than the binary at source. That seems weird. The next step strips the unnecessary architecture in the destination binary, and that should actually cause the size to go down. This is answered later.

<br>
## Strip unncessary architectures in destination binary

Usually when building a cocoapod dependency from source, we would just build the relevant architecture and this step is redundant. One case where this is needed is when the cocoapods dependency is downloaded as an already-built framework.

```bash
# Strip non-valid architectures in-place
lipo -remove "$arch" -output "$binary" "$binary"
```

<br>
## Code sign!

Apple needs you to code sign anything you are installing on an iPhone. The cocoapods framework is no exception. This is not needed when running/building on a simulator.

There is an interesting variable here - `COCOAPODS_PARALLEL_CODE_SIGN`. If this is enabled, the codesign commands for the various frameworks is executed parallely in background (using `&`). A useful thing to enable for shaving off a few seconds.

Coming back to the earlier question of why destination binary saw a size increase - it was because of the code signing step, which embeds the digital signatures (and some other info) to the binary itself.
