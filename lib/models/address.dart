import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'dart:io';

class Address {
  Address({required this.host, required this.topic});

  final String host;
  final String topic;

  var pongCount = 0;

  void _onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void _onDisconnected() {
    print("Disconnected from server");
  }

  void _onConnected() {
    print("Connected to server");
  }

  void beginConnection() async {
    MqttServerClient client = MqttServerClient(
        host, 'ricardoSuny9348j934jg98vn984utvnijr8j4t9nijvriofjenofij');
    client.setProtocolV311();
    client.keepAlivePeriod = 6000;
    client.connectTimeoutPeriod = 2000;
    client.onDisconnected =
        _onDisconnected; //* unsolicited disconnection callback
    client.onConnected = _onConnected; //* successfull connection callback
    client.onSubscribed = _onSubscribed; //* successfull subscription callback

    final connMess = MqttConnectMessage()
        .withClientIdentifier("ricardoSuny")
        .withWillTopic('willTopic')
        .withWillMessage('My will Message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('Mosquito client connecting.......');
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print("client exception - $e");
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquito client connected Successfuly');
    } else {
      print(
          'Error Mosquito client connection failed - disconnecting, status is ${client.connectionStatus}');
      client.disconnect();
      exit(-1);
    }

    print('Subscribing to $topic ');
    client.subscribe(topic, MqttQos.atLeastOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final recMess = c[0].payload as MqttPublishMessage;
      final pt =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

      print(
          'Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
    print('EXAMPLE::Sleeping....');
    await MqttUtilities.asyncSleep(60);
    print("Finished the code");
  }
}
