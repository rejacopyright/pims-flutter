import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  RxString username = ''.obs;
  RxString password = ''.obs;

  setUsername(e) => username.value = e;
  setPassword(e) => password.value = e;
}

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(LoginController());
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.05),
                  // Image.network(
                  //   "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                  //   height: 100,
                  // ),
                  Image.asset(
                    'assets/icons/logo.png',
                    height: 150,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'PIMS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: primaryColor,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                        child: VerticalDivider(
                          color: Color(0xffcccccc),
                          indent: 1,
                          endIndent: 1,
                        ),
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 15)),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Username',
                            filled: true,
                            fillColor: primaryColor.withOpacity(0.05),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.0 * 1.5, vertical: 16.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                          // keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Wajib diisi';
                            }
                            // if (!value.contains('.')) {
                            //   return 'Email is invalid, must contain .';
                            // }
                            return null;
                          },
                          onTapOutside: (e) {
                            _formKey.currentState!.validate();
                            FocusManager.instance.primaryFocus?.unfocus();
                          },
                          onChanged: (val) {
                            state.setUsername(val);
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              fillColor: primaryColor.withOpacity(0.05),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16.0 * 1.5, vertical: 16.0),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setPassword(val);
                            },
                          ),
                        ),
                        Obx(() {
                          final username = state.username.value;
                          final password = state.password.value;
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                inspect({
                                  'username': username,
                                  'password': password
                                });
                                final box = GetStorage();
                                box.write('token', 'abcEFG');
                                // Navigate to the main screen
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 48),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          );
                        }),
                        SizedBox(height: 16.0),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Lupa Kata Sandi?',
                            style: TextStyle(color: Color(0xff777777)),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.rootDelegate.toNamed('/register');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'Belum Punya Akun? ',
                              children: [
                                TextSpan(
                                  text: 'Daftar',
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            style: TextStyle(color: Color(0xff777777)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
