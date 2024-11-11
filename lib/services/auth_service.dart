import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class AuthService {
  static const String apiUrl = 'http://localhost/adminduk_api/api.php';

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'login',
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<Map<String, dynamic>> registerUser(
    String email,
    String password,
    String nama,
    String alamat,
    String nomorTelepon,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {
          'action': 'register',
          'email': email,
          'password': password,
          'nama': nama,
          'alamat': alamat,
          'nomor_telepon': nomorTelepon,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to connect to server');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
