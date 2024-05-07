import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/edit_profile/widgets/form_avatar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FromEditProfile extends StatefulWidget {
  const FromEditProfile({super.key});

  @override
  State<FromEditProfile> createState() => _FromEditProfileState();
}

class _FromEditProfileState extends State<FromEditProfile> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _box = GetStorage();
  final _logger = Logger();
  final UserService _userService = UserService(ApiConfig().dio);
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
    super.dispose();
    _listenAllowSave!.call();
    _listenCurrentAvatar!.call();
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
      await handleUpdate(
          name: data['name'], phone: data['phone'] ?? '', email: data['email']);
    }
  }

  Future handleUpdate(
      {required String name,
      required String phone,
      required String email}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final userID = _box.read('id');

      final Response response = await _userService.updateUser(
          userID: userID,
          name: name,
          phone: phone,
          email: email,
          avatar: _currentAvatar ?? avatar);
      final data = response.data;
      _box.write('name', data['name']);
      _box.write('phone', data['phone']);
      _box.write('avatar', data['avatar']);

      // refresh
      SnackbarUtil.getSnackBar(
          title: 'Edit profile', message: 'Update successfully.');
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
                titleDebug: 'handleUpdate',
                messageDebug: e.response!.data['err_mes'],
                message: e.response!.data['err_mes'])
            .showErrorDialog(context);
      }
    } catch (e) {
      _logger.e(e, error: 'handleUpdate');
    }
    setState(() {
      _isLoading = false;
    });
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
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            name: 'name',
            decoration: const InputDecoration(
              prefixIcon: LineIcon.userAlt(),
              labelText: 'Name',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          FormBuilderTextField(
            name: 'email',
            decoration: const InputDecoration(
              prefixIcon: LineIcon.envelope(),
              labelText: 'Email',
            ),
          ),
          const SizedBox(
            height: 10,
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
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () {
                  _isAllowSave ? _handleSave() : null;
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
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ],
      ),
    );
  }
}
