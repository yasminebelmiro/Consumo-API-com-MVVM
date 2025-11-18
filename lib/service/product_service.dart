import 'dart:convert';

import 'package:consumo_api_com_mvvm/model/product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = 'https://fakestoreapi.com/products';

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar produtos. Código: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}