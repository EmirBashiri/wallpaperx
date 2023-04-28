import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/favorite.dart';
import 'package:get/get.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial()) {
    on<FavoriteEvent>((event, emit) async {
      if (event is FavoriteStart) {
        try {
          emit(FavoriteLoading());
          final DuplicateController duplicateController = Get.find();
          final FavoriteFunctions favoriteFunctions =
              duplicateController.favoriteFunctions;
          final List<WallpaperEntity> wallpaperList =
              await favoriteFunctions.getFavoriteAllWallpapers();
          if (wallpaperList.isNotEmpty) {
            emit(FavoriteSuccesScreen(wallpaperList: wallpaperList));
          } else {
            emit(FavoriteEmptyScreen());
          }
        } catch (e) {
          emit(FavoriteErrorScreen());
        }
      }
    });
  }
}
