import 'dart:convert';

import 'package:hospital_app/models/admit_patient.dart';
import 'package:hospital_app/models/admited_patient_response_dto.dart';
import 'package:hospital_app/models/bill.dart';
import 'package:http/http.dart' as http;

class AdmitPatientService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<List<AdmitPatientDto>> getAllPatients() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/admitted-patients'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => AdmitPatientDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load patients');
    }
  }

  //
  // Future<List<AdmitPatientDto>> getAllBill() async {
  //   final response = await http.get(
  //     Uri.parse('$baseUrl/api/admin/bill/create'),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);
  //     return data.map((json) => AdmitPatientDto.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load bill');
  //   }
  // }

  Future<AdmitPatient> getPatientById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/$id'));
    if (response.statusCode == 200) {
      return AdmitPatient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load patients');
    }
  }

  Future<AdmitPatient> savePatient(AdmitPatient patient) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/admission'),
      headers: {'Content-Type': 'Application/json'},
      body: jsonEncode(patient.toJson()),
    );
    if (response.statusCode == 200) {
      return AdmitPatient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save patient');
    }
  }

  Future<AdmitPatient> updatePatient(int id, AdmitPatient patient) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/edit/bed/$id'),
      headers: {'Content-Type': 'Application/json'},
      body: jsonEncode(patient.toJson()),
    );
    if (response.statusCode == 200) {
      return AdmitPatient.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update patients');
    }
  }

  Future<void> deletePatient(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/delete/bed/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete beds');
    }
  }

  // final String baseUrl = 'https://your-api-url.com/api/patients';
  Future<void> createBill({
    required int admissionId,
    required double doctorFee,
    required double medicineCost,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/admin/bill/create?admissionId=${admissionId}&doctorFee=${doctorFee}&medicineCost=${medicineCost}',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create bill: ${response.body}');
    }
  }

  Future<void> addAdvance({
    required int admissionId,
    required double amount,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/advance?id=$admissionId&amount=$amount'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add advance');
    }
  }

  Future<bool> dischargePatient({required int admissionId}) async {
    final url = Uri.parse('$baseUrl/api/admin/discharge?id=$admissionId');

    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return true; // Discharge successful
      } else {
        print('Failed to discharge patient. Status: ${response.statusCode}, Body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error during discharge: $e');
      return false;
    }
  }


  
}
