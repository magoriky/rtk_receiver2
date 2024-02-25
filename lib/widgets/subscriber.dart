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
  final _hostController = TextEditingController();
  final _topicController = TextEditingController();
  double? recivedLat;
  double? recivedLon;

  void _running() {
    //Address address2 =
    //Address(host: "test.mosquitto.org", topic: "/ricardo/probando/hello");
    Address address2 = Address(
        host: "118.40.176.90", topic: "/agip2/gcm/gnss/DC-A6-32-FF-69-7A");
//
    address2.beginConnection();

    //const Address address = Address.widthdefault(finaladdress: 'nmea/DC-A6-32-FF-68-E1');
    //address.connectToMqtt();
    //Address address = availableAddresses[0];
    //address.connectToMqtt();
  }

  @override
  void dispose() {
    _hostController.dispose();
    _topicController.dispose();
    //* Always dispose the controller after using it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                controller: _hostController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    prefixText: "host: ", label: Text("Host")),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: TextField(
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
                controller: _topicController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    prefixText: "Topic: ", label: Text("Topic")),
              ),
            ),
          ]),
          const SizedBox(
            height: 100,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: _running,
              child: Text(
                "Connect",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            const SizedBox(
              width: 50,
            ),
            ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Save Address",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ))
          ])
        ],
      ),
    );
  }
}
