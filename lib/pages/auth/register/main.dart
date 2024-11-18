// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';

class RegisterController extends GetxController {
  RxString username = ''.obs;
  RxString email = ''.obs;
  RxString phone = ''.obs;
  RxString password = ''.obs;
  RxString password_confirm = ''.obs;

  setUsername(e) => username.value = e;
  setEmail(e) => email.value = e;
  setPhone(e) => phone.value = e;
  setPassword(e) => password.value = e;
  setPasswordConfirm(e) => password_confirm.value = e;
}

class RegisterPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  RegisterPage({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(RegisterController());

    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffdddddd)),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
    final focusedBorder = outlineInputBorder.copyWith(
      borderSide: BorderSide(color: primaryColor),
    );
    final labelStyle = TextStyle(
      fontSize: 22.5,
      fontWeight: FontWeight.bold,
    );
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  // Image.network(
                  //   "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
                  //   height: 100,
                  // ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Image.asset(
                          'assets/icons/logo.png',
                          height: 35,
                        ),
                      ),
                      Text(
                        'PIMS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
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
                        'Daftar',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Obx(() {
                    final username = state.username.value;
                    final email = state.email.value;
                    final phone = state.phone.value;
                    final password = state.password.value;
                    final password_confirm = state.password_confirm.value;
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Buat username',
                              labelText: 'Username',
                              labelStyle: labelStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            // keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Userrname wajib diisi';
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
                          SizedBox(height: 25),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Masukan email',
                              labelText: 'Email',
                              labelStyle: labelStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setEmail(val);
                            },
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Masukan nomor handphone',
                              labelText: 'No. Handphone',
                              labelStyle: labelStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Kontak wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setPhone(val);
                            },
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Buat kata sandi baru',
                              labelText: 'Kata Sandi',
                              labelStyle: labelStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              suffix: Icon(Iconsax.lock, size: 16),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Kata Sandi wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setPassword(val);
                            },
                          ),
                          SizedBox(height: 25),
                          TextFormField(
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Konfirmasi kata sandi baru',
                              labelText: 'Ulangi Kata Sandi',
                              labelStyle: labelStyle,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              suffix: Icon(Iconsax.lock, size: 16),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Kata Sandi wajib diisi';
                              }
                              if (value != password) {
                                return 'Kata Sandi tidak sama';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              state.setPasswordConfirm(val);
                            },
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                inspect({
                                  'username': username,
                                  'email': email,
                                  'phone': phone,
                                  'password': password,
                                  'password_confirm': password_confirm,
                                });
                                final box = GetStorage();
                                box.write('token', 'abcEFG');
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
                              'Daftar',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 15),
                              child: Text(
                                'Sudah Punya Akun?',
                                style: TextStyle(color: Color(0xff777777)),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.rootDelegate.offNamed('/login');
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: Colors.white,
                              overlayColor: Color(0xffaaaaaa),
                              foregroundColor: Colors.black,
                              shadowColor: Colors.black.withOpacity(0.25),
                              minimumSize: Size(double.infinity, 48),
                              shape: StadiumBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xffdddddd),
                                ),
                              ),
                            ),
                            child: Text(
                              'Kembali ke Login',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
