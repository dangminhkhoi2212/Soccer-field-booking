import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/seller/seller_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import 'package:line_icons/line_icon.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FavoriteCard extends StatefulWidget {
  final FavoriteModel favorite;
  const FavoriteCard({super.key, required this.favorite});

  @override
  State<FavoriteCard> createState() => _FavoriteListState();
}

class _FavoriteListState extends State<FavoriteCard> {
  late FavoriteModel _favorite;
  final _logger = Logger();
  final GetStorage _box = GetStorage();
  final ApiConfig _apiConfig = ApiConfig();
  late FavoriteService _favoriteService;
  late String _userID;
  late bool _isFavorite = true;
  @override
  void initState() {
    super.initState();
    _userID = _box.read('id');
    _favorite = widget.favorite;

    _favoriteService = FavoriteService(_apiConfig.dio);
  }

  Future _handleFavorite() async {
    try {
      final Response response = await _favoriteService.handelFavorite(
          userID: _userID, sellerID: _favorite.sId!);
      if (response.statusCode == 200) {
        final FavoriteStatusModel data =
            FavoriteStatusModel.fromJson(response.data);
        setState(() {
          _isFavorite = data.isFavorite!;
        });
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_checkFavorite',
            messageDebug: e.response!.data ?? e.message);
      }
    } catch (e) {
      _logger.e(e, error: '_checkFavorite');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(RoutePaths.seller,
            parameters: {'userIDSeller': _favorite.sId!});
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                MyImage(
                  width: 60,
                  height: 60,
                  src: _favorite.avatar!,
                  isAvatar: true,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _favorite.name!,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${_favorite.followers} followers',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  _handleFavorite();
                },
                icon: _isFavorite == true
                    ? const LineIcon.heartAlt(color: Colors.red)
                    : const LineIcon.heart(
                        color: Colors.black,
                      ))
          ],
        ),
      ),
    );
  }
}
