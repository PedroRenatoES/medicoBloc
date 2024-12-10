import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = "https://95bb-189-28-68-207.ngrok-free.app/api/Auth";
  
  Future<bool> register(Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/register?password=${body['password']}"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/Login"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({"email": email, "password": password}),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }
}
