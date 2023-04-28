import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/DataSource/datasource.dart';
import 'package:flutter_wallpaper_x/ViewModel/RequestPackage/request_package.dart';

class Repository extends DataSource {
  final RequestPackage requestPackage;

  Repository(this.requestPackage);

  @override
  Future<List<WallpaperEntity>> getFeturedWallpaperList(
          {required int page,
          String? urlPath,
          int? perPage,
          ApiOrder? orderBy,
          String? cacheKey,
          Duration? cacheMaxAge}) =>
      requestPackage.getFeaturedWallpaperList(
          page: page,
          cacheKey: cacheKey,
          urlPath: urlPath,
          cacheMaxAge: cacheMaxAge);

  @override
  Future<List<WallpaperEntity>> getCollectionWallpapers(
          {required String collectionName,
          required String category,
          required int page,
          int? perPage,
          String? cacheKey,
          Duration? cacheMaxAge,
          ApiOrder? apiOrder}) =>
      requestPackage.getCollectionWallpapers(
          collectionName: collectionName,
          page: page,
          cacheKey: cacheKey,
          cacheMaxAge: cacheMaxAge,
          apiOrder: apiOrder);

  @override
  Future<List<WallpaperEntity>> searchWallpapers(
          {required String searchKeyWord}) =>
      requestPackage.searchWallpapers(searchKeyword: searchKeyWord);

  @override
  Future<List<WallpaperCollectionEntity>> getCollectionsCover(
          {int? page,
          String? urlPath,
          required String category,
          required String query,
          int? perPage,
          ApiOrder? orderBy,
          String? cacheKey,
          Duration? cacheMaxAge}) =>
      requestPackage.getCollectionsCover(
        page: page,
        query: query,
        orderBy: orderBy,
        urlPath: urlPath,
        cacheKey: cacheKey,
        cacheMaxAge: cacheMaxAge,
      );
}
