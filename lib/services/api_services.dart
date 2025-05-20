import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.231.171:5000/get-career'; // Change to your IP

  static Future<List<String>> getCareerRecommendations(List<String?> answers) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'answers': answers}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<String>.from(data['careers']);
    } else {
      throw Exception('Failed to get recommendations: ${response.body}');
    }
  }
}
