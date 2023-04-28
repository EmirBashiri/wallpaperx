import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'collection_wallpaper_event.dart';
part 'collection_wallpaper_state.dart';

class CollectionWallpaperBloc
    extends Bloc<CollectionWallpaperEvent, CollectionWallpaperState> {
  CollectionWallpaperBloc() : super(CollectionWallpaperInitial()) {
    on<CollectionWallpaperEvent>((event, emit) async {
      if (event is CollectionWallpapersStart) {
        try {
          emit(CollectionWallpapersLoading());
          final DuplicateController duplicateController = Get.find();
          final Repository repository = duplicateController.repository;
          final int pageNumber = event.pageNumber + 2;
          final List<WallpaperEntity> wallpaperList =
              await repository.getCollectionWallpapers(
                  collectionName: event.collectionName,
                  category: event.category,
                  page: pageNumber,
                  cacheKey: "${event.collectionName}$pageNumber");
          emit(CollectionWallpapersSuccess(wallpaperList));
        } catch (e) {
          emit(CollectionWallpapersError());
        }
      }
    });
  }
}
