import 'package:blinking_text/blinking_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_stop_spectrum/utils/app_constant.dart';
import 'package:get/get.dart';

import '../../controller/cart_controller.dart';
import '../../controller/whatsapp_controller.dart';
import '../../model/product_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductModel productModel;
  ProductDetailsScreen({Key? key, required this.productModel});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  int currentindex = 0;

  final CarouselController carouselController = CarouselController();

  final CartController _CartController = Get.put(CartController());
  final GetWhatsappMsg _getWhatsappMsg = Get.put(GetWhatsappMsg());


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.black,
        bottomNavigationBar: Container(
          padding:  EdgeInsets.all(8.0.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: Get.width*0.47,
                child: ElevatedButton(
                  onPressed: () {
                    _getWhatsappMsg.sendMessageOnWhatsApp(productModel: widget.productModel);
                  },
                  style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.white),
                    overlayColor: MaterialStateProperty.all(Colors.teal),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9.r))),
                  ),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.share, color: Color(0xFFFF0000),size: 16,),
                      SizedBox(width: 5.w),
                       Text("Share on WhatsApp",
                          style: TextStyle(color: Colors.black,fontFamily: 'Roboto-Bold', fontSize: 11.sp,)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: Get.width*0.47,
                child: ElevatedButton(
                  onPressed: () async {
                    await _CartController.checkProductExistence(
                        uId: user!.uid, productModel: widget.productModel);
                  },
                  style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(Colors.teal),
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9))),
                      backgroundColor: const MaterialStatePropertyAll(Colors.white)),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_cart,size: 15, color: Color(0xFFFF0000)),
                      SizedBox(width: 5.w),
                       Text("Add to Cart",
                          style: TextStyle(
                            fontFamily: 'Roboto-Bold',
                            fontSize: 10.sp,
                            color: Colors.black,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          centerTitle: true,
          title:  Text(
            "PRODUCTS ",
            style: TextStyle(fontFamily: 'BebasNeue-Regular', fontSize: 25.sp,color: Colors.white),
          ),
          backgroundColor: AppConstant.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  itemCount: widget.productModel.productImage.length,
                  itemBuilder: (context, index, realIndex) {
                    final imageUrl = widget.productModel.productImage[index];
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0.r),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.teal],
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0.r),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          width: Get.width - 10.w,
                          placeholder: (context, url) => const ColoredBox(
                            color: Colors.white,
                            child: Center(
                              child: CupertinoActivityIndicator(),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                  options: CarouselOptions(
                    scrollDirection: Axis.horizontal,
                    height: 300.h,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 2),
                    autoPlayAnimationDuration:
                    const Duration(milliseconds: 400),
                    pauseAutoPlayOnTouch: true,
                    enlargeCenterPage: true,
                    aspectRatio: 2.5,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentindex = index;
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 13.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    widget.productModel.productImage.length,
                        (index) => Container(
                      width: currentindex == index ? 17 : 7,
                      height: 7.0,
                      margin:  EdgeInsets.symmetric(horizontal: 3.0.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        color:
                        currentindex == index ? Colors.teal : Colors.white,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: SizedBox(
                    height: Get.height * 0.4.h,
                    child: Card(
                      elevation: 5.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0.r),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0.r),
                          gradient: const LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                            colors: [Colors.teal, Colors.black],
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      widget.productModel.productName,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20.sp,
                                        fontFamily: 'Anton-Regular',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsets.all(8.0.w),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Row(
                                  children: [
                                    BlinkText(
                                        "Price : ₹ ${widget.productModel.price}",
                                        style: TextStyle(
                                            fontFamily: 'Anton-Regular',
                                            fontSize: 35.0.sp,
                                            color: Colors.white),
                                        beginColor: Colors.black,
                                        endColor: Colors.greenAccent,
                                        times: 100,
                                        duration: Duration(seconds: 1)),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0.w),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Category : ${widget.productModel.categoryName}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontFamily: 'BebasNeue-Regular',
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.productModel.productDescription,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontFamily: 'Roboto-Bold',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
