import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

void main() {
  runApp(const MaterialApp(home: CryptoPriceScreen()));
}

class CryptoPriceScreen extends StatefulWidget {
  const CryptoPriceScreen({Key? key}) : super(key: key);

  @override
  _CryptoPriceScreenState createState() => _CryptoPriceScreenState();
}

class _CryptoPriceScreenState extends State<CryptoPriceScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _cryptoPrice = '';
  // Replace with your secret key

  Future<void> fetchCryptoPrice(String symbol) async {
    final apiUrl = 'https://indodax.com/api/$symbol/ticker';

    print('Sending API request: $apiUrl');

    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('API Response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final ticker = jsonResponse['ticker'];
      final lastPrice = ticker['last'];
      setState(() {
        _cryptoPrice = lastPrice.toString();
      });
    } else {
      setState(() {
        _cryptoPrice = 'Error fetching data';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Price Checker'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter Crypto Symbol (e.g. btc_idr)',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final symbol = _searchController.text.trim();
                if (symbol.isNotEmpty) {
                  fetchCryptoPrice(symbol);
                }
              },
              child: const Text('Get Crypto Price'),
            ),
            const SizedBox(height: 16),
            Text(
              'Crypto Price: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ').format(double.tryParse(_cryptoPrice) ?? 0)}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
