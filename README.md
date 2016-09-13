# Developer Tools
Developer tools for soyun projects.
It provides gulp tasks with linters, tests execution and more.

## Getting started

Install the module
```javascript
$ npm install syn-dev-tools --save-dev
```

Create gulpfile.js with folowwing content
```javascript
/*
 * Gulpfile
 * Tasks are registered from dev-tools module.
 */
var devTools = require('syn-dev-tools').gulp
var manager = devTools.Manager.getInstance(require('gulp'))
manager.registerTasks()
```

Done ! You can use any of the gulp tasks

## Gulp tasks

### Main tasks

#### default
Compiles all files minified.
```
$ gulp
```

#### serve
Compiles all files and starts a web serve to serve them.
```
$ gulp serve
```

#### test
Executes all tests located in /test folder
```
$ gulp test
```

##### Unit tests

```
$ gulp test.unit
```
Unit tests are executed with karma, using the following frameworks:
* [jasmine](http://jasmine.github.io/)
* [sinon-chai](https://github.com/domenic/sinon-chai)

##### E2E tests
```
$ gulp test.e2e
```
> ** IMPORTANT **

> ** If you want to execute end-to-end tests, you must update webdriver to execute tests in chromeDriver.**
```
$ node_modules/.bin/webdriver-manager update
```

If you want to work on your end-to-end tests, you must compile the project manually.
So, for instance, you can run both commands y separate windows to make your tests
reexecute each time a file is modified
```
$ gulp serve --watch --no-minify
```
```
$ gulp test.e2e --watch
```

### Tasks' options
Gulp commands accept a set of options that can influence the behaviour of the tasks.

#### env
Sets the environment. Its value is passed as "env" to any compiled template.

Default: 'production'

#### debug
Sets debug mode in all tasks. It activates source maps, for instance.

> **Example:** execute tests with sourcemaps
```
$ gulp test --debug
```

#### lint
Enables/Disables all linters: coffeelint, scsslint, etc.
> **Example:** execute tests without linters
```
$ gulp test --no-lint
```

#### minify
Enables/Disables minification of js, css and html files.
> **Example:** compile app without minification (faster)
```
$ gulp --no-minify
```

#### watch
Makes any task to reload each time a file is edited
> **Example:** re-excute tests on any file change
```
$ gulp serve --watch
```


## Examples of use

### Add prefix to task names
```javascript
manager.registerTasks( '*', 'my-prefix-' );
```
```
$ gulp my-prefix-serve
```

## Cordova app compilation
[Find detailed info here!](docs/build.md)
