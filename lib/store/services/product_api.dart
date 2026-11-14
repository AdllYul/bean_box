import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

/// Error with a message that is safe to show to the user.
class ApiException implements Exception {
  final String message;

  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Loads products from the Fake Store REST API.
class ProductApi {
  static const String baseUrl = 'https://fakestoreapi.com';

  final http.Client _client;
  final Duration timeout;

  /// [client] and [timeout] can be replaced in tests.
  ProductApi({http.Client? client, this.timeout = const Duration(seconds: 10)})
      : _client = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    final uri = Uri.parse('$baseUrl/products');

    final http.Response response;
    try {
      response = await _client.get(uri).timeout(timeout);
    } on TimeoutException {
      throw ApiException(
        'The server did not respond in ${timeout.inSeconds} seconds. '
        'Check your connection and try again.',
      );
    } on http.ClientException {
      // No internet, airplane mode, DNS failure, blocked request...
      throw const ApiException(
        'No internet connection. Turn off airplane mode or check Wi-Fi.',
      );
    } catch (_) {
      throw const ApiException('Could not connect to the server.');
    }

    switch (response.statusCode) {
      case 200:
        return _parseProducts(response);
      case 404:
        throw const ApiException('Products not found (404).');
      case >= 500:
        throw ApiException(
          'Server error (${response.statusCode}). Please try again later.',
        );
      default:
        throw ApiException('Unexpected response (${response.statusCode}).');
    }
  }

  List<Product> _parseProducts(http.Response response) {
    try {
      // bodyBytes + utf8: correct text even if the server omits the charset
      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      final list = decoded as List<dynamic>;
      return list
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FormatException {
      throw const ApiException('The server sent invalid data.');
    } on TypeError {
      throw const ApiException('The server sent data in an unexpected format.');
    }
  }
}
