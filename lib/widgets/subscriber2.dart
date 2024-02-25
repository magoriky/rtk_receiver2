import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:rtk_receiver/models/position.dart';

class Subscriber2 extends StatefulWidget {
  const Subscriber2({super.key});

  @override
  State<Subscriber2> createState() {
    return _Subscriber2State();
  }
}

class _Subscriber2State extends State<Subscriber2> {
  final _hostController = TextEditingController();
  final _topicController = TextEditingController();
  late MqttServerClient client;
  bool displayIndicator = false;

  @override
  void dispose() {
    _hostController.dispose();
    _topicController.dispose();
    //* Always dispose the controller after using it
    super.dispose();
  }

  void _onPressedConnection() {
    setState(() {
      if (displayIndicator == false) {
        displayIndicator = true;
      } else {
        displayIndicator = false;
        client.disconnect();
      }
    });
  }

  Future<Widget> mqttScreen() async {
    client = MqttServerClient("118.40.176.90", "RicardoMeicLab");
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      print("client exception - $e");
    }

    client.subscribe("/agip2/gcm/gnss/DC-A6-32-FF-69-98", MqttQos.atLeastOnce);
    return StreamBuilder<List<MqttReceivedMessage<MqttMessage>>>(
        stream: client.updates,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }
          final updates = snapshot.data!;
          final latestUpdate = updates[0].payload as MqttPublishMessage;
          final pt = MqttPublishPayload.bytesToStringAsString(
              latestUpdate.payload.message);
          Position position = Position(message: pt);
          List<double> receivedCoordinates = position.getCoordinates();
          return Center(
              child: Text(
            "The pairLatLng is: $receivedCoordinates",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ));
        });
  }

  Future<Widget> waitingScreen() async {
    return Text(
      "Waiting to Connect",
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<Widget> display = waitingScreen();
    if (displayIndicator) {
      display = mqttScreen();
    }

    String buttonText = "Connect";
    if (displayIndicator) {
      buttonText = "Disconnect";
    }
    //print("Selected display is :$displayIndicator");
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
              onPressed: _onPressedConnection,
              child: Text(
                buttonText,
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
          ]),
          const SizedBox(
            height: 40,
          ),
          FutureBuilder<Widget>(
            future: display,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Return a placeholder or loading indicator while waiting for the future
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                // Handle error state
                return Text('Error: ${snapshot.error}');
              } else {
                // Once the future completes, return the widget you want to display
                return snapshot.data ??
                    Container(); // Return your widget, or an empty container if null
              }
            },
          )
        ],
      ),
    );
  }
}
