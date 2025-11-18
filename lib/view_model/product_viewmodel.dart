import 'package:consumo_api_com_mvvm/model/product.dart';
import 'package:consumo_api_com_mvvm/service/product_service.dart';
import 'package:flutter/cupertino.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductService _service = ProductService();

  // Estados
  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters para a View acessar os dados
  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Método para carregar dados (Chamado pela View)
  Future<void> loadProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Notifica a UI para mostrar o loading

    try {
      _products = await _service.fetchProducts();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners(); // Notifica a UI para atualizar a lista ou erro
    }
  }
}