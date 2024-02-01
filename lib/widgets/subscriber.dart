import 'package:flutter/material.dart';
import 'package:rtk_receiver/models/address.dart';
//import 'package:rtk_receiver/data/list_of_mqtt_data.dart';

class Subscriber extends StatefulWidget {
  const Subscriber({super.key});

  @override
  State<Subscriber> createState() {
    return _SubscriberState();
  }
}

class _SubscriberState extends State<Subscriber> {
  void _running() {
    Address address2 =
        Address(host: "test.mosquitto.org", topic: "/ricardo/probando/hello");

    address2.beginConnection();

    //const Address address = Address.widthdefault(finaladdress: 'nmea/DC-A6-32-FF-68-E1');
    //address.connectToMqtt();
    //Address address = availableAddresses[0];
    //address.connectToMqtt();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Screen",
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
        ),
        const SizedBox(
          height: 14,
        ),
        ElevatedButton(
          onPressed: _running,
          child: Text(
            "Connect",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        )
      ],
    );
  }
}
