import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_kit/ecommerce_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/get_product_data.dart';
import '../model/product_model.dart';
import 'Screens/product_details_page.dart';


class GetProductWidget extends StatefulWidget {
  const GetProductWidget({super.key});

  @override
  State<GetProductWidget> createState() => _GetProductWidgetState();
}

class _GetProductWidgetState extends State<GetProductWidget> {
  final GetProductDataController _getProductDataController = Get.put(GetProductDataController());
  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _getProductDataController.getProductData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading indicator or placeholder widget
          return SizedBox(
              width: 20.w,
              height: 20.h,
              child: const Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasError) {
          // Handle error
          return Text('Error: ${snapshot.error}');
        } else {
          // Data has been loaded successfully
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;

          // Rest of your widget tree using the 'data'
          return  GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              childAspectRatio: 0.80,

            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: dataLength,
            itemBuilder: (BuildContext context, int index) {
              final productData = data[index];
              ProductModel productModel = ProductModel(
                productId: productData['productId'],
                categoryId: productData['categoryId'],
                productName: productData['productName'],
                categoryName: productData['categoryName'],
                productDescription: productData['productDescription'],
                createdAt: productData['createdAt'],
                updatedAt: productData['updatedAt'],
                price: productData['price'],
                productImage: productData['productImage'],
                consoleType: productData['consoleType'],
              );
              return EcommerceElement.productCard(imageBoxFit: BoxFit.fill,);
            },
          );
        }
      },
    );
  }
}