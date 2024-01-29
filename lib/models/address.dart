import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Address {
  const Address(
      {required this.host,
      required this.partialaddress,
      required this.finaladdress});

  const Address.widthdefault(
      {this.host = "118.40.176.90",
      this.partialaddress = "/aigp2/gcm/gnss/",
      required this.finaladdress});

  final String host;
  final String partialaddress;
  final String finaladdress;

  void connectToMqtt() async {
    //print('setter is working');
    String willTopic = partialaddress + finaladdress;
    final MqttServerClient client = MqttServerClient(host, 'suny');
    final MqttConnectMessage connectMessage = MqttConnectMessage()
        .withClientIdentifier('suny')
        .startClean() // Start a clean session
        .withWillQos(MqttQos.atLeastOnce)
        .withWillTopic(willTopic)
        .withWillMessage('Connection closed unexpectedly')
        .withWillRetain()
        .authenticateAs('Suny', '1111');

    client.connectionMessage = connectMessage;
    // Connect to the broker
    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }
    // Subscribe to a topic

    client.subscribe(willTopic, MqttQos.atLeastOnce);

    // Listen for incoming messages
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage message = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      print("I received a message");

      print('Received message: $payload from topic: ${c[0].topic}');
    });

    // Disconnect from the broker when done
    print("I will wait 60 seconds");
    await Future.delayed(
        const Duration(seconds: 60)); // Wait for some time before disconnecting
    client.disconnect();
    print("I finished waiting and I am disconnecting");
  }
}
