import 'package:apitask/localization/locales.dart';
import 'package:apitask/model/product.dart';
import 'package:apitask/services/product_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';

class ProductCategory extends StatefulWidget {
  const ProductCategory({super.key});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  final List<String> _categories = [];
  List<Product> _products = [];
  @override
  void initState() {
    super.initState();
    // Fetch categories on initialization
    _fetchCategories();
    _fetchProducts();
  }

  Future<void> _fetchCategories() async {
    // Consider using a service or repository for network calls
    final response = await Dio().get('https://fakestoreapi.com/products/categories');
    if (response.statusCode == 200) {
      final List<dynamic> data = response.data;
      setState(() {
        _categories.addAll(data.cast<String>()); // Safely cast to String type
      });
    } else {
      print('Error fetching categories: ${response.statusCode}');
    }
  }

  Future<void> _fetchProductsByCategory(String category) async {
    final response = await Dio().get('https://fakestoreapi.com/products/category/$category');
    if (response.statusCode == 200) {
      final List<Product> products = parseProductsFromResponse(response.data);
      setState(() {
        _products = products;
      });
    } else {
      print('Error fetching products: ${response.statusCode}');
    }
  }

  Future<void> _fetchProducts() async {
    final response = await Dio().get('https://fakestoreapi.com/products');
    if (response.statusCode == 200) {
      final List<Product> products = parseProductsFromResponse(response.data); // Decode JSON data
      setState(() {
        _products = products;
      });
    } else {
      print('Error fetching products: ${response.statusCode}');
    }
  }



  List<Product> parseProductsFromResponse(List<dynamic> data) {
    return data.map((json) => Product.fromJson(json)).toList();
  }


  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      physics: const NeverScrollableScrollPhysics(), // Disable outer scroll
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            leading: Container(),
            expandedHeight: 50.0, // Adjust height as needed
            flexibleSpace: _buildCategoryRow(context), // Can keep flexibleSpace
            pinned: true,
            floating: false,
            surfaceTintColor: Colors.transparent,
            backgroundColor: Colors.grey[300],
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
            ),
          ),
        ];
      },
      body: ProductList(products: _products),
    );

  }

  Widget _buildCategoryRow(BuildContext context) {
    return _categories.isEmpty
        ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching
        : ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length + 1, // Add 1 for the "All Products" button
      itemBuilder: (context, index) {
        if (index == 0) {
          // Display "All Products" button at index 0
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () {
                // Handle "All Products" button press
                _fetchProducts();
              },
              child: Text(LocaleData.allProducts.getString(context)),
            ),
          );
        } else {
          // Display category buttons
          final category = _categories[index - 1];
          String localizedString = '';
          switch (category) {
            case 'jewelery':
              localizedString = LocaleData.jewelery.getString(context);
              break;
            case 'electronics':
              localizedString = LocaleData.electronics.getString(context);
              break;
            case "men's clothing":
              localizedString = LocaleData.menCloth.getString(context);
              break;
            case "women's clothing":
              localizedString = LocaleData.womenCloth.getString(context);
              break;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black87),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(Colors.black),
              ),
              onPressed: () {
                _fetchProductsByCategory(category);
              },
              child: Text(localizedString),
            ),
          );
        }
      },
    );

  }
}
