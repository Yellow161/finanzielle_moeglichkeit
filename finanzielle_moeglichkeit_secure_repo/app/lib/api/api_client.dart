
import 'dart:convert';
import 'package:http/http.dart' as http;

/// API-Client für das Backend.
/// Der API-Key wird NICHT im Code gespeichert, sondern kommt per --dart-define.
class ApiClient {
  // Für Android-Emulator ist 10.0.2.2 richtig, für Web/Device ggf. anpassen.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  static Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (apiKey.isNotEmpty) 'x-api-key': apiKey,
      };

  static Future<http.Response> getRequest(String path) {
    return http.get(Uri.parse('$baseUrl$path'), headers: _headers);
  }

  static Future<http.Response> postRequest(
      String path, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('$baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }
}
