import 'dart:math';

import 'package:client_app/pages/edit_profile/widgets/form_avatar.dart';
import 'package:easy_loading_button/easy_loading_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/services/service_user.dart';

class FromEditProfile extends StatefulWidget {
  const FromEditProfile({super.key});

  @override
  State<FromEditProfile> createState() => _FromEditProfileState();
}

class _FromEditProfileState extends State<FromEditProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _box = GetStorage();
  final UserService _userService = UserService();
  final Map<String, dynamic> _initValue = {
    'name': '',
    'email': '',
    'phone': ''
  };
  bool _isAllowSave = true;
  bool _isLoading = false;
  String? avatar;
  String? _currentAvatar;
  Function? _listenAllowSave;
  Function? _listenCurrentAvatar;
  @override
  void initState() {
    super.initState();
    initValueForm();
    _listenValue();
  }

  @override
  void dispose() {
    _listenAllowSave!.call();
    _listenCurrentAvatar!.call();
    super.dispose();
  }

  void initValueForm() {
    _initValue['name'] = _box.read('name');
    _initValue['email'] = _box.read('email');
    _initValue['phone'] = _box.read('phone');

    _isAllowSave = _box.read('isAllowSave') ?? true;

    avatar = _box.read('currentAvatar') ?? _box.read('avatar');
  }

  void _listenValue() {
    _listenAllowSave = _box.listenKey(
      'isAllowSave',
      (value) {
        setState(() {
          _isAllowSave = value ?? true;
        });
      },
    );
    _listenCurrentAvatar = _box.listenKey('currentAvatar', (value) {
      setState(() {
        _currentAvatar = value;
      });
    });
  }

  dynamic _handleSave() async {
    _formKey.currentState?.save();
    FocusScope.of(context).unfocus();
    final Map<String, dynamic> data = _formKey.currentState!.value;
    final Map<String, dynamic> errors = _formKey.currentState!.errors;
    if (errors.isEmpty) {
      await handleUpdate(name: data['name'], phone: data['phone'] ?? '');
    }
    print('ERROR HANDLE SAVE: $errors');
  }

  Future handleUpdate({required String name, required String phone}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userID = _box.read('id');

      final Map<String, dynamic> result = await _userService.updateUser(
          userID: userID,
          name: name,
          phone: phone,
          avatar: _currentAvatar ?? avatar);

      _box.write('name', result['name']);
      _box.write('phone', result['phone']);
      _box.write('avatar', result['avatar']);

      // refresh
      Get.snackbar(
        'Edit profile',
        'Update successfully.',
        colorText: Colors.black,
        backgroundColor: Colors.white60,
        snackPosition: SnackPosition.TOP,
        maxWidth: Get.width,
      );
    } catch (e) {
      Get.snackbar(
        'Edit profile',
        'Update failed. Please try again.',
        colorText: Colors.black,
        backgroundColor: Colors.white60,
        snackPosition: SnackPosition.TOP,
        maxWidth: Get.width,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool isValidPhoneNumber(String phoneNumber) {
    RegExp vietnamesePhoneNumberRegExp =
        RegExp(r'^(03[2-9]|05[689]|07[0-9]|08[1-9]|09[0-9])[0-9]{7}$');

    return vietnamesePhoneNumberRegExp.hasMatch(phoneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      initialValue: _initValue,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          const FormAvatar(),
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              prefixIcon: LineIcon.userAlt(),
              labelText: 'Name',
            ),
          ),
          FormBuilderTextField(
            name: 'email',
            enabled: false,
            decoration: const InputDecoration(
                prefixIcon: LineIcon.envelope(),
                labelText: 'Email',
                helperText: 'This email can\'t be changed.'),
          ),
          FormBuilderTextField(
            name: 'phone',
            enableInteractiveSelection: false,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
                prefixIcon: LineIcon.mobilePhone(),
                labelText: 'Phone',
                hintText: '(+84)'),
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(),
              FormBuilderValidators.integer(),
              FormBuilderValidators.equalLength(10),
              (value) {
                if (value != null && !isValidPhoneNumber(value)) {
                  return 'Invalid phone number';
                }
                return null;
              },
            ]),
          ),
          const SizedBox(
            height: 40,
          ),
          InkWell(
            onTap: () {
              _isAllowSave ? _handleSave() : null;
            },
            borderRadius: BorderRadius.circular(50),
            child: Ink(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(50),
                  ),
                  border: Border.all(
                    color: _isAllowSave ? Colors.black87 : Colors.grey.shade200,
                    width: 2,
                  )),
              child: _isLoading == false
                  ? Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: _isAllowSave
                              ? Colors.black87
                              : Colors.grey.shade200,
                        ),
                      ),
                    )
                  : const Center(
                      child: SizedBox(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
    );
  }
}
