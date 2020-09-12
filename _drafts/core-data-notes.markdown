---
layout: post
title:  "Core Data notes"
subtitle: 
date: 2020-08-25 15:49:24 +0530
tags: engineering ios
category: engineering
---

![Core data conceptual layout](/assets/images/core-data-stack.png)

## NSManagedObjectContext
An object space containing multiple NSManagedObjects. It's a layer over a parent context (which is either a persistence store coordinator or another managed object context). It manages the lifecycle of NSManagedObjects within it (save/rollback/fetch etc.) Any save or fetch happens from the parent context.  
It uses thread confinement (belongs to the thread which init'ed it), and therefore should not be passed around in threads. Instead pass the persistence controller and create a new MOC in the new thread.

## NSPersistenceContainer
Encapsulates the core data stack. One stop solution to create the core data stack components - persistence coordinator, managed object model, managed object context.

## NSManagedObjectModel
A programmatic representation of .xcdatamodeld file describing your objects. Contains several NSENtityDesciption objects representing the entities of the schema.

## NSEntityDescription
A schema for a managed object (to use a database analogy, what tables are to rows, an entity description is to managed object)

