import 'package:client_app/middlewares/router.dart';
import 'package:client_app/pages/edit_address/edit_address.dart';
import 'package:client_app/pages/edit_profile/edit_profile_page.dart';
import 'package:client_app/pages/home/home_page.dart';
import 'package:client_app/pages/main_screen.dart';
import 'package:client_app/pages/profile/profile_page.dart';
import 'package:client_app/pages/sign_up/sign_up_page.dart';
import 'package:client_app/pages/sign_in/sign_in.dart';
import 'package:client_app/routes/route_path.dart';
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
      'name': RoutePaths.user,
      'page': const UserPage(),
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
