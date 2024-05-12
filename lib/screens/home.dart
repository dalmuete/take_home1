import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedCurrentCurrency = 'PHP';
  String selectedTargetCurrency = 'USD';
  TextEditingController amountController = TextEditingController();
  String convertedAmount = '';

  void convertCurrency() async {
    final apiKey = '5d1c0d746a2140aab1b462e206e580eb';
    final response = await http.get(Uri.parse(
        'https://openexchangerates.org/api/latest.json?app_id=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Map<String, dynamic> rates = responseData['rates'];
      final double currentRate = rates[selectedCurrentCurrency].toDouble();
      final double targetRate = rates[selectedTargetCurrency].toDouble();
      final double amount = double.tryParse(amountController.text) ?? 0;

      final double convertedAmountInTargetCurrency =
          (amount / currentRate) * targetRate;

      setState(() {
        convertedAmount = convertedAmountInTargetCurrency.toStringAsFixed(2);
      });
    } else {
      setState(() {
        convertedAmount = 'Error: Failed to fetch exchange rates';
      });
    }
  }

  String _getCurrencyName(String currencyCode) {
    switch (currencyCode) {
      case 'USD':
        return 'US Dollar';
      case 'EUR':
        return 'Euro';
      case 'GBP':
        return 'British Pound';
      case 'CAD':
        return 'Canadian Dollar';      
      case 'JPY':
        return 'Japanese Yen';
      case 'RUB':
        return 'Russian Ruble';
      case 'PHP':
        return 'Philippine Peso';
      case 'SAR':
        return 'Saudi Arabian Riyal';
      default:
        return currencyCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Foreign Exchange Conversion',
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.lightBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<String>(
                  value: selectedCurrentCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCurrentCurrency = newValue!;
                    });
                  },
                  items: <String>[
                    'USD',
                    'EUR',
                    'GBP',
                    'CAD',                      
                    'JPY',
                    'RUB',
                    'PHP',
                    'SAR'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getCurrencyName(value)),
                    );
                  }).toList(),
                ),
                Text('to'),
                DropdownButton<String>(
                  value: selectedTargetCurrency,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTargetCurrency = newValue!;
                    });
                  },
                  items: <String>[
                    'USD',
                    'EUR',
                    'GBP',
                    'CAD',                      
                    'JPY',
                    'RUB',
                    'PHP',
                    'SAR'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(_getCurrencyName(value)),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 232, 232, 232),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            
            ElevatedButton(
              onPressed: () {
                convertCurrency();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue,
                padding: EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Convert',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Converted Amount: ',
              style: TextStyle(fontSize: 15),
            ),
            Text(
              '$convertedAmount',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
