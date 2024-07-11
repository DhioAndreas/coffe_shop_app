import 'package:flutter/material.dart';
import 'DaftarOrderUser.dart';

class OrderScreen extends StatefulWidget {
  final String imagePath;
  final double price;
  final Function(String) onOrderPlaced;

  OrderScreen({required this.imagePath, required this.price, required this.onOrderPlaced});

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  int _quantity = 1; // Default quantity

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              widget.imagePath,
              width: 200, // Adjust the width as needed
              height: 200, // Adjust the height as needed
              fit: BoxFit.cover, // Optional: Adjust the fit as needed
            ),
            SizedBox(height: 20),
            Text(
              'Price: Rp ${widget.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButton<int>(
              value: _quantity,
              onChanged: (value) {
                setState(() {
                  _quantity = value!;
                });
              },
              items: List.generate(10, (index) => index + 1)
                  .map((quantity) => DropdownMenuItem<int>(
                value: quantity,
                child: Text('$quantity'),
              ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final notification = 'Order placed for ${widget.imagePath} with $_quantity item(s)';
                widget.onOrderPlaced(notification);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DaftarOrderUser(coffeeName: 'Coffee Name', quantity: _quantity),
                  ),
                );
              },
              child: Text('Order Now'),
            ),
          ],
        ),
      ),
    );
  }
}
