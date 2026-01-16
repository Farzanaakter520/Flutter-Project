import 'package:flutter/material.dart';
import 'package:hospital_app/models/admit_patient.dart';
import 'package:hospital_app/screens/admit_patient_form_screen.dart';
import 'package:hospital_app/screens/patient_list_screen.dart';
import 'package:hospital_app/services/admit_patient_service.dart';
import 'package:intl/intl.dart';
import '../models/admited_patient_response_dto.dart';

class ManageBill extends StatefulWidget {
  const ManageBill({super.key});

  @override
  State<ManageBill> createState() => _ManageBillState();
}

class _ManageBillState extends State<ManageBill> {
  final AdmitPatientService _patientService = AdmitPatientService();

  // Future<void> _onSubmit() async{
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const PatientListScreen(),
  //     ),
  //   );
  // }

  // Future openDialog() => showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: Text('Add Advance'),
  //     content: TextField(decoration: InputDecoration(hintText: '0')),
  //     actions: [
  //       TextButton(
  //         child: Text('Submit'),
  //         onPressed: (){},
  //       ),
  //     ],
  //   ),
  // );

  // Future createBill() => showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: Text('Create Bill'),
  //     content: TextField(decoration: InputDecoration(hintText: '0')),
  //     actions: [TextButton(child: Text('Submit'), onPressed: () {})],
  //   ),
  // );

  Future createBill(int patientId) {
    final TextEditingController doctorFeeController = TextEditingController();
    final TextEditingController medicineCostController =
        TextEditingController();

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Bill'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: doctorFeeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Doctor Fee',
                hintText: 'Enter doctor fee',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: medicineCostController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Medicine Cost',
                hintText: 'Enter medicine cost',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Create Bill'),
            onPressed: () async {
              final doctorFee = double.tryParse(doctorFeeController.text) ?? 0;
              final medicineCost =
                  double.tryParse(medicineCostController.text) ?? 0;

              try {
                await _patientService.createBill(
                  admissionId: patientId,
                  doctorFee: doctorFee,
                  medicineCost: medicineCost,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bill created successfully')),
                );
                Navigator.of(context).pop();
                setState(() {}); // refresh list
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating bill: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Bill')),
      body: FutureBuilder<List<AdmitPatientDto>>(
        future: _patientService.getAllPatients(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No patient found'));
          }

          final patients = snapshot.data!;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];

              final admissionDate = DateFormat(
                'dd MMM yyyy',
              ).format(DateTime.parse(patient.admissionDate));
              final dischargeDate = patient.dischargeDate != null
                  ? DateFormat(
                      'dd MMM yyyy',
                    ).format(DateTime.parse(patient.dischargeDate!))
                  : 'Not Discharged';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        '📧 ${patient.email}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '📞 ${patient.phone}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '🧑‍⚕️ Doctor: ${patient.doctorName}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '🏥 Ward: ${patient.bedWard} - Bed ${patient.bedNumber}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '📅 Admitted: $admissionDate',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '📤 Discharge: $dischargeDate',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        '💰 Due: ₹${patient.due.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        '💵 Advance: ₹${patient.advance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Buttons
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                print('View Details for ${patient.name}');
                              },
                              icon: const Icon(Icons.info_outline),
                              label: const Text('View Details'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                              ),
                            ),
                            // const SizedBox(width: 8),
                            // ElevatedButton.icon(
                            //   onPressed: () {
                            //     openDialog();
                            //     print('Add Advance for ${patient.name}');
                            //   },
                            //
                            //   icon: const Icon(Icons.attach_money),
                            //   label: const Text('Add Advance'),
                            //   style: ElevatedButton.styleFrom(
                            //     backgroundColor: Colors.green,
                            //   ),
                            // ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print('Create Bill for ${patient.name}');
                                createBill(patient.id!); // pass patient ID here
                              },
                              icon: const Icon(Icons.receipt),
                              label: const Text('Create Bill'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print('Discharge ${patient.name}');
                              },
                              icon: const Icon(Icons.exit_to_app),
                              label: const Text('Discharge'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () {
                                print('PDF for ${patient.name}');
                              },
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('PDF Receipt'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AdmitPatientFormScreen(),
            ),
          ).then((_) => setState(() {}));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
