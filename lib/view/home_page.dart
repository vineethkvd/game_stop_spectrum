import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_stop_spectrum/view/Screens/cart_page.dart';
import 'package:game_stop_spectrum/view/Screens/profile_page.dart';
import 'package:game_stop_spectrum/view/auth_ui/onboarding_screen.dart';
import 'package:game_stop_spectrum/view/test.dart';
import 'package:game_stop_spectrum/view/widget/banner_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:game_stop_spectrum/view/widget/category_widget.dart';
import 'package:game_stop_spectrum/view/widget/custom_grid.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../controller/get_user_data_controller.dart';
import '../controller/google_sign_in_controller.dart';
import '../services/contacts/contact-us.dart';
import '../utils/app_constant.dart';

import 'Screens/orders_screen.dart';
import 'home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MainPageState();
}

class _MainPageState extends State<HomePage> {
  final _advancedDrawerController = AdvancedDrawerController();
  final GoogleSignInController googleSignInController =
      GoogleSignInController();
  final GetUserDataController _getUserDataController =
      Get.put(GetUserDataController());
  User? user = FirebaseAuth.instance.currentUser;
  late List<QueryDocumentSnapshot<Object?>> userData = [];

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
  }

  _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return AdvancedDrawer(
          backdrop: Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.black, Colors.teal.withOpacity(0.2)],
              ),
            ),
          ),
          controller: _advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          childDecoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0.0.r,
              ),
            ],
            borderRadius: BorderRadius.all(Radius.circular(16.r)),
          ),
          drawer: SafeArea(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: FutureBuilder<List<QueryDocumentSnapshot<Object?>>>(
                      future: _getUserDataController.getUserData(user!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                            child: ListTile(
                              titleAlignment: ListTileTitleAlignment.center,
                              title: Text(
                                "${data.isNotEmpty ? data[0]['username'] : 'N/A'}",
                                style: TextStyle(
                                  color: AppConstant.appTextColor,
                                  fontFamily: 'Roboto-Regular',
                                  fontSize: 15.sp,
                                ),
                              ),
                              subtitle: Text(
                                "${data.isNotEmpty ? data[0]['email'] : 'N/A'}",
                                style: TextStyle(
                                    color: AppConstant.appTextColor,
                                    fontFamily: 'Roboto-Regular',
                                    fontSize: 10.sp),
                              ),
                              leading: CircleAvatar(
                                  radius: 22.0.r,
                                  backgroundColor: AppConstant.appMainColor,
                                  child:
                                      Image.network("${data[0]['userImg']}")),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  const Divider(
                    indent: 10.0,
                    endIndent: 10.0,
                    thickness: 1.5,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const HomePage());
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Home",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: const Icon(
                        Icons.home,
                        color: AppConstant.appTextColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppConstant.appTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: ListTile(
                      onTap: () {
                        Get.to(() => const ProfilePage());
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Profile",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: const Icon(
                        Icons.account_circle,
                        color: AppConstant.appTextColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppConstant.appTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Orders",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: const Icon(
                        Icons.shopping_bag,
                        color: AppConstant.appTextColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppConstant.appTextColor,
                      ),
                      onTap: () {
                        Get.to(() => const OrderScreen());
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: ListTile(
                      onTap: () {
                        ContactUsDialog.showContactUsDialog(context);
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Contact",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: const Icon(
                        Icons.help,
                        color: AppConstant.appTextColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppConstant.appTextColor,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0.w),
                    child: ListTile(
                      onTap: () async {
                        GoogleSignIn googleSignIn = GoogleSignIn();
                        FirebaseAuth _auth = FirebaseAuth.instance;
                        await _auth.signOut();
                        await googleSignIn.signOut();
                        Get.offAll(() => const OnboardingScreen());
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: const Icon(
                        Icons.logout,
                        color: AppConstant.appTextColor,
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward,
                        color: AppConstant.appTextColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  DefaultTextStyle(
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white54,
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 16.0.w,
                      ),
                      child: const Text(
                        'Terms of Service | Privacy Policy',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          child: Scaffold(
            backgroundColor: AppConstant.black,
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              actions: [
                InkWell(
                  onTap: () {
                    Get.to(const CartPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 18.w),
                    child: Icon(Icons.shopping_cart_outlined,
                        color: const Color(0xFFFF0000), size: 30.w),
                  ),
                )
              ],
              leading: InkWell(
                onTap: () => _advancedDrawerController..showDrawer(),
                child: Icon(
                  Icons.menu,
                  color: Colors.teal,
                  size: 30.w,
                ),
              ),
              centerTitle: true,
              title: GradientText(
                "GET YOUR GAMES HERE ",
                style: TextStyle(
                  fontSize: 20.0.sp,
                ),
                colors: const [
                  Colors.blue,
                  Colors.red,
                  Colors.teal,
                ],
              ),
              backgroundColor: AppConstant.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                width: ScreenUtil().screenWidth,
                height: ScreenUtil().screenHeight,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        "Check out these",
                        style: TextStyle(
                            fontFamily: 'BebasNeue-Regular',
                            fontSize: 20.sp,
                            color: Colors.white),
                      ),
                    ),
                    const BannerWidget(),
                    SizedBox(
                      height: 25.h,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        "Genres",
                        style: TextStyle(
                            fontFamily: 'BebasNeue-Regular',
                            fontSize: 20.sp,
                            color: Colors.white),
                      ),
                    ),
                    const CategoryWidget(),
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        "COLLECTIONS",
                        style: TextStyle(
                            fontFamily: 'BebasNeue-Regular',
                            fontSize: 20.sp,
                            color: Colors.white),
                      ),
                    ),
                    GetProductWidget()
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
