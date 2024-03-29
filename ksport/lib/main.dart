import 'package:client_app/firebase_options.dart';
import 'package:client_app/pages/home/home_page.dart';
import 'package:client_app/routes/get_route.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widget_component/my_library.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: GetRouter.routes,
      initialRoute: RoutePaths.mainScreen,
      home: const HomePage(),
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.green,
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            side: MaterialStatePropertyAll(
                BorderSide(color: Colors.grey.shade500, width: 1)),
            backgroundColor: const MaterialStatePropertyAll(Colors.white),
            textStyle: const MaterialStatePropertyAll<TextStyle>(
              TextStyle(
                color: MyColor.primary,
              ),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: MyColor.primary,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            labelStyle: const TextStyle(
              color: Colors.black87,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.red.shade900,
              ),
            )),
      ),
      builder: (context, child) => SafeArea(child: child!),
    );
  }
}
