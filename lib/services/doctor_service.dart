import 'dart:convert';
import 'dart:io';

import 'package:hospital_app/models/doctor.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class DoctorService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<List<Doctor>> getAllDoctors() async {
    final response = await http.get(Uri.parse('$baseUrl/api/admin/get/all/doctors'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Doctor.fromJson(json)).toList();
    } else {
      throw Exception('Failed to lead doctors');
    }
  }

  Future<Doctor> getDoctorById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/doctors/$id'));
    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<Doctor> saveDoctor(Doctor doctor) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/admin/doctor/register'),
      headers: {'Content-Type': 'application/json'}, // fixed capitalization
      body: jsonEncode(doctor.toJson()),
    );
    if (response.statusCode == 201) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(' Doctor Already Exist: ${response.body}');
    }
  }


  Future<Doctor> updateDoctor(int id, Doctor doctor) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/edit/doctor/$id'),
      headers: {'Content-Type': 'Application/json'},
      body: jsonEncode(doctor.toJson()),
    );
    if (response.statusCode == 200) {
      return Doctor.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update doctors');
    }
  }

  Future<void> deleteDoctor(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/api/admin/delete/doctor/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete doctors');
    }
  }

  Future<String> uploadImage(int doctorId,File image) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/doctor/$doctorId/upload'),
    );
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        image.path,
        filename: basename(image.path),
      ),
    );

    final  response = await request.send();
    if(response.statusCode == 200){
      final responseBody = await response.stream.bytesToString();
      final jsonResponse = jsonDecode(responseBody);
      return jsonResponse['url'];
    }else{
      throw Exception('Failed to upload image');
    }
  }
}
