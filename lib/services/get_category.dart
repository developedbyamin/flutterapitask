import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class GetCategory extends StatefulWidget {
  final String category; // Pass the desired category

  const GetCategory({super.key, required this.category});

  @override
  State<GetCategory> createState() => _GetCategoryState();
}

class _GetCategoryState extends State<GetCategory> {
  final Dio _dio = Dio(); // Create a single Dio instance
  List<dynamic> _products = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoading = true; // Set loading state to true
    });
    try {
      final response = await _dio
          .get('https://fakestoreapi.com/products/category/${widget.category}');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        setState(() {
          _products = data; // Update product list
          _isLoading = false; // Set loading state to false
        });
      } else {
        // Handle error (e.g., show a snackbar)
        print('Error fetching products: ${response.statusCode}');
      }
    } on DioException catch (e) {
      // Handle network or other Dio errors
      print('Dio error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text('Products (${widget.category})'), // Display selected category
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator()) // Show loading indicator
          : ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          // ... build product list items using product data
          return ListTile(
            title: Text(product['title']),
            subtitle: Text(product['price'].toString()),
          );
        },
      ),
    );
  }
}
