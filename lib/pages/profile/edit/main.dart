// ignore_for_file: non_constant_identifier_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController {
  RxString email = ''.obs;
  RxString first_name = ''.obs;
  RxString last_name = ''.obs;
  RxString phone = ''.obs;
  final nik = Rxn<int>();
  RxString nik_file = ''.obs;
  final birth = Rxn<DateTime>();
  final gender = Rxn<int>();
  final marital = Rxn<int>();
  final religion_id = Rxn<int>();
  final occupation_id = Rxn<int>();
  final province_id = Rxn<int>();
  final city_id = Rxn<int>();
  RxString address = ''.obs;
  final social = Rxn<Map<String, dynamic>>();

  final errorMessage = Rxn<dynamic>(null);
  RxBool submitBtnIsLoading = false.obs;

  setEmail(e) => email.value = e;
  setFirstName(e) => first_name.value = e;
  setLastName(e) => last_name.value = e;
  setPhone(e) => phone.value = e;
  setNIK(e) => nik.value = e;
  setNIKFile(e) => nik_file.value = e;
  setBirth(e) => birth.value = e;
  setGender(e) => gender.value = e;
  setMarital(e) => marital.value = e;
  setReligionID(e) => religion_id.value = e;
  setOccupationID(e) => occupation_id.value = e;
  setProvinceID(e) => province_id.value = e;
  setCityID(e) => city_id.value = e;
  setAddress(e) => address.value = e;
  setSocial(e) => social.value = e;

  submitFn() async {
    submitBtnIsLoading.value = true;
    final params = {
      'email': email.value,
      'first_name': first_name.value,
      'last_name': last_name.value,
      'phone': phone.value,
      'nik': nik.value,
      'nik_file': nik_file.value,
      'birth': birth.value,
      'gender': gender.value,
      'marital': marital.value,
      'religion_id': religion_id.value,
      'occupation_id': occupation_id.value,
      'province_id': province_id.value,
      'city_id': city_id.value,
      'address': address.value,
      'social': social.value,
    };
    try {
      inspect(params);
      // final api = await API().post('update/profile', data: params);
      // errorMessage.value = null;
      // if (api.data['status'] == 'success') {
      //   Get.rootDelegate.offNamed('/profile');
      // }
    } catch (e) {
      dynamic err = e;
      // dynamic error = err?.response?.data['message'];
      dynamic error = err?.response?.data['message'] ?? err?.error?.message;
      errorMessage.value = error;
    } finally {
      submitBtnIsLoading.value = false;
    }
  }
}

class ProfileEditPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  ProfileEditPage({super.key});
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final state = Get.put(ProfileEditController());

    final outlineInputBorder = OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffdddddd)),
      borderRadius: BorderRadius.all(Radius.circular(100)),
    );
    final focusedBorder = outlineInputBorder.copyWith(
      borderSide: BorderSide(color: primaryColor),
    );
    final labelStyle = TextStyle(
      fontSize: 16,
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
      body: Obx(() {
        final submitBtnIsLoading = state.submitBtnIsLoading.value;
        final errorMessage = state.errorMessage.value.toString();
        return SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  children: [
                    SizedBox(height: 50),
                    errorMessage != '' && errorMessage != 'null'
                        ? Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.025),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 1,
                                color: Colors.red.withOpacity(0.25),
                              ),
                            ),
                            child: Text(
                              errorMessage,
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 25),
                          // ========= EMAIL =========
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Masukan email',
                              labelText: 'Email',
                              labelStyle: labelStyle,
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
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
                              const pattern =
                                  r"^([\w.%+-]+)@([\w-]+\.)+([\w]{2,})$";
                              final regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Mohon masukan format email yang benar';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) => state.setEmail(val),
                          ),
                          SizedBox(height: 25),
                          // ========= FIRST NAME =========
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Nama Depan',
                              labelText: 'Nama Depan',
                              labelStyle: labelStyle,
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                return 'Nama depan wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) => state.setFirstName(val),
                          ),
                          SizedBox(height: 25),
                          // ========= LAST NAME =========
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Nama Belakang',
                              labelText: 'Nama Belakang',
                              labelStyle: labelStyle,
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                return 'Nama belakang wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) => state.setLastName(val),
                          ),
                          SizedBox(height: 25),
                          // ========= PHONE =========
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Masukan nomor handphone',
                              labelText: 'No. Handphone',
                              labelStyle: labelStyle,
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                return 'No. Handphone wajib diisi';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) => state.setPhone(val),
                          ),
                          SizedBox(height: 25),
                          // ========= NIK =========
                          TextFormField(
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Masukan NIK',
                              labelText: 'NIK',
                              labelStyle: labelStyle,
                              // floatingLabelBehavior: FloatingLabelBehavior.always,
                              hintStyle: TextStyle(color: Color(0xff777777)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 24,
                              ),
                              border: outlineInputBorder,
                              enabledBorder: outlineInputBorder,
                              focusedBorder: focusedBorder,
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'NIK wajib diisi';
                              }
                              const pattern = r"^([0-9])+([\d]{15})";
                              final regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Mohon masukan format NIK yang benar';
                              }
                              return null;
                            },
                            onTapOutside: (e) {
                              _formKey.currentState!.validate();
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (val) {
                              try {
                                state.setNIK(int.parse(val));
                              } catch (e) {
                                //
                              }
                            },
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 20)),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  !submitBtnIsLoading) {
                                _formKey.currentState!.save();
                                state.submitFn();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: primaryColor
                                  .withOpacity(submitBtnIsLoading ? 0.5 : 1),
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 48),
                              shape: StadiumBorder(),
                            ),
                            child: Text(
                              submitBtnIsLoading ? 'Waiting...' : 'Simpan',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton(
                            onPressed: () {
                              Get.rootDelegate.popRoute();
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
                              'Kembali',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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
        );
      }),
    );
  }
}
