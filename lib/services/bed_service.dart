import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/bed.dart';

class BedService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<List<Bed>> getAllBeds() async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/admin/get/all/beds'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Bed.fromJson(json)).toList();
    } else {
      throw Exception('Failed to lead beds');
    }
  }

  Future<Bed> getBedById(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/beds/$id'));
    if (response.statusCode == 200) {
      return Bed.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load beds');
    }
  }

  Future<Bed> saveBed(Bed bed) async {
    final response = await http.post(
      Uri.parse('$baseUrl/bed'),
      headers: {'Content-Type': 'Application/json'},
      body: jsonEncode(bed.toJson()),
    );
    if (response.statusCode == 200) {
      return Bed.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to save beds');
    }
  }

  Future<Bed> updateBed(int id, Bed bed) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/admin/edit/bed/$id'),
      headers: {'Content-Type': 'Application/json'},
      body: jsonEncode(bed.toJson()),
    );
    if (response.statusCode == 200) {
      return Bed.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update beds');
    }
  }

  Future<void> deleteBed(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/api/admin/delete/bed/$id'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete beds');
    }
  }
}
