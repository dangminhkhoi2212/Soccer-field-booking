import 'package:client_app/firebase_options.dart';
import 'package:client_app/pages/main_screen/main_screen.dart';
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
      home: const MainScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: MyColor.background,
        colorSchemeSeed: PrimaryColor.primary,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide()),
          outlineBorder: const BorderSide(),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red.shade900),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      builder: (context, child) => SafeArea(child: child!),
    );
  }
}
