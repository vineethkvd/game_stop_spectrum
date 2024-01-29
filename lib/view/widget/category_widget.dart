import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/category_product_controller.dart';
import '../../model/category_model.dart';
import '../Screens/single_category_products.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final CategoryDataController _categoryDataController =
      Get.put(CategoryDataController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
      future: _categoryDataController.getCategoryData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 20.w,
            height: 20.h,
            child: const Center(child: CupertinoActivityIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<QueryDocumentSnapshot<Object?>> data = snapshot.data!;
          int dataLength = data.length;
          return SizedBox(
            height: 120.h,
            width: size.width.w,
            child: ListView.builder(
              itemCount: dataLength,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final productData = data[index];
                CategoriesModel categoryModel = CategoriesModel(
                  categoryId: productData['categoryId'],
                  categoryImg: productData['categoryImg'],
                  categoryName: productData['categoryName'],
                  createdAt: productData['createdAt'],
                  updatedAt: productData['updatedAt'],
                );
                return Padding(
                  padding: EdgeInsets.all(.0.w),
                  child: GestureDetector(
                    onTap: () => Get.to(
                            () => SingleCategoryProducts(
                          categoryId: categoryModel.categoryId,
                        ),
                        transition: Transition.leftToRightWithFade),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0.w),
                            child: Column(
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 80.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                       CircleAvatar(
                                          backgroundColor: Colors.black,
                                          radius: 35.r,
                                        ),
                                        CircleAvatar(
                                          radius: 35,
                                          backgroundColor: Colors.black,
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  categoryModel.categoryImg,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const ColoredBox(
                                                color: Colors.white,
                                                child: Center(
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                                 SizedBox(height: 5.h),
                                Text(
                                  categoryModel.categoryName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
