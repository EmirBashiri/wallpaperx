import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'top_wallpapers_event.dart';
part 'top_wallpapers_state.dart';

class TopWallpapersBloc extends Bloc<TopWallpapersEvent, TopWallpapersState> {
  TopWallpapersBloc() : super(TopWallpapersInitial()) {
    on<TopWallpapersEvent>((event, emit) async {
      final DuplicateController duplicateController = Get.find();
      final Repository repository = duplicateController.repository;

      if (event is TopWallpapersStart) {
        try {
          emit(TopWallpaperStateLoading());
          final List<WallpaperEntity> wallpaperList =
              await repository.getFeturedWallpaperList(page: defaultPageNumber);
          emit(
            TopWallpapersSuccess(wallpaperList: wallpaperList),
          );
        } catch (e) {
          emit(TopWallpaperStateError());
        }
      } else if (event is TopWallpapersItem) {
        try {
          emit(TopWallpaperInlineError(false));
          emit(
            TopWallpapersSuccess(wallpaperList: event.wallpaperList),
          );
          final wallpaperList = event.wallpaperList;
          final pageNumber = event.pageNumber;
          final newWallpaperList = await repository.getFeturedWallpaperList(
              page: pageNumber,
              cacheKey: "$featuredWallpapersQuery${pageNumber.toString()}");
          wallpaperList.addAll(newWallpaperList);
          emit(TopWallpaperInlineLoading(false));
          emit(
            TopWallpapersSuccess(wallpaperList: wallpaperList),
          );
        } catch (e) {
          emit(TopWallpaperInlineError(true));
          emit(
            TopWallpapersSuccess(wallpaperList: event.wallpaperList),
          );
        }
      }
    });
  }
}
