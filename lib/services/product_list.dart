import 'package:apitask/model/product.dart';
import 'package:flutter/material.dart';

class ProductList extends StatefulWidget {
  final List<Product> products;

  const ProductList({super.key, required this.products});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: widget.products.length > 10 ? 10000 : widget.products.length, // Set a large number
      itemBuilder: (context, index) {
        final product = widget.products[index % widget.products.length];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            title: Text(
              product.title,
              style: const TextStyle(fontSize: 14,),
            ),
            trailing: Text(
              "\$${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14,),
            ),
            leading: Image.network(
              product.image,
              width: 50,
              height: 50,
            ), // Display product image
          ),
        );
      },
    );
  }
}
