# AmazingCache
A simple and lightweight framework to fetch data and cache resources.


## Features 
- Ideal for async image loading, but can also be used to improve the access of other types of Data parseable resources as Strings and JSON. 
- Uses the concept of Least Recently Used (LRU) information to decide with information should be persisted.
- Thread safe. Do not block the user interface during networking operations.
- URLSession and Apple's Frameworks only. No other dependencies. 
- Size constrained by limiting the number of objects that can be stored.
- Aware of the OSs memory consumption. It automatically purges some data on low memory scenarios.
- Covered by a bunch of unit tests.


## Companion Sample App
![iPhone](https://github.com/brbsBruno/AmazingCache/blob/master/AmazingCacheSample/Screenshots/iPhone.png)
- Showcase the use of the AmazingCache API.
- Has an image grid presentation style.
- Loads some images from a parsed JSON Object.
- Implemented with the premises of the MVVM Architecture.
- Infinite Collection View that loads more data as the user navigate.
- Pull to refresh action reloads all presentation data.
