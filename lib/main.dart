import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/navigation_controller.dart';
import 'package:flutter_wallpaper_x/View/FavoriteScreen/bloc/favorite_bloc.dart';
import 'package:flutter_wallpaper_x/View/HomeScreen/bloc/home_bloc.dart';
import 'package:flutter_wallpaper_x/View/RootScreen/root_screen.dart';
import 'package:get/get.dart';

import 'Model/Constant/const.dart';
import 'View/RootScreen/bloc/root_bloc.dart';

void main() async {
  await initialNecessaryItems();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final RestorableInt navigationIndex =
        Get.find<BottomNavigationController>().navigationIndex;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = RootBloc();
            bloc.add(RootStart(navigationIndex.value));
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => HomeBloc(),
        ),
        BlocProvider(
          create: (context) {
            final favoriteBloc = FavoriteBloc();
            favoriteBloc.add(FavoriteStart());
            return favoriteBloc;
          },
        ),
      ],
      child: GetX<InitialController>(
        builder: (initialController) {
          return MaterialApp(
            navigatorKey: Get.key,
            restorationScopeId: initialController.resorationScopeId,
            localizationsDelegates: initialController.localizationsDelegates,
            supportedLocales: initialController.supportedLocales,
            locale: initialController.applicationLocale.value,
            theme: initialController.applicationTheme.value,
            home: const RootScreen(),
          );
        },
      ),
    );
  }
}
