import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../models/product.dart';
import 'order_screen.dart'; // Pastikan import OrderScreen
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'account_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _apiService = ApiService();
  List<Product> _products = [];
  List<String> _notifications = [];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() async {
    final products = await _apiService.getProducts();
    setState(() {
      _products = products;
    });
  }

  void _createOrder() async {
    final selectedProductIds = _products.where((product) => product.isSelected).map((product) => product.id).toList();
    final success = await _apiService.createOrder(widget.user.id, selectedProductIds);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order created')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create order')));
    }
  }

  void _navigateToOrderScreen(String imagePath, double price) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderScreen(
          imagePath: imagePath,
          price: price,
          onOrderPlaced: (String notification) {
            setState(() {
              _notifications.add(notification);
              _selectedIndex = 2; // Berpindah ke tab Notifications
            });
          },
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgetOptions() => <Widget>[
    _buildHomeContent(),
    FavoritesScreen(),
    NotificationsScreen(notifications: _notifications),
    AccountScreen(),
  ];

  Widget _buildHomeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Daftar Menu',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: _products.length,
            itemBuilder: (context, index) {
              final product = _products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('Rp ${product.price}'),
                trailing: Checkbox(
                  value: product.isSelected,
                  onChanged: (value) {
                    setState(() {
                      product.isSelected = value ?? false;
                    });
                  },
                ),
              );
            },
          ),
        ),
        SizedBox(height: 16),
        Container(
          padding: EdgeInsets.all(4.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
            ),
            shrinkWrap: true,
            itemCount: 4,
            itemBuilder: (context, index) {
              final imageNames = [
                'coffee1.png',
                'coffee2.png',
                'coffee3.png',
                'coffee4.png',
              ];
              final coffeeNames = [
                'Coffee Arabica',
                'Coffee Robusta',
                'Coffee Latte',
                'Coffee Espresso',
              ];
              final imageName = imageNames[index];
              final coffeeName = coffeeNames[index];
              final price = 50.0 + index * 10; // Contoh harga produk

              return GestureDetector(
                onTap: () => _navigateToOrderScreen('assets/images/$imageName', price),
                child: Card(
                  elevation: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/$imageName',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 8),
                      Text(
                        coffeeName,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Welcome ${widget.user.username}')),
      backgroundColor: Colors.brown,
      body: _widgetOptions().elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.red,
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
