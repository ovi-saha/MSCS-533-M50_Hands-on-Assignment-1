import 'package:flutter/material.dart';

void main() {
  runApp(UnitConverterApp()); // Entry point of the app
}

// Main app widget
class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Measures Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: UnitConverterScreen(),
      debugShowCheckedModeBanner: true,
    );
  }
}

// Stateful widget to manage user input and conversions
class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => UnitConverterScreenState();
}

class UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _controller = TextEditingController();
  String fromUnit = 'meters';
  String toUnit = 'feet';
  String result = '';

  // Units categorized
  final List<String> distanceUnits = [
    'meters',
    'kilometers',
    'miles',
    'feet',
    'centimeters',
  ];

  final List<String> weightUnits = [
    'kilograms',
    'grams',
    'pounds',
    'ounces',
  ];

  final Map<String, double> conversionRates = {
    // Distance in meters
    'meters': 1.0,
    'kilometers': 1000.0,
    'miles': 1609.34,
    'feet': 0.3048,
    'centimeters': 0.01,
    // Weight in kilograms
    'kilograms': 1.0,
    'grams': 0.001,
    'pounds': 0.453592,
    'ounces': 0.0283495,
  };

  // Check if units are in the same category
  bool sameCategory(String from, String to) {
    return (distanceUnits.contains(from) && distanceUnits.contains(to)) ||
        (weightUnits.contains(from) && weightUnits.contains(to));
  }

  // Perform conversion
  void convert() {
    double? inputValue = double.tryParse(_controller.text);
    if (inputValue == null) return;

    if (!sameCategory(fromUnit, toUnit)) {
      setState(() {
        result = 'Cannot convert $fromUnit to $toUnit';
      });
      return;
    }

    double valueInBase = inputValue * conversionRates[fromUnit]!;
    double convertedValue = valueInBase / conversionRates[toUnit]!;

    setState(() {
      result =
          '${inputValue.toStringAsFixed(2)} $fromUnit are ${convertedValue.toStringAsFixed(3)} $toUnit';
    });
  }

  // Build dropdown items with prominent headers
  List<DropdownMenuItem<String>> buildDropdownItems() {
    List<DropdownMenuItem<String>> items = [];

    // Distance header
    items.add(DropdownMenuItem<String>(
      value: null,
      enabled: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '--- Distance ---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
      ), // non-selectable
    ));

    // Distance units
    items.addAll(distanceUnits.map((u) => DropdownMenuItem<String>(
          value: u,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(u, style: TextStyle(fontSize: 14, color:const Color.fromARGB(255, 20, 70, 158))),
          ),
        )));

    // Weight header
    items.add(DropdownMenuItem<String>(
      value: null,
      enabled: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          '--- Weight ---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
            fontSize: 16,
          ),
        ),
      ), // non-selectable
    ));

    // Weight units
    items.addAll(weightUnits.map((u) => DropdownMenuItem<String>(
          value: u,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(u, style: TextStyle(fontSize: 14, color: const Color.fromARGB(255, 20, 70, 158))),
          ),
        )));

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Measures Converter', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Value Input
            Center(
              child: Column(
                children: [
                  Text('Value',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 101, 98, 98))),
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Color.fromARGB(255, 20, 70, 158)),
                    cursorColor: Colors.blue,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue, width: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // From Dropdown
            Center(
              child: Column(
                children: [
                  Text('From',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 101, 98, 98))),
                  DropdownButton<String>(
                    value: fromUnit,
                    isExpanded: true,
                    items: buildDropdownItems(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          fromUnit = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // To Dropdown
            Center(
              child: Column(
                children: [
                  Text('To',
                      style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 101, 98, 98))),
                  DropdownButton<String>(
                    value: toUnit,
                    isExpanded: true,
                    items: buildDropdownItems(),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          toUnit = newValue;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Convert Button
            Center(
              child: ElevatedButton(
                onPressed: convert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[300],
                  foregroundColor: Color.fromARGB(255, 20, 70, 158),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                ),
                child: Text('Convert',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20),

            // Result Display
            Text(result,
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 101, 98, 98))),
          ],
        ),
      ),
    );
  }
}
