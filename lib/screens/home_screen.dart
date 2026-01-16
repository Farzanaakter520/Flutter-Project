import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hospital_app/screens/patient_list_screen.dart';
import '../models/dashboard_status.dart';
import '../services/dashboard_service.dart';
import 'admit_patient_form_screen.dart';
import 'bed_list_screen.dart';
import 'doctor_list_screen.dart';
import 'doctor_screen.dart';
import 'login_screen.dart';
import 'manage_bill.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final DashboardService _dashboardService = DashboardService();
  late Future<DashboardStats> _futureStats;


    Future<void> _logout(BuildContext context) async {
    await const FlutterSecureStorage().delete(key: 'access_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  void initState() {
    super.initState();
    _futureStats = _dashboardService.getDashboardStats();
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Card(
      color: color,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 110,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(icon, color: Colors.white, size: 36),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
    drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Admin Panel',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.library_add_check),
              title: const Text('Doctors List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DoctorListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.library_add),
              title: const Text('Patients List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PatientListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.bed),
              title: const Text('All Bed List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BedListScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.folder_zip),
              title: const Text('Doctor Form'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoctorScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.folder_zip),
              title: const Text('Manage Bill'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ManageBill()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.folder_zip),
              title: const Text('Patient Form'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AdmitPatientFormScreen(),
                  ),
                );
              },
            ),

            // ListTile(
            //   leading: const Icon(Icons.person),
            //   title: const Text('Discharge Patient'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const DischargePatient(),
            //       ),
            //     );
            //   },
            // ),

            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () => _logout(context),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DashboardStats>(
        future: _futureStats,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load stats.\n${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final stats = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildStatCard(
                  title: 'Total Admissions',
                  value: '${stats.totalAdmissions}',
                  color: Colors.blue,
                  icon: Icons.medical_services,
                ),
                _buildStatCard(
                  title: 'Total Discharges',
                  value: '${stats.totalDischarges}',
                  color: Colors.green,
                  icon: Icons.exit_to_app,
                ),
                _buildStatCard(
                  title: 'Total Revenue (৳)',
                  value: stats.totalRevenue.toStringAsFixed(2),
                  color: Colors.teal,
                  icon: Icons.attach_money,
                ),
                _buildStatCard(
                  title: 'Total Beds',
                  value: '${stats.totalBeds}',
                  color: Colors.orange,
                  icon: Icons.king_bed,
                ),
                _buildStatCard(
                  title: 'Occupied Beds',
                  value: '${stats.occupiedBeds}',
                  color: Colors.redAccent,
                  icon: Icons.bed,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:hospital_app/screens/admit_patient_form_screen.dart';
// import 'package:hospital_app/screens/bed_list_screen.dart';
// import 'package:hospital_app/screens/discharge_patient.dart';
// import 'package:hospital_app/screens/manage_bill.dart';
// import 'package:hospital_app/screens/patient_list_screen.dart';
//
// import 'card_view_screen.dart';
// import 'doctor_list_screen.dart';
// import 'doctor_screen.dart';
// import 'login_screen.dart';
//
// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   Future<void> _logout(BuildContext context) async {
//     await const FlutterSecureStorage().delete(key: 'access_token');
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => const LoginScreen()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Hospital App')),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             const DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 'Admin Panel',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.dashboard),
//               title: const Text('Dashboard'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const DoctorListScreen(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.library_add_check),
//               title: const Text('Doctors List'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const DoctorListScreen(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.library_add),
//               title: const Text('Patients List'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const PatientListScreen(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.bed),
//               title: const Text('All Bed List'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const BedListScreen(),
//                   ),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.folder_zip),
//               title: const Text('Doctor Form'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const DoctorScreen()),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.folder_zip),
//               title: const Text('Manage Bill'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const ManageBill()),
//                 );
//               },
//             ),
//
//             ListTile(
//               leading: const Icon(Icons.folder_zip),
//               title: const Text('Patient Form'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const AdmitPatientFormScreen(),
//                   ),
//                 );
//               },
//             ),
//
//             // ListTile(
//             //   leading: const Icon(Icons.person),
//             //   title: const Text('Discharge Patient'),
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => const DischargePatient(),
//             //       ),
//             //     );
//             //   },
//             // ),
//
//             ListTile(
//               leading: const Icon(Icons.logout),
//               title: const Text('Logout'),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       ),
//       body: const Center(child: Text('Welcome to Hospital App!')
//       ),
//
//
//     );
//   }
// }
