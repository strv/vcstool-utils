![CI](https://github.com/strv/vcstool-utils/workflows/CI/badge.svg?branch=main&event=push)

# vcstool-utils

Utilities for using [vcstool](https://github.com/dirk-thomas/vcstool)

This repository is created by `strv`.
If you have a question about this repository, please notice in this repository.

## dependency

`vcstool`

Please install vcstool to use the scripts.

## import_all.sh

The script file to import repositories recursivly.
It is useful to resolve nested dependencies.

### Usage

```
Usage       : $0 [OPTIONS] DIR
DIR         : base directory to find repositories file

OPTIONS
  -s SUFFIX : Repositories file suffix. (default: .repos)

Example
  For ROS user
    $0 -s .rosintsall ~/catkin_ws/src
    Note: better to set "src" directory as a target
```
