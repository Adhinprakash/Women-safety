import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:lottie/lottie.dart';
import 'package:women_saftey/components/custom_textfield.dart';
import 'package:women_saftey/components/secondary_botton.dart';
import 'package:women_saftey/controller/login_child_controller.dart';
import 'package:women_saftey/widgets/home_widgets/safehome/safe_home.dart';

class LoginChildScreen extends StatefulWidget {
  const LoginChildScreen({super.key});

  @override
  State<LoginChildScreen> createState() => _LoginChildScreenState();
}

class _LoginChildScreenState extends State<LoginChildScreen> {
final _formKey=GlobalKey<FormState>();
    LoginChildController loginChildController=Get.put(LoginChildController());

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
                child: Form(
              key: _formKey,
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
                  const SizedBox(height: 14),
                  const Text(
                    "Sign in with your Email and password  ",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF757575)),
                  ),
                  // const SizedBox(height: 16),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  SizedBox(
                    height: 300,
                    child: Lottie.asset(
                      'assets/Animation - 1740463052852.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Column(
                    children: [
                      CustomTextField(
                        hintText: 'enter email',
                        textInputAction: TextInputAction.next,
                        keyboardtype: TextInputType.emailAddress,
                        prefix: const Icon(Icons.person),
                        onsave: (email) {
                         loginChildController.formData['email'] = email ?? "";
                        },
                        validate: (email) {
                          if (email!.isEmpty ||
                              email.length < 3 ||
                              !email.contains("@")) {
                            return 'enter correct email';
                          }
                        },
                      ),
                      Obx((){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: CustomTextField(
                            
                            hintText: 'enter password',
                            isPassword: loginChildController.isPasswordShown.value,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty || password.length < 7) {
                                return 'enter correct password';
                              }
                              return null;
                            },
                            onsave: (password) {
                             loginChildController.formData['password'] = password ?? "";
                            },
                            suffix: IconButton(
                                onPressed: () {
                                 loginChildController.togglePasswordVisibility();
                                },
                                icon: loginChildController.isPasswordShown.value
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                          ));
                      }),
                      const SizedBox(height: 8),
                      const SizedBox(height: 8),
                      PrimaryButton(title: "LOGIN", onPressed: (){
                        if(_formKey.currentState!.validate()){
                          _formKey.currentState!.save();
                          loginChildController.loginUser(context);
                        }
                      }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () => Get.offAllNamed('/registerChild'),
                          child: Text(
                            "SignUp",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SecondaryButton(
                      title: "Register as child", onPressed: () =>  Get.offAllNamed('/registerChild')),
                  SecondaryButton(
                      title: "Register as Parent", onPressed: () => Get.offAllNamed('/registerParent')),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}

const authOutlineInputBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Color(0xFF757575)),
  borderRadius: BorderRadius.all(Radius.circular(100)),
);
