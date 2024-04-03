// import 'package:ksport_seller/pages/profile/widgets/appbar_profile.dart';
// import 'package:ksport_seller/pages/profile/widgets/avatar_user.dart';
// import 'package:ksport_seller/pages/profile/widgets/drawer_profile.dart';
// import 'package:ksport_seller/pages/profile/widgets/info_user.dart';
// import 'package:flutter/material.dart';
// import 'package:widget_component/my_library.dart';
// import 'package:get/get.dart';

// class UserPage extends StatefulWidget {
//   const UserPage({super.key});

//   @override
//   UserState createState() => UserState();
// }

// class UserState extends State<UserPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       endDrawer: const DrawerProfile(),
//       appBar: const PreferredSize(
//           preferredSize: Size.fromHeight(60.0), child: AppBarProfile()),
//       body: Column(
//         children: [
//           const AvatarUser(),
//           const SizedBox(height: 10),
//           const InfoUser(),
//           const SizedBox(height: 10),
//           InkWell(
//             borderRadius: BorderRadius.circular(8),
//             onTap: () {
//               Get.toNamed(RoutePaths.editProfile);
//             },
//             child: Ink(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(8),

//                 // color: Colors.white,
//               ),
//               child: const Text('Edit profile'),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
// import 'package:client_app/pages/seller/widget/field_list.dart';
// import 'package:client_app/pages/seller/widget/owner_info.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:ksport_seller/pages/profile/widgets/appbar_profile.dart';
import 'package:ksport_seller/pages/profile/widgets/drawer_profile.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userID;
  String _titleBar = '';
  final _box = GetStorage();
  final Logger _logger = Logger();
  bool _isLoading = false;
  final UserService _userService = UserService();
  final SellerService _sellerService = SellerService();
  final AddressService _addressService = AddressService();
  UserModel? _user;
  SellerModel? _seller;
  AddressModel? _address;
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _initValue();
  }

  Future _getUser() async {
    try {
      Response? response = await _userService.getOneUser(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _user = UserModel.fromJson(data);
        _titleBar = _user?.name ?? '';
      }
    } catch (e) {
      _logger.e(error: e, '_getUser');
    }
  }

  Future _getSeller() async {
    try {
      Response? response = await _sellerService.getOneSeller(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;
        _seller = SellerModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getSeller');
    }
  }

  Future _getAddress() async {
    try {
      Response? response = await _addressService.getAddress(userID: _userID);
      if (response!.statusCode == 200) {
        final data = response.data;

        _address = AddressModel.fromJson(data);
      }
    } catch (e) {
      _logger.e(error: e, '_getAddress');
    }
  }

  Future _initValue() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([_getAddress(), _getUser(), _getSeller()]);
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: MyLoading.spinkit(),
      );
    }
    if (_user == null) {
      return const Center(
        child: Text('Don not find this owner'),
      );
    }
    return Column(
      children: [
        InfoOwner(
          user: _user!,
          seller: _seller!,
          address: _address!,
        ), // Removed Expanded wrapper
        const SizedBox(height: 20), // Added spacing between widgets
        SoccerFieldList(
          userID: _user!.sId ?? '',
        ), // Removed Expanded wrapper
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        endDrawer: const DrawerProfile(),
        backgroundColor: MyColor.background,
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(60.0), child: AppBarProfile()),
        body: Container(
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
                clipBehavior: Clip.hardEdge,
                primary: true,
                child: _buildBody())));
  }
}
