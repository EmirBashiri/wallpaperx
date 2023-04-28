import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/WallpaperEntity/wallpaper_entity.dart';
import 'package:flutter_wallpaper_x/View/FavoriteScreen/bloc/favorite_bloc.dart';
import 'package:flutter_wallpaper_x/View/Widgets/widgets.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/favorite.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteScreen extends StatelessWidget {
  FavoriteScreen({super.key});

  final DuplicateController duplicateController = Get.find();

  late final FavoriteFunctions favoriteFunctions =
      duplicateController.favoriteFunctions;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return BlocBuilder<FavoriteBloc, FavoriteState>(
      builder: (context, state) {
        if (state is FavoriteLoading) {
          return const SimpleLoadingScreen();
        } else if (state is FavoriteSuccesScreen) {
          final List<WallpaperEntity> wallpaperList = state.wallpaperList;
          return FavoriteMainScreen(wallpaperList: wallpaperList);
        } else if (state is FavoriteEmptyScreen) {
          return FavoriteCustomEmptyScreen(
              appLocalizations: appLocalizations,
              duplicateController: duplicateController);
        } else if (state is FavoriteErrorScreen) {
          return DuplicateErrorScreen(
            callback: () => context.read<FavoriteBloc>().add(FavoriteStart()),
          );
        }
        return const SimpleLoadingScreen();
      },
    );
  }
}

class FavoriteCustomEmptyScreen extends StatelessWidget {
  const FavoriteCustomEmptyScreen({
    super.key,
    required this.appLocalizations,
    required this.duplicateController,
  });

  final AppLocalizations appLocalizations;
  final DuplicateController duplicateController;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: duplicateAppBar(
        automaticallyImplementLeading: false,
        colorScheme: colorScheme,
        textTheme: textTheme,
        title: appLocalizations.favoriteFavorits,
      ),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          children: [
            const Expanded(child: CustomLottie(path: emptyListLottie)),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: defaultPaddingValue, bottom: defaultPaddingValue),
                  child: Text(
                    appLocalizations.emptyFavoriteWallpapers,
                    style: textTheme.bodyMedium,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: defaultPaddingValue),
                  child: ElevatedButton(
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: defaultCircularRadius,
                    )),
                    onPressed: () async {
                      await duplicateController.topWPsNavigation
                          .goToTopWallpapersScreen(context: context);
                    },
                    child: Text(
                      appLocalizations.exploreExploreWallpapers,
                      style: textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteMainScreen extends StatelessWidget {
  const FavoriteMainScreen({super.key, required this.wallpaperList});
  final List<WallpaperEntity> wallpaperList;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorScheme.background,
      appBar: duplicateAppBar(
        automaticallyImplementLeading: false,
        colorScheme: colorScheme,
        textTheme: textTheme,
        title: appLocalizations.favoriteFavorits,
      ),
      body: Padding(
        padding: defaultEdgeInsets,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: defaultPaddingValue, bottom: defaultPaddingValue),
              child: Text(
                appLocalizations.favoriteWallpapers,
                style:
                    textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            WallpapersGridView(wallpaperList: wallpaperList),
          ],
        ),
      ),
    );
  }
}
