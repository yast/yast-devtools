## Yast Development Tools

[![Workflow Status](https://github.com/yast/yast-devtools/workflows/CI/badge.svg?branch=master)](
https://github.com/yast/yast-devtools/actions?query=branch%3Amaster)
[![OBS](https://github.com/yast/yast-devtools/actions/workflows/submit.yml/badge.svg)](https://github.com/yast/yast-devtools/actions/workflows/submit.yml)

## Directory Structure

### [ytools](ytools)

The main set of YaST Tools that help with developing modules.
Examples: log viewer, generators, checkers.

### [build-tools](build-tools)

Tools related to building an RPM package.
They are needed only as a dependency for package building. They go into a
separate RPM sub-package to reduce build-time dependencies.
They are not expected to be directly used by developers.

### [mass-tools](mass-tools)

Tools that help with mass changes to all YaST repositories
living in the [YaST organization](https://github.com/yast/).
Examples: check out all modules, make a maintenance branch,
or run a script for all of them.

### [doc-tools](doc-tools)

Tools used to generate
the [YaST documentation](http://doc.opensuse.org/#yast-doc).
They are partly obsolete and are kept to be used as a base for a new
documentation tool.
They make sense only for a developer who is interested in generating
new documentation.

### [obs-tools](obs-tools)

Tools used to manipulate with YaST repositories at [open build service](http://build.opensuse.org/).
They make sense only for a developer with permissions to target repositories.
