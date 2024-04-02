import 'package:ksport_seller/pages/sign_in/widgets/form_sign_in.dart';
import 'package:ksport_seller/store/store_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:widget_component/my_library.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final StoreUser storeUser = Get.put(StoreUser());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil.getWidth(context) * .05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'KSport Seller',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/images/login.png'),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Soccer field booking',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  "Let's get started ",
                  style: TextStyle(fontSize: 20, color: Colors.black87),
                ),
                const SizedBox(
                  height: 10,
                ),
                const FromSignIn(),
                const SizedBox(
                  height: 20,
                ),
                // const Row(
                //   children: [
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey,
                //         height: 12,
                //       ),
                //     ),
                //     Text(' OR '),
                //     Expanded(
                //       child: Divider(
                //         color: Colors.grey,
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(
                //   height: 10,
                // ),
                // GestureDetector(
                //   onTap: () {
                //     _login(context);
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(vertical: 15),
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.black),
                //       borderRadius: BorderRadius.circular(50),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: [
                //         SizedBox(
                //           height: 20,
                //           width: 20,
                //           child: Image.asset('assets/images/google_logo.png'),
                //         ),
                //         const SizedBox(
                //           width: 20,
                //         ),
                //         const Text(
                //           'Sign in with Google',
                //           style: TextStyle(
                //             fontSize: 20,
                //             color: Colors.black87,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Get.toNamed(RoutePaths.signUp);
                        },
                        child: const Text(
                          'Sign up here',
                          style: TextStyle(color: MyColor.primary),
                        ),
                      ),
                    ],
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
