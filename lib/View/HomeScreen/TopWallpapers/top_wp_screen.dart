import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/Icons/icons.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/top_wallpapers.dart';
import 'package:get/get.dart';

import 'bloc/top_wallpapers_bloc.dart';

class TopWallpapersScreen extends StatefulWidget {
  const TopWallpapersScreen({super.key});

  @override
  State<TopWallpapersScreen> createState() => _TopWallpapersScreenState();
}

class _TopWallpapersScreenState extends State<TopWallpapersScreen> {
  TopWallpapersBloc? topWallpapersBloc;
  final InitialController initialController = Get.find();
  final DuplicateController duplicateController = Get.find();
  final ScrollController scrollController = ScrollController();
  StreamSubscription? subscription;
  late TopWallpapersFunctions topWallpapersFunctions =
      duplicateController.topWallpapersFunctions;
  bool isInlineError = false;

  void emitTowWallpapersStart({required TopWallpapersBloc topWallpapersBloc}) {
    topWallpapersBloc.add(TopWallpapersStart());
  }

  Future<void> customDispose() async {
    topWallpapersFunctions.isInlineLoading = false;
    topWallpapersFunctions.pageNumber = 1;
    scrollController.dispose();
    await topWallpapersBloc?.close();
    await subscription?.cancel();
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = TopWallpapersBloc();
        emitTowWallpapersStart(topWallpapersBloc: bloc);
        topWallpapersBloc = bloc;
        subscription = bloc.stream.listen((state) {
          if (state is TopWallpapersSuccess) {
            topWallpapersFunctions.scrollControllerListeners(
                scrollController: scrollController,
                initialController: initialController,
                topWallpapersBloc: topWallpapersBloc!,
                wallpaperList: state.wallpaperList);
          } else if (state is TopWallpaperInlineLoading) {
            topWallpapersFunctions.isInlineLoading = state.isInlineLoading;
          } else if (state is TopWallpaperInlineError) {
            isInlineError = state.isInlineError;
          }
        });
        return bloc;
      },
      child: BlocBuilder<TopWallpapersBloc, TopWallpapersState>(
        builder: (context, state) {
          if (state is TopWallpaperStateLoading) {
            return const SimpleLoadingScreen();
          } else if (state is TopWallpapersSuccess) {
            final List<WallpaperEntity> wallpaperList = state.wallpaperList;
            return TopWallpapersMainScreen(
              scrollController: scrollController,
              wallpaperList: wallpaperList,
              isInlineLoading: topWallpapersFunctions.isInlineLoading,
              isInlineError: isInlineError,
              topWallpapersBloc: topWallpapersBloc,
              pageNumber: topWallpapersFunctions.pageNumber,
            );
          } else if (state is TopWallpaperStateError) {
            return DuplicateErrorScreen(
              callback: () =>
                  emitTowWallpapersStart(topWallpapersBloc: topWallpapersBloc!),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class TopWallpapersMainScreen extends StatelessWidget {
  TopWallpapersMainScreen({
    super.key,
    required this.scrollController,
    required this.wallpaperList,
    required this.isInlineLoading,
    required this.isInlineError,
    required this.topWallpapersBloc,
    required this.pageNumber,
  });

  final ScrollController scrollController;
  final List<WallpaperEntity> wallpaperList;
  final bool isInlineLoading;
  final bool isInlineError;
  final TopWallpapersBloc? topWallpapersBloc;
  final int pageNumber;
  final DuplicateController duplicateController =
      Get.find<DuplicateController>();
  late final CustomIcons customIcons = duplicateController.customIcons;
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: wallpapersScreensAppBar(
          title: appLocalizations.homeTopWallpaper,
          colorScheme: colorScheme,
          textTheme: textTheme),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WallpapersScreensTitle(title: appLocalizations.homeWallpapers),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: MasonryGridView.builder(
                      padding: defaultItemPadding,
                      physics: const ClampingScrollPhysics(),
                      controller: scrollController,
                      gridDelegate:
                          const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount),
                      mainAxisSpacing: mainAxisSpacing,
                      crossAxisSpacing: crossAxisSpacing,
                      itemCount: wallpaperList.length,
                      itemBuilder: (context, index) {
                        final wallpaper = wallpaperList[index];
                        return GestureDetector(
                          onTap: () async {
                            await duplicateController.wallpaperDetailNavigation
                                .goToWallpaperDetailScreen(
                              context: context,
                              wallpaperEntity: wallpaper,
                            );
                          },
                          child: GridViewCachedImage(
                            cacheMaxAge: defaultCacheMaxAge,
                            url: wallpaper.coverLink,
                            width: wallpaperGridWith,
                            boxFit: BoxFit.cover,
                            height: wallpaperGridHeght(index: index),
                          ),
                        );
                      },
                    ),
                  ),
                  if (isInlineLoading || isInlineError)
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      child: isInlineError
                          ? GestureDetector(
                              onTap: () {
                                topWallpapersBloc!.add(TopWallpapersItem(
                                    wallpaperList: wallpaperList,
                                    pageNumber: pageNumber));
                              },
                              child: Icon(
                                customIcons.loadErrorIcon,
                                size: defaultIconSize,
                                color: colorScheme.secondary,
                              ),
                            )
                          : CustomLoading(color: colorScheme.secondary),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
