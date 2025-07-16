import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:women_saftey/components/custom_textfield.dart';
import 'package:women_saftey/components/primary_button.dart';
import 'package:women_saftey/components/secondary_botton.dart';
import 'package:women_saftey/controller/register_controller.dart';
import 'package:women_saftey/utils/consts.dart';

class RegisterChild extends StatefulWidget {
  const RegisterChild({super.key});

  @override
  State<RegisterChild> createState() => _RegisterChildState();
}

class _RegisterChildState extends State<RegisterChild> {
  RegisterController registercontroller = Get.put(RegisterController());

 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Stack(children: [
              SingleChildScrollView(
                child: Form(
              key: registercontroller.formKey,
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Register as child",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03),

                  SizedBox(
                    height: 250,
                    child: Lottie.asset(
                      'assets/Animation - 1740474057338.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  Column(
                    children: [
                      CustomTextField(
                        hintText: 'enter name',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.name,
                        prefix: Icon(Icons.person),
                        onsave: (name) {
                          registercontroller.formData['name']=name??'';
                        },
                        validate: (email) {
                          if (email!.isEmpty || email.length < 3) {
                            return 'enter correct name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: 'enter phone',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.phone,
                        prefix: Icon(Icons.phone),
                        onsave: (phone) {
                          registercontroller.formData['phone'] = phone ?? "";
                        },
                        validate: (email) {
                          if (email!.isEmpty || email.length < 10) {
                            return 'enter correct phone';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: 'enter email',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.emailAddress,
                        prefix: Icon(Icons.person),
                        onsave: (email) {
                          registercontroller.formData['cemail'] = email ?? "";
                        },
                        validate: (email) {
                          if (email!.isEmpty ||
                              email.length < 3 ||
                              !email.contains("@")) {
                            return 'enter correct email';
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomTextField(
                        hintText: 'enter guardian email',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.emailAddress,
                        prefix: Icon(Icons.person),
                        onsave: (gemail) {
                            registercontroller.formData['gemail'] = gemail ?? "";
                        },
                        validate: (email) {
                          if (email!.isEmpty ||
                              email.length < 3 ||
                              !email.contains("@")) {
                            return 'enter correct email';
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      Obx( ()=>CustomTextField(
                        hintText: 'enter password',
                        isPassword: registercontroller.isPasswordShown.value,
                        prefix: Icon(Icons.vpn_key_rounded),
                        validate: (password) {
                          if (password!.isEmpty || password.length < 7) {
                            return 'enter correct password';
                          }
                          return null;
                        },
                        onsave: (password) {
                          registercontroller.formData['password'] = password ?? "";
                        },
                        suffix: IconButton(
                            onPressed: () {
                              registercontroller.togglepasswordvisibility();
                            },
                            icon: registercontroller.isPasswordShown.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                      )),
                      const SizedBox(height: 12),
                     Obx((){
                      return  CustomTextField(
                        hintText: 'retype password',
                        isPassword: registercontroller.isRetypePasswordShown.value,
                        prefix: Icon(Icons.vpn_key_rounded),
                        validate: (password) {
                          if (password!.isEmpty || password.length < 7) {
                            return 'enter correct password';
                          }
                          return null;
                        },
                        onsave: (password) {
                          registercontroller.formData['repassword']=password??'';
                        },
                        suffix: IconButton(
                            onPressed: () {
                             registercontroller.toggleRetypePasswordVisibility();
                            },
                            icon: registercontroller.isRetypePasswordShown.value
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility)),
                      );
                     }),
                      const SizedBox(height: 12),
                      PrimaryButton(
                          title: 'REGISTER',
                          onPressed: () {
                            if (registercontroller.formKey.currentState!.validate()) {
                              registercontroller.registerUser(context);
                            }
                          }),
                    ],
                  ),

                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black),
                  ),
                  SecondaryButton(
                      title: 'Login with your account',
                      onPressed: () {
                        Get.offAllNamed("loginChild");
                      }),
                ],
              ),
            )),
            ],)
          ),
        ),
      ),
    );
  }
}
