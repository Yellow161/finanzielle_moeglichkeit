
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/section_card.dart';
import '../api/api_client.dart';
import 'checkout_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> _products = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final res = await ApiClient.getRequest("/api/products");
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          _products = data is List ? data : [];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        appBar: AppBar(title: Text('Digitale Produkte')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Digitale Produkte'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final p = _products[index] as Map<String, dynamic>;
          return SectionCard(
            title: '${p["title"]} – ${p["price"]} €',
            subtitle: p["description"] ?? '',
            trailing: const Icon(Icons.shopping_cart_checkout_rounded),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CheckoutScreen(product: p),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
