import 'package:form_builder_validators/form_builder_validators.dart';

class FormValidate {
  static bool isValidPhoneNumber(String phoneNumber) {
    RegExp vietnamesePhoneNumberRegExp =
        RegExp(r'^(03[2-9]|05[689]|07[0-9]|08[1-9]|09[0-9])[0-9]{7}$');

    return vietnamesePhoneNumberRegExp.hasMatch(phoneNumber);
  }

  static String? checkPhone(value) {
    if (value != null && !isValidPhoneNumber(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  static String? Function(String?)? phoneValidation() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.integer(),
      FormBuilderValidators.equalLength(10),
      checkPhone
    ]);
  }

  static emailValidation() {
    return FormBuilderValidators.compose(
        [FormBuilderValidators.required(), FormBuilderValidators.email()]);
  }

  static nameValidation() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.maxLength(30),
      FormBuilderValidators.required(),
    ]);
  }

  static String? Function(String?)? passwordValidation() {
    return FormBuilderValidators.compose([
      FormBuilderValidators.required(),
    ]);
  }
}
