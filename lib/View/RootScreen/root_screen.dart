import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/navigation_controller.dart';
import 'package:flutter_wallpaper_x/View/FavoriteScreen/bloc/favorite_bloc.dart';
import 'package:flutter_wallpaper_x/View/FavoriteScreen/favorite_screen.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/home_screen.dart';
import 'package:flutter_wallpaper_x/View/RootScreen/SplashScreen/splash_screen.dart';
import 'package:flutter_wallpaper_x/View/RootScreen/bloc/root_bloc.dart';
import 'package:flutter_wallpaper_x/View/SettingScreen/setting_screen.dart';
import 'package:flutter_wallpaper_x/ViewModel/Functions/Screens/root.dart';
import 'package:get/get.dart';
import '../../Model/Icons/icons.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with RestorationMixin {
  final InitialController initialController = Get.find();
  final DuplicateController duplicateController = Get.find();
  final BottomNavigationController navigationController = Get.find();
  late final CustomIcons customIcons = duplicateController.customIcons;
  late final navigationIndex = navigationController.navigationIndex;
  late final tapIndex = initialController.tapIndex;

  Future<void> customDispose() async {
    if (context.mounted) {
      await context.read<RootBloc>().close();
    }
    if (context.mounted) {
      await context.read<HomeBloc>().close();
    }
    if (context.mounted) {
      await context.read<FavoriteBloc>().close();
    }
    navigationIndex.dispose();
    await duplicateController.favoriteFunctions.closeFavoriteBoxes();
    duplicateController.searchTextController.dispose();
    navigationController.dispose();
    duplicateController.dispose();
    initialController.dispose();
  }

  @override
  void dispose() async {
    super.dispose();
    await customDispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootBloc, RootState>(
      builder: (context, state) {
        final ColorScheme colorScheme = Theme.of(context).colorScheme;
        final PageController rootPageController =
            PageController(initialPage: navigationIndex.value);
        final RootFunctions rootFunctions = navigationController.rootFunctions;
        if (state is RootLoading) {
          return const SplashScreen();
        } else if (state is RootMain) {
          return RootMainScreen(
            rootFunctions: rootFunctions,
            colorScheme: colorScheme,
            customIcons: customIcons,
            navigationIndex: navigationIndex,
            pageController: rootPageController,
          );
        } else {
          return const SplashScreen();
        }
      },
    );
  }

  @override
  String? get restorationId => initialController.homeScreenRestoration;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(
        navigationIndex, initialController.rootScreenRestoration);
    registerForRestoration(tapIndex, initialController.homeScreenRestoration);
    registerForRestoration(duplicateController.searchTextController,
        duplicateController.searchResorationId);
    navigationIndex.value = navigationIndex.value == searchScreenIndex
        ? homeScreenIndex
        : navigationIndex.value;
  }
}

class RootMainScreen extends StatefulWidget {
  const RootMainScreen({
    super.key,
    required this.colorScheme,
    required this.navigationIndex,
    required this.pageController,
    required this.customIcons,
    required this.rootFunctions,
  });

  final ColorScheme colorScheme;
  final RestorableInt navigationIndex;
  final RootFunctions rootFunctions;
  final PageController pageController;
  final CustomIcons customIcons;

  @override
  State<RootMainScreen> createState() => _RootMainScreenState();
}

class _RootMainScreenState extends State<RootMainScreen> {
  @override
  void initState() {
    widget.rootFunctions.lastScreen.add(widget.navigationIndex.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationController>(
      builder: (navigationController) {
        int activeIndex = widget.navigationIndex.value;
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: navigationController.rootNavigatorKey,
          backgroundColor: widget.colorScheme.background,
          bottomNavigationBar: BottomNavigationBar(
            iconSize: defaultIconSize,
            onTap: (value) {
              widget.rootFunctions.bottomNavigationTap(
                  value: value,
                  pageController: widget.pageController,
                  backgroundColor: widget.colorScheme.shadow);
            },
            currentIndex: widget.navigationIndex.value,
            selectedItemColor: widget.colorScheme.primary,
            unselectedItemColor: widget.colorScheme.secondary,
            items: [
              navigationItem(iconData: widget.customIcons.homeScreenIcon),
              navigationItem(iconData: widget.customIcons.favoriteScreenIcon),
              navigationItem(iconData: widget.customIcons.searchScreenIcon),
              navigationItem(iconData: widget.customIcons.settingScreenIcon),
            ],
          ),
          body: PageView(
            physics: rootScrollPhysics,
            controller: widget.pageController,
            children: [
              AppMainScreen(
                isActive: activeIndex == homeScreenIndex ||
                    activeIndex == searchScreenIndex,
                child: const HomeScreen(),
              ),
              AppMainScreen(
                isActive: activeIndex == favoriteScreenIndex ||
                    activeIndex == searchScreenIndex,
                child: FavoriteScreen(),
              ),
              Container(),
              AppMainScreen(
                  isActive: activeIndex == settingScreenIndex ||
                      activeIndex == searchScreenIndex,
                  child: const SettingScreen()),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem navigationItem({required IconData iconData}) {
    return BottomNavigationBarItem(
        icon: Icon(iconData),
        label: "",
        backgroundColor: widget.colorScheme.background);
  }
}

class AppMainScreen extends StatelessWidget {
  const AppMainScreen({super.key, required this.child, required this.isActive});
  final Widget child;
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return isActive ? child : Container();
  }
}
