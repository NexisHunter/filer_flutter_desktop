# Filer  [![Coverage Status](https://coveralls.io/repos/github/NexisHunter/filer_flutter_desktop/badge.svg?branch=master)](https://coveralls.io/github/NexisHunter/filer_flutter_desktop?branch=master) ![CI](https://github.com/NexisHunter/filer_flutter_desktop/workflows/CI/badge.svg)

## Introduction

[Flutter](http://flutter.dev) is Google's cross platform UI language that uses the [Dart](http://dart.dev)
language as the backend. Due to the nature of Flutter it allows for a generally platform agnostic  
application that is concise across platforms. You are also able to use it to develop Desktop  
applications.

## Goal

The goal is to make a cross platform file manager written in Flutter. This is to allow a consistent look and feel across devices. Originally this was designed with the [Android-x86]() platform in mind but due to the nature of Flutter it allows for a broader audience to be targeted.
<!-- 
To make a file manager for the Android-x86 platform that is a bit more user-friendly as there are  
some differences between the Android Os and the port. (In the realm of user interaction that is).
-->
## Development Progress

- [ ] Settings Menu
  - [x] Themeing
    - [x] View Preferences
    - [x] Show Hidden
    - [ ] Font Size
    - [x] Scale
    - [x] Show Extensions
- [x] Favourite Menu
  - [x] Base Layout
  - [X] Load Given Directory
  - [x] Add Favourite
  - [x] Remove Favourite
- [ ] Device list
  - [x] Base layout
  - [x] Load Given Directory
  - [x] Load all devices
  - [ ] Eject Functionality
  - [ ] Mount Functionality
- [ ] Files list
  - Layouts
    - [ ] Compact View
    - [X] Icon View
    - [ ] COmfortable View
    - [ ] tab/simultaneous directory viewing
  - [X] List all files (in a given directory)
  - [X] Icon based on mime-type
  - [ ] Opens app based on mime-type
  - [ ] Add Context Menu
    - [x] Add File
    - [x] Remove File
    - [ ] Copy File
    - [X] Rename File
    - [x] Create File
- [x] Data Persistence
  - [x] User preferences
  - [x] User Favourites
  - [ ] Firebase *Possibly*

## Testing Progress

- [ ] Unit Tests
  - [ ] Favourites Menu
    - [X] State
    - [ ] Base Layout
    - [ ] Add Favourite
    - [ ] Remove Favourite
  - [ ] Device List
    - [X] State
    - [ ] Base Layout
    - [ ] Eject
    - [ ] Mount
  - [ ] Files List
    - [ ] State
    - [ ] Base Layout
    - [ ] List all files (in a given directory)
    - [ ] Icon based on mime-type
    - [ ] Opens app based on mime-type
    - [ ] tab/simultaneous directory viewing

## TODOS

- [ ] TESTS *Highest Priority*
- [ ] Finish Settings
  - [ ] Font Size
- [ ] Finish Device List
  - [ ] Mount / Eject
- [ ] Finish Files View Context functions
  - [ ] Copy
- [ ] Allow for auto rotation
- [ ] Files List
  - [ ] Open based on mimetype *Need a package compatible with AndroidX sdk*
  - [ ] Tab interface *framework needed*
