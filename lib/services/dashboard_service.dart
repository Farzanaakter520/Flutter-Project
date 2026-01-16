import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/dashboard_status.dart';

class DashboardService {
  static const String baseUrl = 'http://10.0.2.2:8081';

  Future<DashboardStats> getDashboardStats() async {
    final url = Uri.parse('$baseUrl/api/admin/dashboard/stats');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return DashboardStats.fromJson(json);
    } else {
      throw Exception('Failed to load dashboard stats');
    }
  }
}
