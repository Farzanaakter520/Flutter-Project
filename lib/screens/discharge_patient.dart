import 'package:flutter/material.dart';
import 'package:hospital_app/models/patient_dto.dart';
import 'package:hospital_app/services/discharge_service.dart';
import 'package:intl/intl.dart';

import '../models/admited_patient_response_dto.dart';


class DischargePatient extends StatefulWidget {
  const DischargePatient({super.key});

  @override
  State<DischargePatient> createState() => _DischargePatientState();
}

class _DischargePatientState extends State<DischargePatient> {
  final DischargePatientService _dischargeService = DischargePatientService();
  late Future<List<PatientDto>> _futurePatients;

  @override
  void initState() {
    super.initState();
    _futurePatients = _dischargeService.getAllPatients(); // NEW
  }

  Future<void> _handleDischarge(int patientId) async {
    final now = DateTime.now();

    final success = await _dischargeService.dischargePatient(admissionId: patientId);

    if (success != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Patient discharged successfully')),
      );
      setState(() {
        _futurePatients = _dischargeService.getAllPatients();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to discharge patient')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Discharge Patient')),
      body: FutureBuilder<List<PatientDto>>(
        future: _futurePatients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No admitted patients found'));
          }

          final patients = snapshot.data!;
          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];

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
                      Text(
                        patient.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('📧 ${patient.email}'),
                      Text('📞 ${patient.phone}'),
                      Text('🧑‍⚕️ Doctor: ${patient.doctorName}'),
                      Text('🏥 Ward: ${patient.bedWard} - Bed ${patient.bedNumber}'),
                      const SizedBox(height: 12),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      //   children: [
                      //     ElevatedButton.icon(
                      //       icon: const Icon(Icons.exit_to_app),
                      //       label: const Text("Discharge"),
                      //       style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.redAccent,
                      //       ),
                      //       onPressed: () {
                      //         if (patient.id != null) {
                      //           _handleDischarge(patient.id!);
                      //         }
                      //       },
                      //
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
