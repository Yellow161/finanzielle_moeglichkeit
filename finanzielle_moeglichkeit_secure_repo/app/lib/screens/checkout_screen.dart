
import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../api/api_client.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const CheckoutScreen({super.key, required this.product});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _paymentMethod = 'stripe';
  bool _processing = false;

  Future<void> _startPayment() async {
    setState(() => _processing = true);
    try {
      final res = await ApiClient.postRequest("/api/checkout", {
        "productId": widget.product["_id"],
        "method": _paymentMethod,
      });
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body["message"] ?? "Zahlung gestartet.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Fehler beim Start der Zahlung.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler: $e")),
      );
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product['title'] as String,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product['description'] as String? ?? '',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            Text(
              '${product['price']} €',
              style: const TextStyle(
                color: Color(0xFFFF6A00),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Zahlungsmethode',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              items: const [
                DropdownMenuItem(
                  value: 'stripe',
                  child: Text('Kreditkarte (Stripe)'),
                ),
                DropdownMenuItem(
                  value: 'paypal',
                  child: Text('PayPal'),
                ),
                DropdownMenuItem(
                  value: 'krypto',
                  child: Text('Krypto (z. B. Coinbase)'),
                ),
              ],
              onChanged: (value) =>
                  setState(() => _paymentMethod = value ?? 'stripe'),
            ),
            const Spacer(),
            PrimaryButton(
              label: _processing ? 'Verarbeite...' : 'Jetzt kaufen',
              icon: Icons.lock_rounded,
              onPressed: _processing ? () {} : _startPayment,
            ),
          ],
        ),
      ),
    );
  }
}
