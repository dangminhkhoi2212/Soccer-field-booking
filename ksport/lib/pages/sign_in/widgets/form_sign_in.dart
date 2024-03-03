import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart' hide Response;
import 'package:client_app/routes/route_path.dart';
import 'package:client_app/services/service_google_auth.dart';
import 'package:client_app/utils/util_snackbar.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/const/colors.dart';

class FromSignIn extends StatefulWidget {
  const FromSignIn({super.key});

  @override
  State<FromSignIn> createState() => _FromSignInState();
}

class _FromSignInState extends State<FromSignIn> {
  final _formKey = GlobalKey<FormBuilderState>();
  final bool _isLoading = false;
  Future _signIn() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
                  child: CircularProgressIndicator(
                color: MyColor.secondary,
              )));
      _formKey.currentState!.save();
      final data = _formKey.currentState!.value;
      final errors = _formKey.currentState!.errors;
      if (errors.isNotEmpty) {
        if (mounted) {
          Navigator.of(context).pop();
        }
        return;
      }
      String email = data['email'];
      String password = data['password'];
      final Response? response = await AuthService().signInWithEmailAndPassword(
          email: email.toString(), password: password);
      final result = response!.data;
      if (response.statusCode == 200) {
        AuthService().setUserLocal(result);
        await Get.offNamed(RoutePaths.mainScreen);
      } else {
        if (mounted) {
          Navigator.of(context).pop();
        }
        SnackbarUtil.getSnackBar(
            title: 'Sign in',
            message: result['err_mes'] ?? 'Occur an error. Please try again');
      }
    } catch (e) {
      print('Error _signin: $e');
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  Widget _buildFormSignIn() {
    return FormBuilder(
        key: _formKey,
        autovalidateMode: AutovalidateMode.always,
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
