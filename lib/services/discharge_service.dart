import 'dart:convert';
import 'package:hospital_app/models/admited_patient_response_dto.dart';
import 'package:hospital_app/models/patient_dto.dart';
import 'package:http/http.dart' as http;

class DischargePatientService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  // Future<List<AdmitPatientDto>> dischargePatient() async {
  //   final response = await http.get(Uri.parse('$baseUrl/api/admin/get/all/doctors'));
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => Doctor.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to lead doctors');
  //   }
  // }
  Future<List<AdmitPatientDto>> dischargePatient({
    required int admissionId
  }) async {
    final url = Uri.parse('$baseUrl/api/admin/discharge?id=$admissionId');

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
    );

      if (response.statusCode == 200) {
         final List<dynamic> data = jsonDecode(response.body);
         return data.map((json) => AdmitPatientDto.fromJson(json)).toList();
      } else {
      throw Exception('Failed to discharge patient: ${response.body}');
    }
  }

  Future<List<PatientDto>> getAllPatients() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/discharged'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PatientDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }
}
