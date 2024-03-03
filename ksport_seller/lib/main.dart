import 'package:ksport_seller/firebase_options.dart';
import 'package:ksport_seller/routes/get_route.dart';
import 'package:ksport_seller/routes/route_path.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:widget_component/const/colors.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
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
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.green,
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
            )),
      ),
    );
  }
}
