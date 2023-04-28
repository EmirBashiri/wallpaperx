import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_wallpaper_x/ViewModel/BusinessLogic/Repository/repository.dart';
import 'package:get/get.dart';

part 'root_event.dart';
part 'root_state.dart';

class RootBloc extends Bloc<RootEvent, RootState> {
  RootBloc() : super(RootInitial()) {
    final HomeBloc homeBloc = Get.context!.read<HomeBloc>();

    Future<void> rootStartConfiguration(
        {required Repository repository, required Emitter emit}) async {
      final List<WallpaperEntity> wallpaperList =
          await repository.getFeturedWallpaperList(
              page: defaultPageNumber, cacheKey: featuredWallpapersQuery);
      final List<WallpaperCollectionEntity> wallpaperCollections =
          await repository.getCollectionsCover(
              page: defaultPageNumber,
              category: featuredCollectionCategory,
              query: featuredCollectionsQuery,
              cacheKey: featuredCollectionsQuery,
              perPage: homeFeaturedCollectionCount,
              cacheMaxAge: homeCollectionCacheMaxAge);
      homeBloc.add(HomeSuccess(
          collectionList: wallpaperCollections, wallpaperList: wallpaperList));
      emit(RootMain());
    }

    on<RootEvent>((event, emit) async {
      if (event is RootStart) {
        emit(RootLoading());
        final index = event.currentIndex;
        final DuplicateController duplicateController = Get.find();
        final Repository repository = duplicateController.repository;
        try {
          switch (index) {
            case 0:
              await Future.delayed(const Duration(seconds: delayedSecond));
              await rootStartConfiguration(repository: repository, emit: emit);
              break;

            default:
              emit(RootMain());
              homeBloc.add(HomeUpdateState());
          }
        } catch (e) {
          homeBloc.add(HomeApiError());
          emit(RootMain());
        }
      }
    });
  }
}
