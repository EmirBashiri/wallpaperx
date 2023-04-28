import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return PageStorage(
      bucket: categoryBucket,
      child: Scaffold(
        backgroundColor: colorScheme.background,
        body: SafeArea(
          child: Padding(
            padding: defaultEdgeInsets.add(const EdgeInsets.only(top: 15)),
            child: ListView.builder(
              key: categoryPageStorageKey,
              physics: defaultScrollPhysics,
              itemCount: categoryImageList.length,
              itemBuilder: (context, index) {
                return _CategoryItem(index: index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.index});
  final int index;

  final EdgeInsetsGeometry categoryItemsMargin =
      const EdgeInsets.only(bottom: 2);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final DuplicateController duplicateController = Get.find();
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    final List<String> categoryNameList = [
      appLocalizations.exploreAnimals,
      appLocalizations.exploreFuturistic,
      appLocalizations.exploreCarVehicle,
      appLocalizations.exploreNature,
      appLocalizations.exploreSky,
      appLocalizations.exploreSpace,
      appLocalizations.exploreGame,
      appLocalizations.exploreTravel,
    ];
    return InkWell(
      onTap: () async {
        await duplicateController.categoryCollectionNavigation
            .goToCategoryCollectionScreen(
                collectionTerm: categoryRequestTerm[index],
                context: context,
                collectionName: categoryNameList[index]);
      },
      child: Container(
        margin: categoryItemsMargin,
        width: Get.width,
        height: categoryImageHeight,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                categoryImageList[index],
              ),
              fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: Text(
          categoryNameList[index],
          style: textTheme.bodyLarge!.copyWith(
            color: colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
