import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rtk_receiver/screens/mercator_calculator.dart';
import 'package:rtk_receiver/providers/providers_general.dart';
import 'package:rtk_receiver/screens/mercator_calculator_inverse.dart';
import 'package:rtk_receiver/screens/subscriber_screen.dart';

final theme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: const Color.fromARGB(255, 131, 57, 0),
  ),
  textTheme: GoogleFonts.latoTextTheme(),
);

void main() {
  runApp(const ProviderScope(
    child: App(),
  ));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() {
    return _AppState();
  }
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    Widget content = const MercatorCalculator();
    final selectedPageIndex = ref.watch(selectedPageIndexProvider);
    print("The selected page index is: $selectedPageIndex");
    if (selectedPageIndex == 1) {
      content = const MercatorCalculatorInverse();
    }
    if (selectedPageIndex == 2) {
      content = const SubscriberScreen();
    }

    return MaterialApp(
      theme: theme,
      home: content,
    );
    //home: const MercatorCalculatorInverse());
  }
}
