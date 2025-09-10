import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';

class APIClient {
  final http.Client _client;
  final Duration timeout;

  APIClient({http.Client? client, this.timeout = const Duration(seconds: 60)})
    : _client = client ?? http.Client();

  Uri _build(String path) => Uri.parse('${EndPoints.baseUrl}$path');

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = _build(path);
    final resp = await _client
        .post(uri, headers: _defaultHeaders(headers), body: jsonEncode(body))
        .timeout(timeout);
    return _process(resp);
  }

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    Map<String, String>? queryParameters,
  }) async {
    Uri uri = _build(path);
    if (queryParameters != null) {
      uri = uri.replace(queryParameters: queryParameters);
    }
    final resp = await _client
        .get(uri, headers: _defaultHeaders(headers))
        .timeout(timeout);
    return _process(resp);
  }

  Map<String, String> _defaultHeaders(Map<String, String>? extra) {
    final h = {'Content-Type': 'application/json'};
    if (extra != null) h.addAll(extra);
    return h;
  }

  Map<String, dynamic> _process(http.Response resp) {
    final code = resp.statusCode;
    if (code >= 200 && code < 300) {
      if (resp.body.isEmpty) return {};
      return jsonDecode(resp.body) as Map<String, dynamic>;
    } else {
      String message = 'HTTP $code';
      try {
        final m = jsonDecode(resp.body);
        if (m is Map && m['message'] != null) message = m['message'];
      } catch (_) {}
      throw APIException(code, message);
    }
  }
}

class APIException implements Exception {
  final int code;
  final String message;
  APIException(this.code, this.message);

  @override
  String toString() => 'APIException($code): $message';
}
