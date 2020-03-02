## Issue Formatting

Title: `{AreaOfAffect}-{Number}: {Main Goal of Issue}`

Body:
```
## Problem
<!-- Issue Description Here -->
## Solution
<!-- General Solution/ Starting Point-->
## Glo Boards 
<!-- TODO: Remove Once Glo Board Action is added -->
https://app.gitkraken.com/glo/board/XYPMoM4GEQAPlDJt
```
**Note**: Either apply wip label or add WIP to the title.

Once ready for review @nexishunter.

## Areas of Affect
<!-- Adjust me Upon Closure of PRs-->
| Area          | Code | Current Number |
| :------------ | :--- | :------------- |
| Documentation & Refacters| DOC  | 4              |
| Testing       | T    | 2              |
| Performance   | PERF | 0              |
| UI            | UI   | 0              |

## Getting Setup

*Note*: This assumes that you're downloading flutter from [here](flutter.dev).
- Install flutter as per you're operating system.
- Change to channel flutter by running `flutter channel master`
- Run `flutter upgrade`
- Run `flutter config --enable-{your os here}-desktop` *Possible Os:* linux, macos, windows
- Run `flutter precache --{your os here}`

## Running Tests
With coverage, if you know how to/ are looking to process the info, note don't commit the lcov.info. To
achieve this run:

    `flutter test --coverage test/*_test.dart`

This runs all of the test suites, with coverage. To run specific tests run:

    `flutter test /path/to/test`