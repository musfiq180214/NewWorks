import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:amar_shoday/core/routes/route_names.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String? district;
  String? thana;
  String? area;

  final districts = [
    "Dhaka",
    "Chittagong",
    "Khulna",
    "Rajshahi",
    "Barishal",
    "Sylhet"
  ];
  final thanas = ["Thana 1", "Thana 2"];
  final areas = ["Bosila city housing", "Area 2"];

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.locale;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            const Text(
              "Selected Language",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                ChoiceChip(
                  label: const Text("Eng"),
                  selected: currentLocale == const Locale('en', 'US'),
                  onSelected: (_) =>
                      context.setLocale(const Locale('en', 'US')),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text("বাংলা"),
                  selected: currentLocale == const Locale('bn', 'BD'),
                  onSelected: (_) =>
                      context.setLocale(const Locale('bn', 'BD')),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "We are currently operating in selected areas only. Please let us know your area if it is not already in the list",
              ),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select District",
                border: OutlineInputBorder(),
              ),
              value: district,
              onChanged: (v) => setState(() => district = v),
              items: districts
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Thana",
                border: OutlineInputBorder(),
              ),
              value: thana,
              onChanged: (v) => setState(() => thana = v),
              items: thanas
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: "Select Area",
                border: OutlineInputBorder(),
              ),
              value: area,
              onChanged: (v) => setState(() => area = v),
              items: areas
                  .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 13)),
            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, RouteNames.suggestArea),
                  child: const Text(
                    "Let us know",
                    style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      if (district == null || thana == null || area == null) {
                        setState(() {
                          errorMessage =
                              "Please select all fields before continuing.";
                        });
                        return;
                      }
                      Navigator.pushReplacementNamed(
                          context, RouteNames.suggestArea);
                    },
                    child: const Text("Next"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
