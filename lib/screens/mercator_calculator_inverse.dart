import 'package:flutter/material.dart';
import 'package:rtk_receiver/functions/transform.dart' as transformations;
import 'package:proj4dart/proj4dart.dart' as proj4;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtk_receiver/providers/providers_general.dart';

class MercatorCalculatorInverse extends ConsumerStatefulWidget {
  const MercatorCalculatorInverse({super.key});

  @override
  ConsumerState<MercatorCalculatorInverse> createState() {
    return _MercatorCalculatorInverseState();
  }
}

class _MercatorCalculatorInverseState
    extends ConsumerState<MercatorCalculatorInverse> {
  final _northingController = TextEditingController();
  final _eastingController = TextEditingController();
  double? enterednorthing;
  double? enteredeasting;
  bool northingIsInvalid = true;
  bool eastingIsInvalid = true;

  int selectedPageIndex = 1;

  //void _selectPage(int index) {
  //  setState(() {
  //    ref.read(selectedPageIndexProvider.notifier).state = index;
  //    //selectedPageIndexChecking = ref.watch(selectedPageIndexProvider);
  //    //print("The updated index is $selectedPageIndexChecking");
  //    //print("the updated index should be $index");
  //  });
  //}
  void _selectPage(int index) {
    ref.read(selectedPageIndexProvider.notifier).state = index;
  }

  Widget convertLatLong2Meters() {
    if (northingIsInvalid || eastingIsInvalid) {
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
      proj4.Point transformedCoordinates = transformations.mercatorInverse(
          yNorthing: enterednorthing!, xEasting: enteredeasting!);

      return Row(
        children: [
          Expanded(
            child: Text(
              "Latitude: ${double.parse((transformedCoordinates.y).toStringAsFixed(2))} °",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Text(
                "Longitude: ${double.parse((transformedCoordinates.x).toStringAsFixed(2))} °",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground)),
          ),
        ],
      );
    }
  }

  @override
  void dispose() {
    _northingController.dispose();
    _eastingController
        .dispose(); //* Always dispose the controller after using it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meters to Lat & Lon'),
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
                  controller: _northingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "m",
                    label: Text("Northing"),
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
                  controller: _eastingController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixText: "m",
                    label: Text("Easting"),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 80),
          ElevatedButton(
              onPressed: () {
                setState(() {
                  enterednorthing = double.tryParse(_northingController.text);
                  enteredeasting = double.tryParse(_eastingController.text);
                  northingIsInvalid =
                      (enterednorthing == null || enterednorthing! <= 0);
                  eastingIsInvalid =
                      (enteredeasting == null || enteredeasting! <= 0);
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
              icon: Icon(Icons.location_searching), label: 'Mercator'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Connect to Mqtt'),
        ],
      ),
    );
  }
}
