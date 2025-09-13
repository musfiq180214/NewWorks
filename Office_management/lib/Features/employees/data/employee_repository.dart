import 'package:office_management/Features/employees/domain/employee.dart';

import '../../../core/api_client.dart';
import '../../../core/constants.dart';
import '../../../utils/logger.dart';

// class EmployeeRepository {
//   final APIClient _api = APIClient();

//   Future<List<Employee>> fetchEmployees() async {
//     try {
//       final resp = await _api.get(EndPoints.employeeListPath);

//       logger.i('=== Employee List Raw Response ===');
//       logger.d(resp);

//       final data = resp['data'] ?? resp['employees'] ?? resp;

//       if (data is List) {
//         return data.map((e) => Employee.fromJson(e)).toList();
//       } else if (data is Map && data['items'] is List) {
//         return (data['items'] as List)
//             .map((e) => Employee.fromJson(e))
//             .toList();
//       } else {
//         throw Exception("Unable to parse employee list");
//       }
//     } catch (e) {
//       logger.e('Error fetching employees', error: e);
//       rethrow;
//     }
//   }
// }

class EmployeeRepository {
  Future<List<Employee>> fetchEmployees() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate network delay

    return [
      Employee(
        id: "1",
        name: "John Doe",
        designation: "Frontend Developer",
        email: "john.doe@example.com",
        phone: "+8801710000001",
        bloodGroup: "A+",
        isDonor: true,
      ),
      Employee(
        id: "2",
        name: "Jane Smith",
        designation: "Backend Developer",
        email: "jane.smith@example.com",
        phone: "+8801710000002",
        bloodGroup: "B+",
        isDonor: false,
      ),
      Employee(
        id: "3",
        name: "Michael Johnson",
        designation: "Flutter Developer",
        email: "michael.j@example.com",
        phone: "+8801710000003",
        bloodGroup: "O+",
        isDonor: true,
      ),
      Employee(
        id: "4",
        name: "Emily Davis",
        designation: "UI/UX Designer",
        email: "emily.d@example.com",
        phone: "+8801710000004",
        bloodGroup: "AB+",
        isDonor: false,
      ),
      Employee(
        id: "5",
        name: "Chris Brown",
        designation: "Project Manager",
        email: "chris.b@example.com",
        phone: "+8801710000005",
        bloodGroup: "B-",
        isDonor: true,
      ),
      Employee(
        id: "6",
        name: "Sophia Wilson",
        designation: "QA Engineer",
        email: "sophia.w@example.com",
        phone: "+8801710000006",
        bloodGroup: "A-",
        isDonor: false,
      ),
      Employee(
        id: "7",
        name: "David Miller",
        designation: "HR Manager",
        email: "david.m@example.com",
        phone: "+8801710000007",
        bloodGroup: "O-",
        isDonor: true,
      ),
      Employee(
        id: "8",
        name: "Olivia Martinez",
        designation: "Business Analyst",
        email: "olivia.m@example.com",
        phone: "+8801710000008",
        bloodGroup: "AB-",
        isDonor: false,
      ),
      Employee(
        id: "9",
        name: "James Anderson",
        designation: "DevOps Engineer",
        email: "james.a@example.com",
        phone: "+8801710000009",
        bloodGroup: "A+",
        isDonor: true,
      ),
      Employee(
        id: "10",
        name: "Emma Thomas",
        designation: "Product Owner",
        email: "emma.t@example.com",
        phone: "+8801710000010",
        bloodGroup: "B+",
        isDonor: false,
      ),
    ];
  }
}
