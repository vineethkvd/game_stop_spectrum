import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:game_stop_spectrum/view/auth_ui/sentotp.dart';
import 'package:game_stop_spectrum/view/auth_ui/sign_in_screen.dart';
import 'package:game_stop_spectrum/view/widget/custom_textfield.dart';
import 'package:get/get.dart';
import '../../controller/email_sign_in_controller.dart';
import '../../controller/google_sign_in_controller.dart';
import '../../controller/password_visibility_controller.dart';
import '../../services/validator/validator.dart';
import '../../utils/app_constant.dart';
import '../widget/custom_buttons.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();

  final _passwordTextController = TextEditingController();
  final _nameTextController = TextEditingController();
  final GoogleSignInController _googleSignInController =
      Get.put(GoogleSignInController());
  final EmailPassController _emailPassController =
      Get.put(EmailPassController());
  final PasswordVisibilityController _passwordVisibilityController =
      Get.put(PasswordVisibilityController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppConstant.black,
        appBar: AppBar(
          backgroundColor: AppConstant.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              width: ScreenUtil().screenWidth,
              height: ScreenUtil().screenHeight,
              decoration: const BoxDecoration(color: AppConstant.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Column(children: [
                      Text(
                        'CREATE AN ACCOUNT',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFFFFFFF),
                          fontSize: 25.sp,
                          fontFamily: 'BebasNeue-Regular',
                        ),
                      ),
                      Text(
                        'Discover  ✩  Experience  ✩  Play',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFFF0000),
                          fontSize: 25.sp,
                          fontFamily: 'BebasNeue-Regular',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: Get.width * 0.85.w,
                      height: Get.height * 0.46.h,
                      child: Form(
                        key: _formKey,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomTextField(
                                  keyboardType: TextInputType.name,
                                  validateInput: (value) =>
                                      Validator.validateName(
                                        name: value,
                                      ),
                                  prefixIcon: const Icon(
                                    Icons.account_circle,
                                    color: Colors.black,
                                  ),
                                  controller: _nameTextController,
                                  hintText: "Name",
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 15.0.h, horizontal: 12.0.w)),
                              SizedBox(
                                height: 15.h,
                              ),
                              CustomTextField(
                                keyboardType: TextInputType.emailAddress,
                                validateInput: (value) =>
                                    Validator.validateEmail(
                                  email: value,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                controller: _emailTextController,
                                hintText: "Email",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0.h, horizontal: 12.0.w),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Obx(() => CustomTextField(
                                    keyboardType: TextInputType.text,
                                    validateInput: (value) =>
                                        Validator.validatePassword(
                                      password: value,
                                    ),
                                    obscureText: _passwordVisibilityController
                                        .passwordVisible.value,
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          _passwordVisibilityController
                                              .updateVisibility();
                                        },
                                        icon: Icon(_passwordVisibilityController
                                                .passwordVisible.value
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                        color: Colors.black),
                                    prefixIcon: const Icon(Icons.lock,
                                        color: Colors.black),
                                    controller: _passwordTextController,
                                    hintText: "Password",
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0.h, horizontal: 12.0.w),
                                  )),
                              SizedBox(
                                height: 15.h,
                              ),
                              CustomElevatedBtn(
                                height: 40.h,
                                backgroundColor: AppConstant.appBtnColor,
                                foregroundColor: AppConstant.appMainColor,
                                title: "Sign Up",
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await _emailPassController.signupUser(
                                        _emailTextController.text,
                                        _passwordTextController.text,
                                        _nameTextController.text);
                                    await _emailPassController
                                        .checkCurrentUser();
                                  }
                                },
                                textColor: Colors.white,
                                width: Get.width * 0.85.w,
                              ),
                              Center(
                                child: CustomTextBtn(
                                  title: "Already have an account",
                                  foregroundColor: Colors.white,
                                  onPressed: () {
                                    Get.to(() => const SignInPage(),
                                        transition:
                                            Transition.leftToRightWithFade);
                                  },
                                  width: 10.w,
                                  height: 10.h,
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Or continue with',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFFFFFFF),
                              fontSize: 14.sp,
                              fontFamily: 'Roboto-Bold',
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SocialBtn(
                                image: "asset/images/google_icon.svg",
                                onTap: () {
                                  _googleSignInController.signUpWithGoogle();
                                },
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              SocialBtn(
                                image: "asset/images/phoneIn.svg",
                                onTap: () {
                                  Get.to(() => const SendOtpPno());
                                },
                              )
                            ],
                          )
                        ]),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
