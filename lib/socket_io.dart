import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show required;
import 'package:flutter/services.dart';

typedef void On(dynamic data);

// ignore: camel_case_types

class SocketIODefaultEvents {
  final connect = "connect";
  final disconnect = "disconnect";
  final reconnect = "reconnect";
  final error = "error";
}

/// class to manage the socketIO connection
class SocketIO {
  final channel = MethodChannel('itzam_socket_io');
  static final defaultEvents = SocketIODefaultEvents();

  Map<String, On> _events = Map();

  SocketIO() {
    // ignore: missing_return
    channel.setMethodCallHandler((call) {
      if (call.method == 'incoming') {
        final String eventName = call.arguments['eventName'];
        final data = call.arguments['data'];
        print("incomming eventName: $eventName");
        final event = _events[eventName];

        if (data == null) {
          event(null);
          return;
        }

        if (Platform.isIOS) {
          event(data);
        } else {
          try {
            final jsonObject = jsonDecode(data);
            event(jsonObject);
          } catch (e) {
            event(data);
          }
        }
      }
    });
  }

  /// listener to catch incomming events

  /// connect to socketIO host and you can pass [query] params as a Map
  /// [host] socket-io host
  /// [query] query params
  void connect({@required String host, Map<String, dynamic> query}) async {
    var queryParams = "";
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
  }

  /// disconnect from socketIO server
  void disconnect() async {
    await channel.invokeMethod("disconnect");
  }

  /// add on even listener
  /// [eventName] String
  Future<void> on(String eventName, Function(dynamic) callback) async {
    if (eventName != defaultEvents.error &&
        eventName != defaultEvents.connect &&
        eventName != defaultEvents.reconnect &&
        eventName != defaultEvents.disconnect) {
      print("assigned: $eventName");
      await channel.invokeMethod("on", {"eventName": eventName});
    }
    _events[eventName] = callback;
  }

  /// send data to your socketIO server
  emit({@required String eventName, @required dynamic data}) async {
    await channel.invokeMethod("emit", {"eventName": eventName, "data": data});
  }
}
