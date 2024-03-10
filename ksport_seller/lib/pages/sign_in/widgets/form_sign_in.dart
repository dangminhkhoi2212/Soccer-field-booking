import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ksport_seller/services/service_google_auth.dart';
import 'package:line_icons/line_icon.dart';
import 'package:widget_component/my_library.dart';

class FromSignIn extends StatefulWidget {
  const FromSignIn({Key? key}) : super(key: key);

  @override
  State<FromSignIn> createState() => _FromSignInState();
}

class _FromSignInState extends State<FromSignIn> {
  final _formKey = GlobalKey<FormBuilderState>();

  Future<void> _signIn() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            color: MyColor.secondary,
          ),
        ),
      );
      _formKey.currentState!.save();
      final data = _formKey.currentState!.value;
      final errors = _formKey.currentState!.errors;
      if (errors.isNotEmpty) {
        return;
      }
      String? email = data['email'];
      String? password = data['password'];
      if (email == null || password == null) return;
      final response = await AuthService().signInWithEmailAndPassword(
        email: email.toString(),
        password: password,
      );
      final result = response.data;
      debugPrint(result.toString());

      if (response.statusCode == 200) {
        final bool isUpdatedAddress = result['isUpdatedAddress'];
        if (isUpdatedAddress == false) {
          final Position? position =
              await GoogleMapService().determinePosition();
          double lat = position!.latitude;
          double long = position.longitude;
          final String? address = await GoogleMapService()
              .getAddressFromLatLng(latitude: lat, longitude: long);

          debugPrint(address.toString());

          await AddressService().updateAddress(
              userID: result['_id'],
              lat: position.latitude,
              long: position.longitude,
              address: address);
        }

        AuthService().setUserLocal(result);
        await Get.offNamed(RoutePaths.mainScreen);
      } else {
        SnackbarUtil.getSnackBar(
          title: 'Sign in',
          message: result['err_mes'] ?? 'Occur an error. Please try again',
        );
      }
    } catch (e) {
      debugPrint('Error _signin: $e');
      SnackbarUtil.getSnackBar(
        title: 'Sign in',
        message: 'Occur an error. Please try again',
      );
    } finally {
      Navigator.of(context).pop(); // Close the dialog in all cases
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
              backgroundColor: MyColor.primary,
            ),
            onPressed: _signIn,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
