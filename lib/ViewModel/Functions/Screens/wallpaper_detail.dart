import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:async_wallpaper/async_wallpaper.dart';
import 'package:url_launcher/url_launcher.dart';

class WallpaperDetailFunctions {
  Future<bool> saveImageInGallery(
      {required WallpaperEntity wallpaperEntity,
      required Repository repository}) async {
    try {
      File? cachedImage;
      final Uint8List imageBytes;
      cachedImage = await getCachedImageFile(wallpaperEntity.viewLink);
      // when wallpaper download link is cached this part is called.
      if (cachedImage != null && await cachedImage.exists()) {
        imageBytes = await cachedImage.readAsBytes();
        await ImageGallerySaver.saveImage(imageBytes, name: applicationName);
        return true;
      }
      // when wallpaper download link is not cached anymore this part is called.
      else {
        cachedImage =
            await DefaultCacheManager().getSingleFile(wallpaperEntity.viewLink);
        imageBytes = await cachedImage.readAsBytes();
        await ImageGallerySaver.saveImage(imageBytes, name: applicationName);
        await cachedImage.delete(recursive: true);
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> setImageAsWallpaper(
      {required Repository repository,
      required WallpaperEntity wallpaperEntity,
      required WallpaperMode wallpaperMode,
      required AndroidUiSettings androidUiSettings}) async {
    try {
      bool result;

      File? cachedImage =
          await getCachedImageFile(wallpaperEntity.downloadLink);

      // when wallpaper download link is cached this function is called
      if (cachedImage != null && await cachedImage.exists()) {
        result = await _cropImage(
            imageFilePath: cachedImage.path,
            androidUiSettings: androidUiSettings,
            wallpaperMode: wallpaperMode);
        return result;
      }
      // when wallpaper download link is not cached anymore this function is called
      else {
        cachedImage = await DefaultCacheManager()
            .getSingleFile(wallpaperEntity.downloadLink);
        result = await _cropImage(
            imageFilePath: cachedImage.path,
            androidUiSettings: androidUiSettings,
            wallpaperMode: wallpaperMode);
        await cachedImage.delete(recursive: true);
        return result;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> launchUrlLink(
      {required String urlLink, required String errorMessage}) async {
    try {
      await launchUrl(Uri.parse(urlLink), mode: LaunchMode.externalApplication);
      return "";
    } catch (e) {
      return errorMessage;
    }
  }

  // here is image crop functionality
  Future<bool> _cropImage(
      {required String imageFilePath,
      required AndroidUiSettings androidUiSettings,
      required WallpaperMode wallpaperMode}) async {
    bool result;
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFilePath,
      aspectRatio: cropAspectRatio,
      compressFormat: compressFormat,
      compressQuality: compressQuality,
      uiSettings: [androidUiSettings],
    );
    if (croppedFile != null) {
      result = await _setWallpaper(
          wallpaperMode: wallpaperMode, imageFile: croppedFile);
    } else {
      result = false;
    }
    return result;
  }
  
  // here wallpaper seting functionality
  Future<bool> _setWallpaper(
      {required WallpaperMode wallpaperMode,
      required CroppedFile imageFile}) async {
    switch (wallpaperMode) {
      case WallpaperMode.homeScreen:
        return await AsyncWallpaper.setWallpaperFromFile(
          filePath: imageFile.path,
          wallpaperLocation: AsyncWallpaper.HOME_SCREEN,
        );

      case WallpaperMode.lockScreen:
        return await AsyncWallpaper.setWallpaperFromFile(
          filePath: imageFile.path,
          wallpaperLocation: AsyncWallpaper.LOCK_SCREEN,
        );

      case WallpaperMode.bothScreen:
        return await AsyncWallpaper.setWallpaperFromFile(
          filePath: imageFile.path,
          wallpaperLocation: AsyncWallpaper.BOTH_SCREENS,
        );
    }
  }
}
