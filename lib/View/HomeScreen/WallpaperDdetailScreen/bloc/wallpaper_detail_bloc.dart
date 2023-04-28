import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/FavoriteScreen/bloc/favorite_bloc.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/favorite.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/wallpaper_detail.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Toast/toast.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_cropper/image_cropper.dart';

part 'wallpaper_detail_event.dart';
part 'wallpaper_detail_state.dart';

class WallpaperDetailBloc
    extends Bloc<WallpaperDetailEvent, WallpaperDetailState> {
  WallpaperDetailBloc() : super(WallpaperDetailInitial()) {
    on<WallpaperDetailEvent>(
      (event, emit) async {
        final DuplicateController duplicateController = Get.find();
        final FavoriteFunctions favoriteFunctions =
            duplicateController.favoriteFunctions;
        final WallpaperDetailFunctions wpDetailFunctions =
            duplicateController.wpDetailFunctions;
        final Repository repository = duplicateController.repository;
        final CustomToast customToast = duplicateController.customToast;
        final AppLocalizations appLocalizations =
            AppLocalizations.of(Get.context!)!;

        if (event is WallpaperDetialStart) {
          final bool isInFavoriteBox = favoriteFunctions.isInFavoritsBox(
              wallpaperEntity: event.wallpaperEntity);
          mainScreenEmit(
            emitter: emit,
            isInFavoriteBox: isInFavoriteBox,
          );
        } else if (event is WallpaperDetialAddToFavorite) {
          final WallpaperEntity wallpaperEntity = event.wallpaperEntity;
          final BuildContext context = event.context;
          bool isInFavoriteBox = favoriteFunctions.isInFavoritsBox(
              wallpaperEntity: wallpaperEntity);
          if (isInFavoriteBox) {
            await favoriteFunctions.removeFromFavoriteBox(
                wallpaperEntity: wallpaperEntity);
            updateFavoriteScreen(
                emitter: emit,
                favoriteFunctions: favoriteFunctions,
                wallpaperEntity: wallpaperEntity);
            if (context.mounted) {
              context.read<FavoriteBloc>().add(FavoriteStart());
            }
          } else {
            await favoriteFunctions.addToFavoriteBox(
                wallpaper: wallpaperEntity);
            updateFavoriteScreen(
                emitter: emit,
                favoriteFunctions: favoriteFunctions,
                wallpaperEntity: wallpaperEntity);
            if (context.mounted) {
              context.read<FavoriteBloc>().add(FavoriteStart());
            }
          }
        } else if (event is WallpaperDetialSave) {
          final bool isInFavoriteBox = favoriteFunctions.isInFavoritsBox(
              wallpaperEntity: event.wallpaperEntity);
          emit(WallpaperDetialLoading(isInFavoriteBox));
          final bool result = await wpDetailFunctions.saveImageInGallery(
              wallpaperEntity: event.wallpaperEntity, repository: repository);
          if (result) {
            emit(
              WallpaperDetialShowResult(
                  messagetitle: appLocalizations.wallpaperSavedMessage,
                  customToast: customToast),
            );
            mainScreenEmit(
              emitter: emit,
              isInFavoriteBox: isInFavoriteBox,
            );
          } else {
            emit(
              WallpaperDetialShowResult(
                  messagetitle: appLocalizations.unknownError,
                  customToast: customToast),
            );
            mainScreenEmit(
              emitter: emit,
              isInFavoriteBox: isInFavoriteBox,
            );
          }
        } else if (event is WallpaperDetialSet) {
          emit(SelecetWallpaperMode());
          mainScreenEmit(emitter: emit, isInFavoriteBox: event.isInFavoriteBox);
        } else if (event is SetImageAsWallpaper) {
          final WallpaperEntity wallpaperEntity = event.wallpaperEntity;
          final bool isInFavoriteBox = favoriteFunctions.isInFavoritsBox(
              wallpaperEntity: wallpaperEntity);
          final WallpaperMode wallpaperMode = event.wallpaperMode;
          emit(WallpaperDetialLoading(isInFavoriteBox));
          final bool result = await wpDetailFunctions.setImageAsWallpaper(
              repository: repository,
              wallpaperEntity: wallpaperEntity,
              wallpaperMode: wallpaperMode,
              androidUiSettings: event.androidCropStyle);
          if (result) {
            emit(
              WallpaperDetialShowResult(
                  messagetitle: appLocalizations.walpaperPictureSetMessage,
                  customToast: customToast),
            );
            mainScreenEmit(
              emitter: emit,
              isInFavoriteBox: isInFavoriteBox,
            );
          } else {
            emit(
              WallpaperDetialShowResult(
                  messagetitle: appLocalizations.unknownError,
                  customToast: customToast),
            );
            mainScreenEmit(
              emitter: emit,
              isInFavoriteBox: isInFavoriteBox,
            );
          }
        } else if (event is WallpaperLaunchUrlLink) {
          final String errorMessage = await wpDetailFunctions.launchUrlLink(
              urlLink: event.urlLink,
              errorMessage: appLocalizations.unknownError);
          if (errorMessage.isNotEmpty) {
            emit(
              WallpaperDetialShowResult(
                  messagetitle: errorMessage, customToast: customToast),
            );
            mainScreenEmit(
                emitter: emit, isInFavoriteBox: event.isInFavoriteBox);
          }
        }
      },
    );
  }
  void mainScreenEmit({
    required Emitter emitter,
    required bool isInFavoriteBox,
  }) {
    emitter(
      WallpaperDetialMainScreen(
        isInFavoriteBox: isInFavoriteBox,
      ),
    );
  }

  void updateFavoriteScreen(
      {required Emitter emitter,
      required FavoriteFunctions favoriteFunctions,
      required WallpaperEntity wallpaperEntity}) {
    final bool isInFavoriteBox =
        favoriteFunctions.isInFavoritsBox(wallpaperEntity: wallpaperEntity);
    mainScreenEmit(
      emitter: emitter,
      isInFavoriteBox: isInFavoriteBox,
    );
  }
}
