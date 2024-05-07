import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class PasswordForm extends StatefulWidget {
  final Dio dio;
  const PasswordForm({super.key, required this.dio});

  @override
  State<PasswordForm> createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final _formkey = GlobalKey<FormBuilderState>();
  final _box = GetStorage();
  late String _userID;
  final _logger = Logger();
  late UserService _userService;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _userService = UserService(widget.dio);
  }

  Future _handleUpdatePassword() async {
    FocusScope.of(context).unfocus();
    try {
      _formkey.currentState!.saveAndValidate();
      final Map<String, dynamic> data = _formkey.currentState!.value;
      final Map<String, dynamic> errors = _formkey.currentState!.errors;

      if (errors.isNotEmpty ||
          data['oldPass'] == null ||
          data['newPass'] == null ||
          data['confirmNewPass'] == null) return;

      setState(() {
        _isLoading = true;
      });

      final Response response = await _userService.updatePassword(
          oldPass: data['oldPass'], newPass: data['newPass']);
      _logger.d(response.data, error: 'update pass');
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text(
              'Update password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            content: const Text('Your password is updated'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );

        // SnackbarUtil.getSnackBar(
        //     title: 'Update password', message: 'Your password is updated');
      }
    } on DioException catch (e) {
      _logger.e(e.toString(), error: 'DioException');
      setState(() {
        _isLoading = false;
      });
      if (mounted && e.response!.statusCode == 400) {
        HandleError(
                titleDebug: '_handleUpdatePassword',
                messageDebug: e.response!.data['err_mes'],
                message: e.response!.data['err_mes'])
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: '_handleUpdatePassword');
    }
    _formkey.currentState!.reset();

    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildHead() {
    return const Column(
      children: [
        LineIcon.lock(
          size: 100,
          color: MyColor.primary,
        ),
        Text(
          'Update your password',
          style: TextStyle(fontSize: 18),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formkey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          _buildHead(),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'oldPass',
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Current password',
              label: Text('Current password'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'newPass',
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'New password',
              label: Text('New password'),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          FormBuilderTextField(
            name: 'confirmNewPass',
            obscureText: true,
            decoration: const InputDecoration(
              hintText: 'Confirm new password',
              label: Text('Confirm new password'),
            ),
            validator: (value) {
              _formkey.currentState!.save();
              if (_formkey.currentState!.value['newPass'] != value) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _isLoading ? null : _handleUpdatePassword();
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: MyColor.primary),
                child: _isLoading
                    ? MyLoading.spinkit()
                    : const Text(
                        'Update',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      )),
          ),
        ],
      ),
    );
  }
}
