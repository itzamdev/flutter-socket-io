# flutter_socket_io

A new Flutter plugin to connect with Socket-IO server.

see the example for more info.


# for android and kotlin projects in your android/build.gradle use kotlin 1.3.10 or later
```
buildscript {
   ext.kotlin_version = '1.3.10'
}
```


## **Important** 
The plugin is written in `Swift`, so your project needs to have Swift support enabled. If you've created the project using `flutter create -i swift [projectName]` you are all set. If not, you can enable Swift support by opening the project with XCode, then choose `File -> New -> File -> Swift File`. XCode will ask you if you wish to create Bridging Header, click yes.
