import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/product_model.dart';

class YourWidget extends StatelessWidget {
  final String uId; // Assuming uId is defined somewhere in your widget

  YourWidget({required this.uId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('uId', isEqualTo: uId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          List<QueryDocumentSnapshot> data = snapshot.data!.docs;
          int dataLength = data.length;
          return ListView.builder(
            itemCount: dataLength,
            itemBuilder: (context, index) {
              final productData = data[index].data() as Map<String, dynamic>;
              var product = ProductModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                price: productData['price'],
                productImage: productData['productImage'],
                productDescription: productData['productDescription'],
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
                consoleType: productData['consoleType'],
              );

              // You can now use 'product' to display your UI components
              return ListTile(
                title: Text(product.productName),
                subtitle: Text(product.price),
                // Add other UI components as needed
              );
            },
          );
        }
      },
    );
  }
}
