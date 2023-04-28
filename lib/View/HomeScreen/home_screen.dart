import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CategoryScreen/category_screen.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/CollectionWallpapers/collection_wp_screen.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:get/get.dart';

import 'bloc/home_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  final DuplicateController duplicateController = Get.find();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    super.build(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeApiLoadingScreen) {
          return const SimpleLoadingScreen();
        } else if (state is HomeSuccessScreen) {
          return HomeMainScreen(
              wallpaperCollections: state.collectionList,
              wallpaperList: state.wallpaperList);
        } else if (state is HomeApiErrorScreen) {
          return ApiErrorScreen(
            duplicateErrorScreen: DuplicateErrorScreen(
              errorMessage: appLocalizations.homeTryAgain,
              callback: () {
                context.read<HomeBloc>().add(HomeTryAgain());
              },
            ),
          );
        } else {
          return const SimpleLoadingScreen();
        }
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomeMainScreen extends StatelessWidget {
  const HomeMainScreen({
    super.key,
    required this.wallpaperCollections,
    required this.wallpaperList,
  });

  final List<WallpaperCollectionEntity> wallpaperCollections;
  final List<WallpaperEntity> wallpaperList;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final InitialController initialController = Get.find();
    return DefaultTabController(
      initialIndex: initialController.tapIndex.value,
      length: tapBarLength,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorScheme.background,
          elevation: defaultElevation,
          centerTitle: true,
          title: Text(
            appLocalization.appName,
            style: textTheme.bodyLarge,
          ),
          bottom: TabBar(
            onTap: (value) {
              initialController.tapIndex.value = value;
            },
            indicatorColor: colorScheme.secondary,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                child: Text(
                  appLocalization.homeHome.toUpperCase(),
                  style: textTheme.bodyMedium,
                ),
              ),
              Tab(
                child: Text(
                  appLocalization.homeCategories.toUpperCase(),
                  style: textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(physics: rootScrollPhysics, children: [
          HomeMainItem(
            collectionList: wallpaperCollections,
            wallpaperList: wallpaperList,
          ),
          const CategoryScreen()
        ]),
      ),
    );
  }
}

class HomeFeaturedCollection extends StatelessWidget {
  HomeFeaturedCollection({
    super.key,
    required this.wallpaperCollections,
    required this.posterSize,
  });

  final List<WallpaperCollectionEntity> wallpaperCollections;
  final double posterSize;
  final DuplicateController duplicateController = Get.find();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    return Expanded(
      flex: collectionFlex(),
      child: ListView.builder(
        physics: defaultScrollPhysics,
        scrollDirection: Axis.horizontal,
        itemCount: wallpaperCollections.length,
        itemBuilder: (context, index) {
          final WallpaperCollectionEntity collectionEntity =
              wallpaperCollections[index];
          return CollectionItem(
              cahceMaxAge: homeCollectionCacheMaxAge,
              callback: () async {
                await duplicateController.collectionWPsNavigation
                    .goToWallpapersScreen(
                  context: context,
                  parameters: CollectionWParameters(
                    category: featuredCollectionCategory,
                    collectionName: featuredCollectionsQuery,
                    pageNumber: index,
                    title: topWallpapersTitle(
                        appLocalization: appLocalization, index: index),
                  ),
                );
              },
              collection: collectionEntity,
              posterHeight: posterSize,
              posterWidth: posterSize,
              title:
                  "${appLocalization.homeCollection} ${romanNumerals[index]}");
        },
      ),
    );
  }
}

class ApiErrorScreen extends StatelessWidget {
  const ApiErrorScreen({super.key, required this.duplicateErrorScreen});
  final DuplicateErrorScreen duplicateErrorScreen;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: duplicateAppBar(
          automaticallyImplementLeading: false,
          colorScheme: colorScheme,
          textTheme: textTheme,
          title: appLocalizations.appName),
      body: duplicateErrorScreen,
    );
  }
}

class HomeMainItem extends StatelessWidget {
  HomeMainItem(
      {super.key, required this.collectionList, required this.wallpaperList});
  final List<WallpaperCollectionEntity> collectionList;
  final List<WallpaperEntity> wallpaperList;
  final double collectionPosterSize = posterSize();
  final DuplicateController duplicateController = Get.find();
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    return Padding(
      padding: defaultEdgeInsets,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: defaultPaddingValue, bottom: defaultPaddingValue),
            child: Text(
              appLocalization.homeFeatured,
              style: textTheme.bodyLarge,
            ),
          ),
          HomeFeaturedCollection(
            wallpaperCollections: collectionList,
            posterSize: collectionPosterSize,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  appLocalization.homeTopWallpaper,
                  style: textTheme.bodyLarge!.copyWith(fontSize: 20),
                ),
                customButton(
                    callback: () async {
                      await duplicateController.topWPsNavigation
                          .goToTopWallpapersScreen(context: context);
                    },
                    colorScheme: colorScheme,
                    textStyle: textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    title: appLocalization.homeSeeMore),
              ],
            ),
          ),
          WallpapersGridView(wallpaperList: wallpaperList)
        ],
      ),
    );
  }
}
