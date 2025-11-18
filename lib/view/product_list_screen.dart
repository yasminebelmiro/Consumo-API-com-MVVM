import 'package:consumo_api_com_mvvm/view/product_datails_screen.dart';
import 'package:consumo_api_com_mvvm/view_model/product_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Dispara o carregamento dos produtos assim que a tela inicia
    // Usamos addPostFrameCallback para evitar conflitos de renderização inicial
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductViewModel>(context, listen: false).loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo Online', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              Provider.of<ProductViewModel>(context, listen: false).loadProducts();
            },
          )
        ],
      ),
      body: Consumer<ProductViewModel>(
        builder: (context, viewModel, child) {
          // 1. Estado de Carregamento
          if (viewModel.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Buscando produtos..."),
                ],
              ),
            );
          }

          // 2. Estado de Erro
          if (viewModel.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      "Ocorreu um erro:",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      viewModel.errorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: viewModel.loadProducts,
                      child: const Text("Tentar Novamente"),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Estado de Sucesso (Lista Vazia)
          if (viewModel.products.isEmpty) {
            return const Center(child: Text("Nenhum produto encontrado."));
          }

          // 4. Estado de Sucesso (Com dados)
          return ListView.builder(
            itemCount: viewModel.products.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final product = viewModel.products[index];
              return Card(
                elevation: 2,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (c, o, s) => const Icon(Icons.broken_image),
                    ),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "R\$ ${product.price.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(product: product),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}