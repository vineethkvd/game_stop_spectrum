import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/get_user_data_controller.dart';
import '../../utils/app_constant.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());
  User? user = FirebaseAuth.instance.currentUser;
  late List<QueryDocumentSnapshot<Object?>> userData = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppConstant.black,
        appBar: AppBar(
          title: Text("PROFILE PAGE",
              style:
                  TextStyle(fontSize: 26.sp, fontFamily: 'BebasNeue-Regular',color: Colors.white)),
          centerTitle: true,
          backgroundColor: AppConstant.transparent,
          elevation: 0,
        ),
        body: Container(
          alignment: Alignment.center,
          width: ScreenUtil().screenWidth,
          height: ScreenUtil().screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                height: Get.width * 0.65.w,
                width: Get.width * 0.7.h,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.teal, // Start color
                      Colors.black, // End color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 4.r,
                      color: Colors.transparent,
                      offset: const Offset(0, 2),
                    )
                  ],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                  future: _getUserDataController.getUserData(user!.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Return a loading indicator or placeholder widget
                      return SizedBox(
                          width: 20.w,
                          height: 20.h,
                          child: const Center(
                              child: CupertinoActivityIndicator()));
                    } else if (snapshot.hasError) {
                      // Handle error
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Data has been loaded successfully
                      List<QueryDocumentSnapshot<Object?>> data =
                          snapshot.data!;

                      // Rest of your widget tree using the 'data'

                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0.w, vertical: 20.0.h),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 45.0, // Set your desired radius
                              backgroundImage:
                                  NetworkImage("${data[0]['userImg']}"),
                              backgroundColor: Colors
                                  .transparent, // Set background color to transparent
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.white, // Start color
                                    Colors.white, // End color
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.r,
                                    color: const Color(0x3600000F),
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                const Icon(
                                  Icons.account_circle,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "${data.isNotEmpty ? data[0]['username'] : 'N/A'}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                )
                              ]),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.white, // Start color
                                    Colors.white, // End color
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.r,
                                    color: const Color(0x3600000F),
                                    offset: const Offset(0, 2),
                                  )
                                ],
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(children: [
                                const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  "${data.isNotEmpty ? data[0]['email'] : 'N/A'}",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 14.sp),
                                )
                              ]),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
