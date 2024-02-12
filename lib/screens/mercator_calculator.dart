import 'package:flutter/material.dart';
import 'package:rtk_receiver/functions/transform.dart' as transformations;
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtk_receiver/providers/providers_general.dart';

class MercatorCalculator extends ConsumerStatefulWidget {
  const MercatorCalculator({super.key});

  @override
  ConsumerState<MercatorCalculator> createState() {
    return _MercatorCalculatorState();
  }
}

class _MercatorCalculatorState extends ConsumerState<MercatorCalculator> {
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  double? enteredLatitude;
  double? enteredLongitude;
  bool latitudeIsInvalid = true;
  bool longitudeIsInvalid = true;
  int selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      ref.read(selectedPageIndexProvider.notifier).state = index;
      //selectedPageIndexChecking = ref.watch(selectedPageIndexProvider);
      //print("The updated index is $selectedPageIndexChecking");
      //print("the updated index should be $index");
    });
  }

  Widget convertLatLong2Meters() {
    if (latitudeIsInvalid || longitudeIsInvalid) {
      return Row(
        children: [
          Expanded(
            child: Text(
              "No value received",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text("No value received",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
        ],
      );
    } else {
      proj4.Point transformedCoordinates = transformations.mercatorForward(
          latitude: enteredLatitude!, longitude: enteredLongitude!);

      return Row(
        children: [
          Expanded(
            child: Text(
              "X: ${double.parse((transformedCoordinates.x).toStringAsFixed(2))} m",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
                "Y: ${double.parse((transformedCoordinates.y).toStringAsFixed(2))} m",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _latitudeController.dispose();
    _longitudeController
        .dispose(); //* Always dispose the controller after using it
    super.dispose();
  }

  //void _selectPage(int index) {
  //  setState(() {
  //    _selectedPageIndex = index;
  //  });
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lat & Lon to Meters'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  controller: _latitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "°",
                    label: Text("Latitude"),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: TextField(
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                  controller: _longitudeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "°",
                    label: Text("Longitude"),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 80),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  enteredLatitude = double.tryParse(_latitudeController.text);
                  enteredLongitude = double.tryParse(_longitudeController.text);
                  latitudeIsInvalid =
                      (enteredLatitude == null || enteredLatitude! <= 0);
                  longitudeIsInvalid =
                      (enteredLongitude == null || enteredLongitude! <= 0);
                });
              },
              child: const Text("Convert")),
          const SizedBox(height: 80),
          convertLatLong2Meters(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'Latitude-Longitude'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_searching), label: 'Mercator')
        ],
      ),
    );
  }
}
