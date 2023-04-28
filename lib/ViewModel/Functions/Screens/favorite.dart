import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:hive_flutter/adapters.dart';

class FavoriteFunctions {
  final String boxName = "FavoriteBox";

  Future<void> initDatabase() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WallpaperEntityAdapter());
  }

  Future<void> openFavoriteBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      final favoriteBox = await Hive.openBox<WallpaperEntity>(boxName);
      favoriteBox.listenable().addListener(() {});
    }
  }

  Future<void> closeFavoriteBoxes() async {
    if (Hive.isBoxOpen(boxName)) {
      final box = Hive.box<WallpaperEntity>(boxName);
      box.listenable().removeListener(() {});
      await box.close();
    }
  }

  Future<void> addToFavoriteBox({required WallpaperEntity wallpaper}) async {
    await openFavoriteBox();
    final favoriteBox = Hive.box<WallpaperEntity>(boxName);
    await favoriteBox.put(wallpaper.id, wallpaper);
  }

  Future<void> removeFromFavoriteBox(
      {required WallpaperEntity wallpaperEntity}) async {
    await openFavoriteBox();
    final favoriteBox = Hive.box<WallpaperEntity>(boxName);
    await favoriteBox.delete(wallpaperEntity.id);
  }

  Future<List<WallpaperEntity>> getFavoriteAllWallpapers() async {
    await openFavoriteBox();
    final List<WallpaperEntity> wallpaperList = [];
    final favoriteBox = Hive.box<WallpaperEntity>(boxName);
    final boxValues = favoriteBox.values.toList();
    wallpaperList.addAll(boxValues);
    return wallpaperList;
  }

  bool isInFavoritsBox({required WallpaperEntity wallpaperEntity}) {
    final favoriteBox = Hive.box<WallpaperEntity>(boxName);
    final wallpaersList = favoriteBox.values.toList();
    bool isInFavoriteBox;
    if (wallpaersList.isEmpty) {
      isInFavoriteBox = false;
    } else {
      isInFavoriteBox = wallpaersList.any((element) {
        if (element.id == wallpaperEntity.id) {
          return true;
        } else {
          return false;
        }
      });
    }
    return isInFavoriteBox;
  }
}
