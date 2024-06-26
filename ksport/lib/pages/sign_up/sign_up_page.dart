import 'package:client_app/config/api_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:client_app/services/service_google_auth.dart';
import 'package:client_app/storage/storage_user.dart';
import 'package:line_icons/line_icon.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:widget_component/my_library.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isShowPassword = false;
  bool _isShowConfirmPassword = false;
  final StorageUser _storageUser = StorageUser();
  final ApiConfig apiConfig = ApiConfig();
  late AuthService _authService;
  final Map<String, dynamic> _initValue = {
    'name': '',
    'email': '',
    'phone': '',
    'password': ''
  };
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    super.initState();
    _authService = AuthService(apiConfig.dio);
  }

  Future _handleSignUp() async {
    try {
      _formKey.currentState!.save();
      final data = _formKey.currentState!.value;
      final errors = _formKey.currentState!.errors;
      if (errors.isEmpty) {
        final response = await _authService.signUp(
            name: data['name'],
            email: data['email'],
            phone: data['phone'],
            password: data['password']);
        if (response.statusCode == 200) {
          SnackbarUtil.getSnackBar(
              title: 'Sign Up', message: 'Sign up successfully');

          final Map<String, dynamic> data = response.data;
          debugPrint(data.toString());
          final UserModel user = UserModel.fromJson(data);

          _storageUser.setTokenLocal(
              accessToken: user.accessToken ?? '',
              refreshToken: user.refreshToken ?? '');

          _storageUser.setUser(user: user.toJson());

          // update address

          // update address
          await Get.offNamed(RoutePaths.mainScreen);
        } else {
          SnackbarUtil.getSnackBar(
              title: 'Sign Up',
              message: response!.data['err_mes'] ?? 'Occur an error.');
        }
      }
    } catch (e) {
      SnackbarUtil.getSnackBar(title: 'Sign Up', message: '$e');
    }
  }

  String? confirmPasswordValidator(value) {
    if (value != _formKey.currentState!.fields['password']!.value) {
      return "Passwords don't match";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create an account',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                  Text('Sign up to get started.'),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              FormBuilder(
                key: _formKey,
                initialValue: _initValue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    FormBuilderTextField(
                      name: 'name',
                      decoration: const InputDecoration(
                          labelText: 'Name', prefixIcon: LineIcon.user()),
                      validator: FormValidate.nameValidation(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      name: 'email',
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: LineIcon.envelope(),
                      ),
                      validator: FormValidate.emailValidation(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                        name: 'phone',
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          hintText: '(+84)',
                          prefixIcon: LineIcon.mobilePhone(),
                        ),
                        validator: FormValidate.phoneValidation()),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      obscureText: !_isShowPassword,
                      name: 'password',
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const LineIcon.key(),
                          suffix: GestureDetector(
                            child: _isShowPassword
                                ? const LineIcon.eye()
                                : const LineIcon.eyeSlash(),
                            onTap: () {
                              setState(() {
                                _isShowPassword = !_isShowPassword;
                              });
                            },
                          )),
                      validator: FormValidate.passwordValidation(),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FormBuilderTextField(
                      name: 'confirm password',
                      obscureText: !_isShowConfirmPassword,
                      decoration: InputDecoration(
                          labelText: 'Confirm password',
                          prefixIcon: const LineIcon.key(),
                          suffix: GestureDetector(
                            child: _isShowConfirmPassword
                                ? const LineIcon.eye()
                                : const LineIcon.eyeSlash(),
                            onTap: () {
                              setState(() {
                                _isShowConfirmPassword =
                                    !_isShowConfirmPassword;
                              });
                            },
                          )),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        confirmPasswordValidator,
                      ]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  _handleSignUp();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                      color: MyColor.primary,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: const Text(
                    'Sign up',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
