import 'package:ksport_seller/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ksport_seller/pages/main_screen/main_screen.dart';
import 'package:ksport_seller/routes/get_route.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:widget_component/my_library.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      theme: ThemeData(
        scaffoldBackgroundColor: MyColor.background,
        colorSchemeSeed: PrimaryColor.primary,
      ),
      initialRoute: RoutePaths.mainScreen,
      home: const MainScreen(),
      localizationsDelegates: const [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      builder: (context, child) => SafeArea(child: child!),
    );
  }
}
