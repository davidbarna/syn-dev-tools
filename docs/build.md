# Building cordova apps

## Setting up cordova app

### Install cordova globally
All steps described where tests with cordova@6
```
$ npm install -g cordova

```

### Create your cordova app

> cordova create {path} {app id} {app name}


#### Example
```
$ cd /my/project/folder
$ cordova create app com.mycompany.myteam.myapp MyAppName

```

We highly recommend to create your cordova app in the /app sub folder of the project

#### You should add generated files to you .gitignore

Add to your gitignore files you don't want:
```
/app/www
/app/platforms/
```

### Add platforms you need

> cordova platform add {platform name}

```
$ cd /my/project/folder/app
$ cordova platform add android ios browser --save

```

For now, dev-tools only works on the following platforms:
* android
* ios
* browser


#### android
If you install the android platform, you will to do the following:
1. Create /certificates in your cordova app folder
For android, create /certificates folder
2. Install android sdk. It will be used to compile apk files


### CrossWalk
We highly recommend to install the
[XWalk Plugin](https://www.npmjs.com/package/cordova-plugin-crosswalk-webview/).

```
$ cordova plugin add cordova-plugin-crosswalk-webview

```
It improves the performance mostly in android platform.
If you install it, make sure the multiple apk option is disabled in app/config.xml:
```
<preference name="xwalkMultipleApk" value="false"/>
```

## Building cordova app
As easy as a command.
```
$ gulp build --env development
```
