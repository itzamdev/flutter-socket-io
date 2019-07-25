import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:itzam_socket_io/itzam_socket_io.dart';

void main() {
  const MethodChannel channel = MethodChannel('itzam_socket_io');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {

  });
}
