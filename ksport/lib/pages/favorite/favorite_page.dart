import 'package:client_app/config/api_config.dart';
import 'package:client_app/pages/favorite/widget/favorite_card.dart';
import 'package:client_app/pages/favorite/widget/filter_seller_list.dart';
import 'package:dio/dio.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';
import 'package:widget_component/my_library.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _box = GetStorage();
  final ApiConfig _apiConfig = ApiConfig();
  late FavoriteService _favoriteService;
  late String _userID;
  final _logger = Logger();
  final List<FavoriteModel?> _favorites = [];
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    _userID = _box.read('id');
    _favoriteService = FavoriteService(_apiConfig.dio);
    _getFavorites();
  }

  Future _getFavorites() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Response response = await _favoriteService.getFavorites(userID: _userID);
      if (response.statusCode == 200) {
        for (dynamic item in response.data) {
          _favorites.add(FavoriteModel.fromJson(item));
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        HandleError(
            titleDebug: '_getFavorites',
            messageDebug: e.response!.data['err_mes'] ?? e ?? e);
      }
    } catch (e) {
      _logger.e(e, error: '_getFavorites');
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _buildFavoriteList() {
    if (_favorites.isEmpty) {
      return EmptyWidget(
        packageImage: PackageImage.Image_2,
        hideBackgroundAnimation: true,
        title: 'Follow is empty',
      );
    }
    return ListView.separated(
        itemBuilder: (context, index) =>
            FavoriteCard(favorite: _favorites[index]!),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: _favorites.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite'),
      ),
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // const FilterFavorite(),
            const SizedBox(
              height: 5,
            ),
            Expanded(child: _buildFavoriteList()),
          ],
        ),
      ),
    );
  }
}
