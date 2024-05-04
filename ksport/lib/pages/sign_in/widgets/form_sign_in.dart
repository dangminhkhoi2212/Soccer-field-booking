import 'package:client_app/config/api_config.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:client_app/services/service_google_auth.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FromSignIn extends StatefulWidget {
  const FromSignIn({super.key});

  @override
  State<FromSignIn> createState() => _FromSignInState();
}

class _FromSignInState extends State<FromSignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final bool _isLoading = false;
  final _logger = Logger();
  final ApiConfig apiConfig = ApiConfig();
  late AuthService _authService;
  @override
  void initState() {
    super.initState();
    _authService = AuthService(apiConfig.dio);
  }

  Future _signIn() async {
    try {
      _formKey.currentState!.saveAndValidate();
      final data = _formKey.currentState!.value;
      final errors = _formKey.currentState!.errors;
      String email = data['email'];
      String password = data['password'];
      if (errors.isNotEmpty || email.isEmpty || password.isEmpty) {
        return;
      }
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                  child: CircularProgressIndicator(
                color: MyColor.secondary,
              )));

      final Response response = await _authService.signInWithEmailAndPassword(
          email: email, password: password);

      _logger.e('Error _signin: ${response.data}');
      if (response.statusCode == 200) {
        final result = response.data;
        _authService.setUserLocal(result);
        await Get.offNamed(RoutePaths.mainScreen);
      }
    } on DioException catch (e) {
      if (mounted) {
        Navigator.of(context).pop();

        HandleError(
                titleDebug: '_signin',
                messageDebug: e.response!.data ?? e.message,
                title: 'Error',
                message: e.response!.data['err_mes'])
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: '_signin');
      Navigator.of(context).pop();
    }
  }

  Widget _buildFormSignIn() {
    return FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            FormBuilderTextField(
              name: 'email',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Email',
                prefixIcon: const LineIcon.envelope(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.email(),
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            FormBuilderTextField(
              name: 'password',
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Password',
                prefixIcon: const LineIcon.key(),
              ),
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(),
              ]),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: const StadiumBorder(),
                  backgroundColor: MyColor.primary),
              onPressed: () {
                _signIn();
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign in',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildFormSignIn(),
      ],
    );
  }
}
