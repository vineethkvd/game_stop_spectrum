import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../controller/verify_phone_controller.dart';
import '../../services/validator/validator.dart';
import '../../utils/app_constant.dart';
import '../widget/custom_buttons.dart';
import '../widget/custom_textfield.dart';

class SendOtpPno extends StatefulWidget {
  const SendOtpPno({super.key});

  @override
  State<SendOtpPno> createState() => _SendOtpPnoState();
}

class _SendOtpPnoState extends State<SendOtpPno> {
  final _formKey = GlobalKey<FormState>();
  final SentOtpController sentOtpController = Get.put(SentOtpController());
  final _sendTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstant.black,
        appBar: AppBar(
          title: Text("SEND OTP",
              style:
                  TextStyle(fontSize: 25.sp, fontFamily: 'BebasNeue-Regular',color: Colors.white)),
          centerTitle: true,
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
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 150.h,
                  ),
                  Lottie.asset('asset/json/playstation.json',
                      width: 100.w,
                      height: 100.h,
                      animate: true,
                      fit: BoxFit.cover,
                      repeat: true),
                  Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: Get.width * 0.85.w,
                            height: 60.h,
                            child: CustomTextField(
                                keyboardType: TextInputType.number,
                                validateInput: (value) =>
                                    Validator.validatePhoneNumber(
                                        phoneNumber: value),
                                controller: _sendTextController,
                                prefixIcon: const Icon(
                                  Icons.phone_android_sharp,
                                  color: Colors.black,
                                ),
                                hintText: "Enter number",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15.0.h, horizontal: 12.0.w)),
                          ),
                          SizedBox(
                            child: CustomElevatedBtn(
                              height: 30.h,
                              backgroundColor: AppConstant.appBtnColor,
                              foregroundColor: AppConstant.appMainColor,
                              title: "GET OTP",
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String phoneNumber =
                                      "+91" + _sendTextController.text.trim();
                                  sentOtpController.sendOtp(phoneNumber);
                                }
                              },
                              textColor: Colors.white,
                              width: Get.width * 0.30.w,
                            ),
                          ),
                        ],
                      ))
                ],
              )),
        ),
      ),
    );
  }
}
