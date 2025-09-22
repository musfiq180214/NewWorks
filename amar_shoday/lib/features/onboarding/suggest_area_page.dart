// suggest_area_page.dart
import 'package:amar_shoday/core/routes/route_names.dart';
import 'package:flutter/material.dart';

class SuggestAreaPage extends StatefulWidget {
  const SuggestAreaPage({super.key});

  @override
  State<SuggestAreaPage> createState() => _SuggestAreaPageState();
}

class _SuggestAreaPageState extends State<SuggestAreaPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, phone, district, thana, age, occupation, email, areYou;

  final districts = [
    "Dhaka",
    "Chittagong",
    "Khulna",
    "Rajshahi",
    "Barishal",
    "Sylhet"
  ];
  final thanas = ["Thana 1", "Thana 2"];
  final ages = ["18-25", "26-35", "36-50", "50+"];
  final roles = ["Student", "Professional", "Other"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suggest Area")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // form fields in colored container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Name*"),
                      onSaved: (v) => name = v,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Phone Number*"),
                      keyboardType: TextInputType.phone,
                      onSaved: (v) => phone = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: "Select District*"),
                      items: districts
                          .map(
                              (d) => DropdownMenuItem(value: d, child: Text(d)))
                          .toList(),
                      onChanged: (v) => district = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: "Select Thana*"),
                      items: thanas
                          .map(
                              (t) => DropdownMenuItem(value: t, child: Text(t)))
                          .toList(),
                      onChanged: (v) => thana = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Age"),
                      items: ages
                          .map(
                              (a) => DropdownMenuItem(value: a, child: Text(a)))
                          .toList(),
                      onChanged: (v) => age = v,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: "Occupation"),
                      onSaved: (v) => occupation = v,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Email ID"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (v) => email = v,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: "Are you a*"),
                      items: roles
                          .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => areYou = v,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // button outside the colored container
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  onPressed: () {
                    _formKey.currentState?.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Successfully LoggedIn")),
                    );
                    Navigator.pushReplacementNamed(
                        context, RouteNames.landing2);
                  },
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
