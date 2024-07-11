import 'package:flutter/material.dart';

class HalamanScreen extends StatelessWidget {
  final Key? key;

  HalamanScreen({this.key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halaman Utama'),
        backgroundColor: Colors.brown, // Ubah warna AppBar menjadi coklat
      ),
      body: Container(
        color: Colors.brown[100], // Ubah background menjadi warna coklat muda
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/coffee-logo.png', // Ganti icon menjadi gambar PNG
                width: 350,
                height: 350,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
