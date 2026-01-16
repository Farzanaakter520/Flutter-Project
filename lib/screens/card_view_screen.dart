// import 'package:flutter/material.dart';
// import 'package:hospital_app/models/admit_patient.dart';
//
// class CardViewScreen extends StatelessWidget {
//   final AdmitPatient patient;
//
//   const CardViewScreen({super.key});
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: Padding(
//         padding: const EdgeInsets.all(10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               patient.name,
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.green,
//               ),
//             ),
//             const SizedBox(height: 5),
//             Row(
//               children: [
//                 const Icon(Icons.email, size: 16),
//                 const SizedBox(width: 5),
//                 Expanded(
//                   child: Text(
//                     patient.email,
//                     style: const TextStyle(fontSize: 13),
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 const Icon(Icons.phone, size: 16),
//                 const SizedBox(width: 5),
//                 Text(patient.phone, style: const TextStyle(fontSize: 13)),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Text(
//               "Doctor: ${patient.doctorName}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "Ward: ${patient.ward}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               "Due: ৳${patient.due}",
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: null,
//                   icon: const Icon(Icons.receipt_long),
//                   label: const Text("View Details"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: null,
//                   icon: const Icon(Icons.receipt_long),
//                   label: const Text("Add Advance"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: null,
//                   icon: const Icon(Icons.receipt_long),
//                   label: const Text("Create Bill"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.orange,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: null,
//                   icon: const Icon(Icons.exit_to_app),
//                   label: const Text("Discharge"),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.redAccent,
//                   ),
//                 ),
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.picture_as_pdf),
//                   label: const Text("PDF Receipt"),
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //class CardViewScreen extends StatelessWidget {
// //   // final AdmitPatient admitPatient;
// //
// //
// //   const CardViewScreen({
// //     super.key,
// //     // required this.admitPatient,
// //   });
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Card(
// //       clipBehavior: Clip.antiAlias,
// //       elevation: 50,
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
// //       child: Column(
// //         children: [
// //           Stack(
// //             children: [
// //               Positioned(
// //                 bottom: 16,
// //                 left: 16,
// //                 right: 16,
// //                 child: Text(
// //                   admitPatient.name,
// //                   style: const TextStyle(
// //                     fontSize: 20,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.white,
// //                     backgroundColor: Colors.black54,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //
// //           const SizedBox(height: 10),
// //           Text(
// //             'Email:  ${admitPatient.email} email',
// //             style: const TextStyle(fontSize: 15),
// //           ),
// //
// //           const SizedBox(height: 10),
// //           Text(
// //             'Phone :  ${admitPatient.phone} phone',
// //             style: const TextStyle(fontSize: 15),
// //           ),
// //
// //           const SizedBox(height: 10),
// //           Text(
// //             'Doctor:  ${admitPatient.name} name',
// //             style: const TextStyle(fontSize: 15),
// //           ),
// //           const SizedBox(height: 10),
// //           Text('Ward:  ${admitPatient.ward} ward', style: const TextStyle(fontSize: 15)),
// //
// //           const SizedBox(height: 10),
// //           Text(
// //             'Due :  ${admitPatient.due} due',
// //             style: const TextStyle(fontSize: 15),
// //           ),
// //           const SizedBox(height: 10),
// //           // Padding(
// //           //   padding: const EdgeInsets.all(16).copyWith(bottom: 0),
// //           //   child:
// //           Text(
// //             'Price: ${admitPatient.advanceAmount} Tk',
// //             style: const TextStyle(fontSize: 17),
// //           ),
// //
// //
// //           // const SizedBox(height: 8),
// //           // Row(
// //           //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //           //   children: [
// //           //     TextButton(
// //           //       onPressed: () {
// //           //         Navigator.push(
// //           //           context,
// //           //
// //           //           MaterialPageRoute(
// //           //             builder: (context) =>
// //           //                 EnrollmentFormScreen(courseName: course.courseName),
// //           //           ),
// //           //         );
// //           //       },
// //           //       child: const Text('Details'),
// //           //     ),
// //           //     ElevatedButton(
// //           //       style: ButtonStyle(
// //           //         backgroundColor: MaterialStateProperty.all(Colors.green),
// //           //       ),
// //           //       onPressed: () => _onEnrollPressed(context),
// //           //
// //           //       child: const Text('Enroll'),
// //           //     ),
// //           //   ],
// //           // ),
// //         ],
// //       ),
// //     );
// //   }
// // }
