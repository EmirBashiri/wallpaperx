import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    final DuplicateController duplicateController = Get.find();
    final Repository repository = duplicateController.repository;

    Future<void> homeMainConfiguration({required Emitter emit}) async {
      emit(HomeApiLoadingScreen());
      try {
        final List<WallpaperCollectionEntity> collectionList =
            await repository.getCollectionsCover(
                category: featuredCollectionCategory,
                query: featuredCollectionsQuery,
                page: defaultPageNumber,
                cacheKey: featuredCollectionsQuery,
                perPage: homeFeaturedCollectionCount);
        final List<WallpaperEntity> wallpaperList =
            await repository.getFeturedWallpaperList(page: defaultPageNumber);
        if (wallpaperList.isNotEmpty && collectionList.isNotEmpty) {
          emit(HomeSuccessScreen(
              collectionList: collectionList, wallpaperList: wallpaperList));
        } else {
          emit(HomeApiErrorScreen());
        }
      } catch (e) {
        emit(HomeApiErrorScreen());
      }
    }

    on<HomeEvent>((event, emit) async {
      if (event is HomeSuccess) {
        emit(
          HomeSuccessScreen(
            collectionList: event.collectionList,
            wallpaperList: event.wallpaperList,
          ),
        );
      } else if (event is HomeApiError) {
        emit(HomeApiErrorScreen());
      } else if (event is HomeTryAgain) {
        await homeMainConfiguration(emit: emit);
      } else if (event is HomeUpdateState) {
        await homeMainConfiguration(emit: emit);
      }
    });
  }
}
