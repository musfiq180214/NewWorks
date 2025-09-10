import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controllers/attendance_controller.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    // fetch
    Future.microtask(
      () => ref.read(attendanceControllerProvider.notifier).fetchAttendances(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(attendanceControllerProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Attendances')),
      body: state.loading
          ? Center(child: CircularProgressIndicator())
          : state.error != null
          ? Center(child: Text('Error: ${state.error}'))
          : ListView.builder(
              itemCount: state.items.length,
              itemBuilder: (_, i) {
                final a = state.items[i];
                return ListTile(title: Text(a.date), subtitle: Text(a.status));
              },
            ),
    );
  }
}
