import 'package:flutter/material.dart';
import 'package:hospital_app/models/admit_patient.dart';
import 'package:hospital_app/screens/admit_patient_form_screen.dart';
import 'package:hospital_app/services/admit_patient_service.dart';
import 'package:intl/intl.dart';
import '../models/admited_patient_response_dto.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final AdmitPatientService _patientService = AdmitPatientService();
  late Future<List<AdmitPatientDto>> _futurePatients;

  @override
  void initState() {
    super.initState();
    _futurePatients = _patientService.getAllPatients();
  }

  Future<void> openDialog(AdmitPatientDto patient) async {
    final TextEditingController _advanceController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Advance'),
        content: TextField(
          controller: _advanceController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter amount'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: const Text('Submit'),
            onPressed: () async {
              final advanceAmount = double.tryParse(_advanceController.text);
              if (advanceAmount == null || advanceAmount <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid amount')),
                );
                return;
              }

              try {
                await _patientService.addAdvance(
                  admissionId: patient.id,
                  amount: advanceAmount,
                );
                Navigator.of(context).pop();
                setState(() {
                  _futurePatients = _patientService.getAllPatients();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Advance added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleDischarge(AdmitPatientDto patient) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Discharge'),
        content: Text('Are you sure you want to discharge ${patient.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Discharge'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final success = await _patientService.dischargePatient(admissionId: patient.id);
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Patient discharged successfully')),
          );
          setState(() {
            _futurePatients = _patientService.getAllPatients();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to discharge patient')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Management')),
      body: FutureBuilder<List<AdmitPatientDto>>(
        future: _futurePatients,
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

              final admissionDate = DateFormat('dd MMM yyyy')
                  .format(DateTime.parse(patient.admissionDate));
              final dischargeDate = patient.dischargeDate != null
                  ? DateFormat('dd MMM yyyy').format(DateTime.parse(patient.dischargeDate!))
                  : null;

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
                        patient.name,
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
                      Text('📅 Admitted: $admissionDate'),
                      Text(
                        dischargeDate != null
                            ? '✅ Discharged: $dischargeDate'
                            : '🟡 Still Admitted',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: dischargeDate != null ? Colors.green : Colors.orange,
                        ),
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
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: () => openDialog(patient),
                              icon: const Icon(Icons.attach_money),
                              label: const Text('Add Advance'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (patient.dischargeDate == null)
                              ElevatedButton.icon(
                                onPressed: () => _handleDischarge(patient),
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
    );
  }
}
