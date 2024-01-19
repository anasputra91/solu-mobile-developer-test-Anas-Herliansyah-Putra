import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tessolu/Model/bitcoin.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BitCoin', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder<BitCoin>(
        future: getProduct(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('Belum ada Data'),
            );
          } else {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Disclaimer: ${snapshot.data?.disclaimer ?? "Disclaimer not available"}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CurrencyCard(
                          currencyCode: 'USD',
                          rate: snapshot.data!.bpi!.uSD!.rate!,
                          symbol: '\$',
                          description: snapshot.data!.bpi!.uSD!.description!,
                          updateTime: snapshot.data!.time!.updated!,
                        ),
                        CurrencyCard(
                          currencyCode: 'GBP',
                          rate: snapshot.data!.bpi!.gBP!.rate!,
                          symbol: '£',
                          description: snapshot.data!.bpi!.gBP!.description!,
                          updateTime: snapshot.data!.time!.updated!,
                        ),
                        CurrencyCard(
                          currencyCode: 'EUR',
                          rate: snapshot.data!.bpi!.eUR!.rate!,
                          symbol: '€',
                          description: snapshot.data!.bpi!.eUR!.description!,
                          updateTime: snapshot.data!.time!.updated!,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<BitCoin> getProduct() async {
    final response =
        await http.get(Uri.parse('https://api.coindesk.com/v1/bpi/currentprice.json'));

    return BitCoin.fromJson(jsonDecode(response.body));
  }
}

class CurrencyCard extends StatelessWidget {
  final String currencyCode;
  final String rate;
  final String symbol;
  final String description;
  final String updateTime;

  const CurrencyCard({
    required this.currencyCode,
    required this.rate,
    required this.symbol,
    required this.description,
    required this.updateTime,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: Container(
        width: 200,
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$currencyCode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            SizedBox(height: 10),
            Text(
              '$symbol $rate',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              '$description',
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Updated: $updateTime',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
