import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:xml/xml.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: KMLMapScreen(),
    );
  }
}

class KMLMapScreen extends StatefulWidget {
  const KMLMapScreen({super.key});

  @override
  State<KMLMapScreen> createState() => _KMLMapScreenState();
}

class _KMLMapScreenState extends State<KMLMapScreen> {
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _loadKML();
  }

  Future<void> _loadKML() async {
    final kmlString = await rootBundle.loadString('assets/sample.kml');
    final document = XmlDocument.parse(kmlString);

    // Load Placemark Points as Markers
    final placemarks = document.findAllElements('Placemark');
    for (var placemark in placemarks) {
      final point = placemark.findElements('Point').firstOrNull;
      if (point != null) {
        final coord = point
            .findElements('coordinates')
            .first
            .text
            .trim()
            .split(',');
        final lat = double.parse(coord[1]);
        final lng = double.parse(coord[0]);

        _markers.add(Marker(
          markerId: MarkerId(placemark.findElements('name').first.text),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: placemark.findElements('name').first.text),
        ));
      }

      // Load LineString as Polyline
      final line = placemark.findElements('LineString').firstOrNull;
      if (line != null) {
        final coords = line
            .findElements('coordinates')
            .first
            .text
            .trim()
            .split(RegExp(r'\s+'))
            .map((c) {
          final parts = c.split(',');
          return LatLng(double.parse(parts[1]), double.parse(parts[0]));
        }).toList();

        _polylines.add(Polyline(
          polylineId: PolylineId(placemark.findElements('name').first.text),
          points: coords,
          color: Colors.blue,
          width: 4,
        ));
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter KML Demo')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(37.422, -122.082),
          zoom: 15,
        ),
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}

extension FirstOrNullExtension<E> on Iterable<E> {
  E? get firstOrNull => isEmpty ? null : first;
}
