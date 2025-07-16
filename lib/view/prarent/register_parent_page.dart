
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lottie/lottie.dart';
import 'package:women_saftey/components/custom_textfield.dart';
import 'package:women_saftey/components/primary_button.dart';
import 'package:women_saftey/components/secondary_botton.dart';
import 'package:women_saftey/controller/register_controller.dart';
import 'package:women_saftey/controller/register_parent_controller.dart';

class RegisterParentPage extends StatefulWidget {
  const RegisterParentPage({super.key});

  @override
  State<RegisterParentPage> createState() => _RegisterParentPageState();
}

class _RegisterParentPageState extends State<RegisterParentPage> {
  RegisterParentController registerparentcontroller=Get.put(RegisterParentController());

        

  @override

  Widget build(BuildContext context) {


    return Scaffold(
      body: SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Form
                    
                    (
                      key: registerparentcontroller.formKey,
                      child: 
                    Column(
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
                          "Regiser as a parent",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF757575)),
                        ),
                        // const SizedBox(height: 16),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.03),

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
                                      registerparentcontroller.formData['name'] = name ?? "";
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
                                      registerparentcontroller.formData['phone'] = phone ?? "";
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
                                      registerparentcontroller.formData['gemail'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return 'enter correct email';
                                      }
                                    },
                                  ),
                                  CustomTextField(
                                    hintText: 'enter child email',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    onsave: (cemail) {
                                      registerparentcontroller.formData['cemail'] = cemail ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return 'enter correct email';
                                      }
                                    },
                                  ),                                                      const SizedBox(height: 12),

                                  Obx((){
                                    return CustomTextField(
                                    hintText: 'enter password',
                                    isPassword: registerparentcontroller.isPasswordShown.value,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return 'enter correct password';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      registerparentcontroller.formData['password'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                        onPressed: () {
                                         registerparentcontroller.togglepasswordvisibility();
                                        },
                                        icon: registerparentcontroller.isPasswordShown.value
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                  );
                                  }),
                                                                                            const SizedBox(height: 12),

                                 Obx((){
                                  return  CustomTextField(
                                    hintText: 'retype password',
                                    isPassword: registerparentcontroller.isRetypePasswordShown.value,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return 'enter correct password';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      registerparentcontroller.formData['repassword'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                        onPressed: () {
                                         registerparentcontroller.toggleRetypePasswordVisibility();
                                        },
                                        icon: registerparentcontroller.isRetypePasswordShown.value
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                  );
                                 }),
                                                                                            const SizedBox(height: 12),

                                  PrimaryButton(
                                      title: 'REGISTER',
                                      onPressed: () {
                                        if (registerparentcontroller.formKey.currentState!.validate()) {
                                          registerparentcontroller.registerUser(context);
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
                    )
                  ),
                ),
              ),
            ),
          
    );
  }
}
