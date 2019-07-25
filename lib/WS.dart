import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show required;
import 'package:flutter/services.dart';



typedef void OnWS(String eventName, dynamic data);

// ignore: camel_case_types
class DEFAULT_EVENTS {
  static const connect = "connect";
  static const disconnect = "disconnect";
  static const reconnect = "reconnect";
  static const error = "error";
}

/// class to manage the socketIO connection
class SocketIO {
  final channel = MethodChannel('itzam_socket_io');
  OnWS onWS;

  /// listener to catch incomming events

  /// connect to socketIO host and you can pass [query] params as a Map
  /// [host] socket-io host
  /// [query] query params
  void connect({@required String host, Map<String, dynamic> query}) async {
    var queryParams = "?";
    var dynamicQuery = {};
    var index = 0;
    query.forEach((key, value) {
      queryParams +=
          "$key=${Uri.encodeFull(value.toString())}${index + 1 < query.length ? '&' : ''}";
      dynamicQuery[key] = value;
      index++;
    });

    await channel.invokeMethod("connect",
        {'host': host, 'query': dynamicQuery, "params": queryParams});

    // ignore: missing_return
    channel.setMethodCallHandler((call) {
      if (call.method == 'incoming') {
        final String eventName = call.arguments['eventName'];
        final data = call.arguments['data'];

        if (Platform.isIOS) {
          onWS(eventName, data);
        } else {
          try {
            final jsonObject = jsonDecode(data);
            onWS(eventName, jsonObject);
          } catch (e) {
            onWS(eventName, data);
          }
        }
      }
    });
  }

  /// disconnect from socketIO server
  void disconnect() async {
    await channel.invokeMethod("disconnect");
  }

  /// add on even listener
  /// [eventName] String
  on(String eventName) async {
    await channel.invokeMethod("on", {"eventName": eventName});
  }

  /// send data to your socketIO server
  emit({@required String eventName, @required dynamic data}) async {
    await channel.invokeMethod("emit", {"eventName": eventName, "data": data});
  }
}
