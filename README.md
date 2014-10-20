## Yast Development Tools

Travis: [![Build Status](https://travis-ci.org/yast/yast-devtools.png?branch=master)](https://travis-ci.org/yast/yast-devtools)
Jenkins: [![Jenkins Build](http://img.shields.io/jenkins/s/https/ci.opensuse.org/yast-devtools-master.svg)](https://ci.opensuse.org/view/Yast/job/yast-devtools-master/)


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
