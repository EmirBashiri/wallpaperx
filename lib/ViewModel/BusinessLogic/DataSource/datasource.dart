import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';

abstract class DataSource {
  Future<List<WallpaperEntity>> getFeturedWallpaperList(
      {required int page,
      String? urlPath,
      int? perPage,
      ApiOrder? orderBy,
      String? cacheKey,
      Duration? cacheMaxAge});
  Future<List<WallpaperEntity>> searchWallpapers(
      {required String searchKeyWord});
  Future<List<WallpaperCollectionEntity>> getCollectionsCover({
    int? page,
    String? urlPath,
    required String category,
    required String query,
    int? perPage,
    ApiOrder? orderBy,
    String? cacheKey,
    Duration? cacheMaxAge,
  });
  Future<List<WallpaperEntity>> getCollectionWallpapers({
    required String collectionName,
    required String category,
    required int page,
    int? perPage,
    String? cacheKey,
    Duration? cacheMaxAge,
    ApiOrder? apiOrder,
  });
}
