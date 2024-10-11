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

    print('****url: $url');

    final response = await http.get(
      url,
      headers: headers,
    );

    print('****json.decode(response.body)data: ${json.decode(response.body)}');

    if (response.statusCode == 200 &&
        json.decode(response.body)['message'] == 'OK') {
      print('success');
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return json.decode(response.body)['message'];
    } else {
      throw Exception('Failed to load data');
    }
  }

  // додавання даних по пост запиту
  Future<Map<String, dynamic>> sendResult({
    required String urlString,
    required Object body,
  }) async {
    final url = Uri.parse(urlString);

    final response = await http.post(
      url,
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200 &&
        json.decode(response.body)['message'] == 'OK') {
      print('success');
      return json.decode(response.body);
    } else if (response.statusCode == 404) {
      return json.decode(response.body)['message'];
    } else {
      throw Exception('Failed to load data');
    }
  }
}
