import 'package:ksport_seller/middlewares/router.dart';
import 'package:ksport_seller/pages/add_field/add_field_page.dart';
import 'package:ksport_seller/pages/edit_address/edit_address.dart';
import 'package:ksport_seller/pages/edit_operating_time/edit_operating_time_page.dart';
import 'package:ksport_seller/pages/edit_profile/edit_profile_page.dart';
import 'package:ksport_seller/pages/fields/fields_page.dart';
import 'package:ksport_seller/pages/home.dart';
import 'package:ksport_seller/pages/main_screen.dart';
import 'package:ksport_seller/pages/sign_up/sign_up_page.dart';
import 'package:ksport_seller/pages/sign_in/sign_in_page.dart';
import 'package:ksport_seller/routes/route_path.dart';
import 'package:get/get.dart';

class GetRouter {
  static List pages = [
    {
      'name': RoutePaths.mainScreen,
      'page': const MainScreen(),
    },
    {
      'name': RoutePaths.home,
      'page': const HomePage(),
    },
    {
      'name': RoutePaths.signIn,
      'page': const SignInPage(),
    },
    {
      'name': RoutePaths.fields,
      'page': const FieldsPage(),
    },
    {
      'name': RoutePaths.editAddress,
      'page': const EditAddressPage(),
    },
    {
      'name': RoutePaths.editProfile,
      'page': const EditProfilePage(),
    },
    {
      'name': RoutePaths.editOperatingTime,
      'page': const EditOperatingTime(),
    },
    {
      'name': RoutePaths.addField,
      'page': const AddFieldPage(),
    },
    {
      'name': RoutePaths.signUp,
      'page': const SignUpPage(),
    },
  ];
  static final List<GetPage> routes = pages
      .map((page) => GetPage(
          name: page['name'],
          page: () => page['page'],
          middlewares: [RouterMiddleware()]))
      .toList();
}
