import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CategoryScreen/CategoryCollectionScreen/category_collection_screen.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CollectionWallpapers/collection_wp_screen.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/TopWallpapers/top_wp_screen.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/WallpaperDdetailScreen/wp_detail_screen.dart';
import 'package:flutter_wallpaper_x/View/SettingScreen/LanguageSelectionScreen/language_screen.dart';
import 'package:flutter_wallpaper_x/View/SettingScreen/ThemeSelectionScreen/themes_screen.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/LocalizationFunctions/localization.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/ThemeFunctions/theme.dart';
import 'package:page_transition/page_transition.dart';

const PageTransitionType _transitionType = PageTransitionType.size;
const Alignment _alignment = Alignment.center;
const Duration _duration = Duration(milliseconds: 500);

class WallpaperDetailNavigation {
  Map argumentsMap({required WallpaperEntity wallpaper}) {
    return {
      "coverLink": wallpaper.coverLink,
      "id": wallpaper.id,
      "viewLink": wallpaper.viewLink,
      "downloadLink": wallpaper.downloadLink,
      "photographerProfileLink": wallpaper.photographerProfileLink,
    };
  }

  @pragma('vm:entry-point')
  static Route wallpaperScreenRoute(BuildContext context, Object? argumants) {
    final argu = argumants! as Map;
    return PageTransition(
        child: WallpaperDetail(
          wallpaperEntity: WallpaperEntity(
              coverLink: argu["coverLink"],
              id: argu["id"],
              viewLink: argu["viewLink"],
              downloadLink: argu["downloadLink"],
              photographerProfileLink: argu["photographerProfileLink"]),
        ),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToWallpaperDetailScreen({
    required BuildContext context,
    required WallpaperEntity wallpaperEntity,
  }) async {
    Navigator.restorablePush(
      context,
      wallpaperScreenRoute,
      arguments: argumentsMap(wallpaper: wallpaperEntity),
    );
  }
}

class CategoryCollectionNavigation {
  static const String _term = "term";
  static const String _name = "name";
  Map<String, String> _arguments(
      {required String collectionTerm, required String collectionName}) {
    return {_term: collectionTerm, _name: collectionName};
  }

  @pragma('vm:entry-point')
  static Route categoryCollectionRoute(
      BuildContext context, Object? arguments) {
    final Map argument = arguments as Map;
    return PageTransition(
        child: CategoryCollectionScreen(
          collectionTerm: argument[_term],
          collectionName: argument[_name],
        ),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToCategoryCollectionScreen(
      {required BuildContext context,
      required String collectionTerm,
      required String collectionName}) async {
    Navigator.restorablePush(
      context,
      categoryCollectionRoute,
      arguments: _arguments(
        collectionTerm: collectionTerm,
        collectionName: collectionName,
      ),
    );
  }
}

class CollectionWallpapersNavigation {
  Map argumentsMap(CollectionWParameters parameters) {
    return {
      "pageNumber": parameters.pageNumber,
      "category": parameters.category,
      "collectionName": parameters.collectionName,
      "title": parameters.title
    };
  }

  @pragma('vm:entry-point')
  static Route wallpapersScreenRoute(BuildContext context, Object? arguments) {
    final argu = arguments as Map;
    return PageTransition(
        child: CollectionWallpapers(
          collectionWParguments: CollectionWParameters(
              category: argu["category"],
              collectionName: argu["collectionName"],
              pageNumber: argu["pageNumber"],
              title: argu["title"]),
        ),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToWallpapersScreen(
      {required BuildContext context,
      required CollectionWParameters parameters}) async {
    Navigator.restorablePush(
      context,
      wallpapersScreenRoute,
      arguments: argumentsMap(parameters),
    );
  }
}

class TopWallpapersNavigation {
  @pragma('vm:entry-point')
  static Route topWallpapersRoute(BuildContext context, Object? arguments) {
    return PageTransition(
        child: const TopWallpapersScreen(),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToTopWallpapersScreen({required BuildContext context}) async {
    Navigator.restorablePush(
      context,
      topWallpapersRoute,
    );
  }
}

class ThemeSelectionNavigation {
  @pragma('vm:entry-point')
  static Route themeScreenRoute(BuildContext context, Object? arguments) {
    final CustomThemeMode customThemeMode = CustomThemeMode.values
        .firstWhere((element) => element.name == (arguments! as String));
    return PageTransition(
        child: ThemeSelectionScreen(
          customThemeMode: customThemeMode,
        ),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToThemeSelectionScreen(
      {required BuildContext context,
      required ThemeFunctions themeFunctions}) async {
    final CustomThemeMode customThemeMode = await themeFunctions.getThemeMode();
    if (context.mounted) {
      Navigator.restorablePush(context, themeScreenRoute,
          arguments: customThemeMode.name);
    }
  }
}

class LanguageSelectionNavigation {
  @pragma('vm:entry-point')
  static Route languageScreenRoute(BuildContext context, Object? arguments) {
    final Locale appLocale = Locale(arguments! as String);
    return PageTransition(
        child: LanguageScreen(appLocalel: appLocale),
        type: _transitionType,
        alignment: _alignment,
        duration: _duration);
  }

  Future<void> goToLanguageScreen(
      {required BuildContext context,
      required LocalizationFunctions localizationFunctions}) async {
    final Locale locale = await localizationFunctions.getLocale();
    if (context.mounted) {
      Navigator.restorablePush(
        context,
        languageScreenRoute,
        arguments: locale.languageCode,
      );
    }
  }
}
