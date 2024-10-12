import 'dart:convert';
import 'package:http/http.dart' as http;

class PathfinderRepository {
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  Future<Map<String, dynamic>> getFields({
    required String urlString,
  }) async {
    final url = Uri.parse(urlString);

    final response = await http.get(
      url,
      headers: headers,
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)['message'] == 'OK') {
      return json.decode(response.body);
    } else if (response.statusCode == 429 || response.statusCode == 500) {
      throw Exception(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<Map<String, dynamic>> sendResult({
    required String urlString,
    required List body,
  }) async {
    final url = Uri.parse(urlString);
    final String jsonBody = jsonEncode(body);

    final response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)['message'] == 'OK') {
      return json.decode(response.body);
    } else if (response.statusCode == 429 || response.statusCode == 500) {
      throw Exception(json.decode(response.body)['message']);
    } else {
      throw Exception('Failed to load data');
    }
  }
}
