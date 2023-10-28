import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Product {
  String name;
  int price;
  int stock;

  Product(this.name, this.price, this.stock);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      theme: ThemeData(
        primaryColor: Colors.blue, // Sesuaikan warna utama
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Product> products = [
    Product('Beras', 18000, 100),
    Product('Minyak Goreng', 10000, 70),
    Product('Gula', 5000, 30),
    Product('Mie Instant', 3000, 50),
    Product('Telur', 12000, 50),
  ];

  List<Product> cart = [];
  int totalHarga = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOKO SEMBAKO'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: navigateToCheckout,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return buildProductCard(products[index]);
              },
            ),
          ),
          const Divider(),
          buildTotalPriceText(),
        ],
      ),
    );
  }

  Widget buildProductCard(Product product) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text(
          product.name,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle:
            Text('Harga: Rp${product.price}'), // Tambahkan "Rp" sebelum harga
        trailing: product.stock > 0
            ? IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                color: Theme.of(context)
                    .primaryColor, // Menggunakan warna utama sebagai warna ikon
                onPressed: () {
                  addToCart(product);
                },
              )
            : const Text(
                'STOK SUDAH HABIS',
                style: TextStyle(color: Colors.red),
              ),
      ),
    );
  }

  Widget buildTotalPriceText() {
    int totalHarga =
        cart.fold(0, (previous, current) => previous + current.price);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'TOTAL HARGA:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .primaryColor, // Menggunakan warna utama sebagai warna teks
            ),
          ),
          Text(
            'Rp$totalHarga', // Tambahkan "Rp" sebelum total harga
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .primaryColor, // Menggunakan warna utama sebagai warna teks
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(Product product) {
    if (product.stock > 0) {
      setState(() {
        product.stock--;
        cart.add(product);
        totalHarga += product.price;
      });
    }
  }

  void navigateToCheckout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CheckoutPage(cart: cart, totalHarga: totalHarga),
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  final List<Product> cart;
  final int totalHarga;

  CheckoutPage({required this.cart, required this.totalHarga});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    cart[index].name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(
                      'Harga: Rp${cart[index].price}'), // Tambahkan "Rp" sebelum harga
                );
              },
            ),
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL HARGA:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .primaryColor, // Menggunakan warna utama sebagai warna teks
                  ),
                ),
                Text(
                  'Rp${totalHarga.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  // Menggunakan totalHarga.toStringAsFixed(0) untuk menghilangkan desimal, jika ada
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .primaryColor, // Menggunakan warna utama sebagai warna teks
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              resetCart(context); // Menambahkan context sebagai parameter
            },
            child: const Text('BAYAR'),
          ),
        ],
      ),
    );
  }

  void resetCart(BuildContext context) {
    // Menambahkan context sebagai parameter
    // Implementasikan logika reset keranjang belanja di sini.
    // Ini bisa berarti mengosongkan keranjang dan mengembalikan stok produk.

    // Contoh logika sederhana:
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pembayaran Berhasil'),
          content: Text('Total Harga: Rp$totalHarga'),
          actions: <Widget>[
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .pop(); // Kembali ke halaman utama setelah pembayaran berhasil.
              },
            ),
          ],
        );
      },
    );
  }
}
