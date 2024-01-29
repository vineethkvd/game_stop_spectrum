import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Screens/product_details_page.dart';
import '../../model/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel productModel;

  const ProductCard({Key? key, required this.productModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: () {
          Get.to(() => ProductDetailsScreen(productModel: productModel));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: productModel.productImage[0],
              fit: BoxFit.cover,
              width: Get.width.w,
              height: 80.h, // Set a fixed height
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    productModel.productName,
                    style:  TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14.sp,
                        fontFamily: 'BebasNeue-Regular'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text("₹${productModel.price}",
                      style:  TextStyle(
                          fontFamily: 'BebasNeue-Regular',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold)),
                  Text(
                    productModel.productDescription,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
