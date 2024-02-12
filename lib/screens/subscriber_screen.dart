import 'package:flutter/material.dart';
import 'package:rtk_receiver/widgets/subscriber.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtk_receiver/providers/providers_general.dart';

class SubscriberScreen extends ConsumerWidget {
  const SubscriberScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int selectedPageIndex = 2;
    void selectPage(int index) {
      ref.read(selectedPageIndexProvider.notifier).state =
          index; //* Allows modifiing the provider
      //selectedPageIndexChecking = ref.watch(selectedPageIndexProvider);
      //print("The updated index is $selectedPageIndexChecking");
      //print("the updated index should be $index");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mqtt subscriber"),
      ),
      body: const Subscriber(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
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
