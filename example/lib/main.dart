import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:itzam_socket_io/itzam_socket_io.dart';

void main() => runApp(MyApp());

class MY_SOCKET_EVENTS {
  static const onNotification = "on-notification";
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String status = 'null';

  final SocketIO socketIO = SocketIO();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // listeners for socketIo
  void onWS(String eventName, dynamic data) {
    // catch your event names listeners

    switch (eventName) {
      case DEFAULT_EVENTS.connect:
        print("connect");
        setState(() {
          status = "connected to socketIO server";
        });
        break;

      case DEFAULT_EVENTS
          .reconnect: // this is always called after the method  socketIO.disconnect()
        print("reconnect");
        setState(() {
          status = "begins the reconnection process";
        });
        break;

      case DEFAULT_EVENTS
          .disconnect: // this is always called after the method  socketIO.disconnect()
        print("disconnect");
        setState(() {
          status = "disconnected from socketIO server";
        });
        break;

      case DEFAULT_EVENTS
          .error: // this is always called after the method  socketIO.disconnect()
        print("error ${data.toString()}");
        setState(() {
          status = "error ${data.toString()}";
        });
        break;

      case MY_SOCKET_EVENTS.onNotification: // this is my own event listener
        print("on-notification with data ${data.toString()}");
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //define query params
    final query = Map<String, dynamic>();
    query['token'] = "k123s_asks1221aksak";
    socketIO.connect(host: "https://your-socket-io-host.com", query: query);
    //add listeners
    socketIO.onWS = this.onWS;
    // next add your listeners with your event names
    //the eventNames "connect","disconnect" and "error" are added by default, you don't need to do socketIO.on("disconnect"), socketIO.on("connect"), socketIO.on("error");
    socketIO.on(MY_SOCKET_EVENTS.onNotification); //

    // emit
//    socketIO.emit(eventName: "myLocation", data: {
//      "latitude": -12.32033,
//      "longitude": 74.012131
//    });

    //   socketIO.disconnect(); // disconnect from socketIO server



//    Timer(Duration(seconds: 5), () {
//      socketIO.disconnect();
//    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ITZAM Socket-io example'),
        ),
        body: Center(
          child: Text('$status\n'),
        ),
      ),
    );
  }
}
