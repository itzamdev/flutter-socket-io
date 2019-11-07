import 'package:flutter/material.dart';
import 'dart:async';

import 'package:itzam_socket_io/itzam_socket_io.dart';

void main() => runApp(MyApp());

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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    //define query params
    final query = Map<String, dynamic>();
    query['token'] = "k123s_asks1221aksak";

    socketIO.on(SocketIO.defaultEvents.connect, (data) {
      setState(() {
        status = "connected to socketIO server";
      });
    });

    socketIO.on(SocketIO.defaultEvents.error, (data) {
      print("error ${data.toString()}");
      setState(() {
        status = "error ${data.toString()}";
      });
    });

    socketIO.on('on-notification', (data) {});

    socketIO.connect(host: "https://your-socket-io-host.com", query: query);
    //add listeners
    // next add your listeners with your event names
    //the eventNames "connect","disconnect" and "error" are added by default, you don't need to do socketIO.on("disconnect"), socketIO.on("connect"), socketIO.on("error");

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
  void dispose() {
    socketIO.disconnect();
    super.dispose();
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
