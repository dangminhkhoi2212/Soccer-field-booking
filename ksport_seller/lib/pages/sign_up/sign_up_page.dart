import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:ksport_seller/config/api_config.dart';
import 'package:ksport_seller/services/service_google_auth.dart';
import 'package:ksport_seller/storage/storage_user.dart';
import 'package:line_icons/line_icon.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _isShowPassword = false;
  bool _isLoading = false;
  bool _isShowConfirmPassword = false;
  final StorageUser _storageUser = StorageUser();
  final _logger = Logger();
  final Map<String, dynamic> _initValue = {
    'name': '',
    'email': '',
    'phone': '',
    'password': ''
  };
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final ApiConfig apiConfig = ApiConfig();
  late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _authService = AuthService(apiConfig.dio);
  }

  Future _handleSignUp() async {
    try {
      setState(() {
        _isLoading = true;
      });
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

          await Get.offNamed(RoutePaths.signIn);
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
                titleDebug: '_handleSignUp',
                messageDebug: e.response!.data ?? e,
                title: 'Sign in',
                message: e.response!.data['err_mes'])
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: '_handleSignUp');
    }
    setState(() {
      _isLoading = false;
    });
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
      appBar: AppBar(
        title: const Text('Sign up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create an account',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
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
                    _isLoading ? null : _handleSignUp();
                  },
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: const BoxDecoration(
                        color: MyColor.primary,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: _isLoading
                        ? Center(
                            child: MyLoading.spinkit(),
                          )
                        : const Text(
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
      ),
    );
  }
}
