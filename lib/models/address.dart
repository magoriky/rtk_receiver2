//import 'package:mqtt_client/mqtt_client.dart';
//import 'package:mqtt_client/mqtt_server_client.dart';

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

  void connectToMqtt() {
    print('setter is working');
  }
}
