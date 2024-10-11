import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseRepository {
  BaseRepository({this.apiDomain, this.apiUrl});

  final String? apiDomain;
  final String? apiUrl;

  // створення базових заголовків
  Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

// отримання об’єкту даних по специфічному ендпоінту
  Future<Map<String, dynamic>> fetchData({
    required String endpoint,
  }) async {
    final url = Uri.parse('$apiUrl/api/$endpoint');

    final responseHeaders = {...headers};

    final response = await http.get(url, headers: responseHeaders);

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];
    } else if (response.statusCode == 404) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  // додавання даних по пост запиту
  Future<String> postData({
    required String endpoint,
    Object? body,
  }) async {
    final url = Uri.parse('$apiUrl/api/$endpoint');

    final responseHeaders = {
      ...headers,
    };

    final response = await http.post(url, headers: responseHeaders, body: body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
