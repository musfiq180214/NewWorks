import 'package:office_management/Features/employees/domain/employee.dart';

// import '../../../core/api_client.dart';
// import '../../../core/constants.dart';
// import '../../../utils/logger.dart';

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

      // 11–20
      Employee(
        id: "11",
        name: "Liam Harris",
        designation: "Frontend Developer",
        email: "liam.h@example.com",
        phone: "+8801710000011",
        bloodGroup: "O+",
        isDonor: true,
      ),
      Employee(
        id: "12",
        name: "Mia Clark",
        designation: "Backend Developer",
        email: "mia.c@example.com",
        phone: "+8801710000012",
        bloodGroup: "A-",
        isDonor: false,
      ),
      Employee(
        id: "13",
        name: "Noah Lewis",
        designation: "Flutter Developer",
        email: "noah.l@example.com",
        phone: "+8801710000013",
        bloodGroup: "B+",
        isDonor: true,
      ),
      Employee(
        id: "14",
        name: "Ava Robinson",
        designation: "UI/UX Designer",
        email: "ava.r@example.com",
        phone: "+8801710000014",
        bloodGroup: "O-",
        isDonor: false,
      ),
      Employee(
        id: "15",
        name: "Ethan Walker",
        designation: "Project Manager",
        email: "ethan.w@example.com",
        phone: "+8801710000015",
        bloodGroup: "AB+",
        isDonor: true,
      ),
      Employee(
        id: "16",
        name: "Isabella Hall",
        designation: "QA Engineer",
        email: "isabella.h@example.com",
        phone: "+8801710000016",
        bloodGroup: "B-",
        isDonor: false,
      ),
      Employee(
        id: "17",
        name: "Alexander Young",
        designation: "HR Manager",
        email: "alexander.y@example.com",
        phone: "+8801710000017",
        bloodGroup: "A+",
        isDonor: true,
      ),
      Employee(
        id: "18",
        name: "Charlotte King",
        designation: "Business Analyst",
        email: "charlotte.k@example.com",
        phone: "+8801710000018",
        bloodGroup: "AB-",
        isDonor: false,
      ),
      Employee(
        id: "19",
        name: "Daniel Wright",
        designation: "DevOps Engineer",
        email: "daniel.w@example.com",
        phone: "+8801710000019",
        bloodGroup: "O+",
        isDonor: true,
      ),
      Employee(
        id: "20",
        name: "Amelia Scott",
        designation: "Product Owner",
        email: "amelia.s@example.com",
        phone: "+8801710000020",
        bloodGroup: "A-",
        isDonor: false,
      ),

      // 21–30
      Employee(
        id: "21",
        name: "Matthew Green",
        designation: "Frontend Developer",
        email: "matthew.g@example.com",
        phone: "+8801710000021",
        bloodGroup: "B+",
        isDonor: true,
      ),
      Employee(
        id: "22",
        name: "Harper Adams",
        designation: "Backend Developer",
        email: "harper.a@example.com",
        phone: "+8801710000022",
        bloodGroup: "AB+",
        isDonor: false,
      ),
      Employee(
        id: "23",
        name: "Joseph Baker",
        designation: "Flutter Developer",
        email: "joseph.b@example.com",
        phone: "+8801710000023",
        bloodGroup: "O-",
        isDonor: true,
      ),
      Employee(
        id: "24",
        name: "Evelyn Nelson",
        designation: "UI/UX Designer",
        email: "evelyn.n@example.com",
        phone: "+8801710000024",
        bloodGroup: "A+",
        isDonor: false,
      ),
      Employee(
        id: "25",
        name: "Samuel Carter",
        designation: "Project Manager",
        email: "samuel.c@example.com",
        phone: "+8801710000025",
        bloodGroup: "B-",
        isDonor: true,
      ),
      Employee(
        id: "26",
        name: "Abigail Mitchell",
        designation: "QA Engineer",
        email: "abigail.m@example.com",
        phone: "+8801710000026",
        bloodGroup: "O+",
        isDonor: false,
      ),
      Employee(
        id: "27",
        name: "Benjamin Perez",
        designation: "HR Manager",
        email: "benjamin.p@example.com",
        phone: "+8801710000027",
        bloodGroup: "AB-",
        isDonor: true,
      ),
      Employee(
        id: "28",
        name: "Emily Roberts",
        designation: "Business Analyst",
        email: "emily.r@example.com",
        phone: "+8801710000028",
        bloodGroup: "A-",
        isDonor: false,
      ),
      Employee(
        id: "29",
        name: "William Turner",
        designation: "DevOps Engineer",
        email: "william.t@example.com",
        phone: "+8801710000029",
        bloodGroup: "B+",
        isDonor: true,
      ),
      Employee(
        id: "30",
        name: "Sofia Phillips",
        designation: "Product Owner",
        email: "sofia.p@example.com",
        phone: "+8801710000030",
        bloodGroup: "O+",
        isDonor: false,
      ),
      Employee(
        id: "31",
        name: "Henry Campbell",
        designation: "Frontend Developer",
        email: "henry.c@example.com",
        phone: "+8801710000031",
        bloodGroup: "A+",
        isDonor: true,
      ),
      Employee(
        id: "32",
        name: "Ella Parker",
        designation: "Backend Developer",
        email: "ella.p@example.com",
        phone: "+8801710000032",
        bloodGroup: "B+",
        isDonor: false,
      ),
      Employee(
        id: "33",
        name: "Jack Evans",
        designation: "Flutter Developer",
        email: "jack.e@example.com",
        phone: "+8801710000033",
        bloodGroup: "O+",
        isDonor: true,
      ),
      Employee(
        id: "34",
        name: "Grace Edwards",
        designation: "UI/UX Designer",
        email: "grace.e@example.com",
        phone: "+8801710000034",
        bloodGroup: "AB+",
        isDonor: false,
      ),
      Employee(
        id: "35",
        name: "Leo Collins",
        designation: "Project Manager",
        email: "leo.c@example.com",
        phone: "+8801710000035",
        bloodGroup: "B-",
        isDonor: true,
      ),
      Employee(
        id: "36",
        name: "Hannah Stewart",
        designation: "QA Engineer",
        email: "hannah.s@example.com",
        phone: "+8801710000036",
        bloodGroup: "A-",
        isDonor: false,
      ),
      Employee(
        id: "37",
        name: "Ryan Sanchez",
        designation: "HR Manager",
        email: "ryan.s@example.com",
        phone: "+8801710000037",
        bloodGroup: "O-",
        isDonor: true,
      ),
      Employee(
        id: "38",
        name: "Chloe Morris",
        designation: "Business Analyst",
        email: "chloe.m@example.com",
        phone: "+8801710000038",
        bloodGroup: "AB-",
        isDonor: false,
      ),
      Employee(
        id: "39",
        name: "Nathan Rogers",
        designation: "DevOps Engineer",
        email: "nathan.r@example.com",
        phone: "+8801710000039",
        bloodGroup: "A+",
        isDonor: true,
      ),
      Employee(
        id: "40",
        name: "Lily Reed",
        designation: "Product Owner",
        email: "lily.r@example.com",
        phone: "+8801710000040",
        bloodGroup: "B+",
        isDonor: false,
      ),
      Employee(
        id: "41",
        name: "Lily Reed 2",
        designation: "Product Owner",
        email: "lily.r@example.com",
        phone: "+8801710000040",
        bloodGroup: "B+",
        isDonor: false,
      ),
      Employee(
        id: "42",
        name: "Lily Reed 3",
        designation: "Product Owner",
        email: "lily.r@example.com",
        phone: "+8801710000040",
        bloodGroup: "B+",
        isDonor: false,
      ),
    ];
  }
}
