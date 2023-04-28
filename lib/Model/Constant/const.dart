import 'package:extended_image/extended_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/duplicate_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/navigation_controller.dart';
import 'package:flutter_wallpaper_x/Model/Firebase/firebase_options.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

// Application necessary initialaize

Future<void> initialNecessaryItems() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  Get.put(InitialController());
  final duplicateController = Get.put(DuplicateController());
  Get.put(BottomNavigationController());
  await duplicateController.favoriteFunctions.initDatabase();
  await duplicateController.favoriteFunctions.openFavoriteBox();
}

// ////////////////////////////////////////////////////////////////////

// Wallaper Api section

const String wallpaperSourceLink = "https://wallhaven.cc/";

const int categoryCollectionPerPage = 16;
const int homeFeaturedCollectionCount = 15;
const String featuredCollectionsQuery = "4K";
const String featuredCollectionCategory = "";
const String featuredWallpapersQuery = "Featured Wallpapers";
const int defaultPerPage = 30;
const int defaultPageNumber = 1;

// Api images order enum
// ignore: constant_identifier_names
enum ApiOrder { date_added, relevance, random, views, favorites, toplist }

// ////////////////////////////////////////////////////////////////////

// ////////////////////////////////////////////////////////////////////

// Cache section
const Duration defaultCacheMaxAge = Duration(minutes: 5);
const Duration collectionCahceMaxAge = Duration(minutes: 5);
const Duration homeCollectionCacheMaxAge = Duration(minutes: 5);
const Duration searchCacheMaxAge = Duration(minutes: 5);
const Duration wallpaperDetailCacheMaxAge = Duration(minutes: 5);
const Duration defaultRequestCacheMaxAge = Duration(minutes: 5);
const int topWallpaperMaxPage = 35;

// ////////////////////////////////////////////////////////////////////

// Application name & creator name
const String applicationName = "WallpaperX";
const String creatorName="Amir Bashiri";

// Logo image path
const String logoImage = "assets/Images/Logo/Logo.png";
// Loading Animation size
const double loadingAnimationSize = 25;

// default Radius value
const double defaultRadiusValue = 15;
//default custom padding value
const double defaultPaddingValue = 15;

// length of Home screen tap bar
const int tapBarLength = 2;

// Custom theme mode (it should update whenever new theme added)
enum CustomThemeMode { defaultLight, defaultDark, systemDefault }

// This is font name used in Persian and Arabic language
const String persianFont = "PersianFont";

// custom exception
final Exception customExcepiton = Exception();
// custom bottm navigation icon size
const double defaultIconSize = 27;
// splash screen delayed second time
const int delayedSecond = 2;
// root screen page physics
const NeverScrollableScrollPhysics rootScrollPhysics =
    NeverScrollableScrollPhysics();
// default screens container margin
const EdgeInsets defaultEdgeInsets = EdgeInsets.only(left: 10, right: 10);
// default list view physics
const BouncingScrollPhysics defaultScrollPhysics = BouncingScrollPhysics();
// Default circular radius
BorderRadius defaultCircularRadius = BorderRadius.circular(15);

// Wallpapers masnory grid view configuration
const double crossAxisSpacing = 4;
const double mainAxisSpacing = 4;
const int crossAxisCount = 3;
// Images error widget

//  Custom button border radius
final BorderRadius customButtonRadius = BorderRadius.circular(25);

// Default AppBar elevation
const double defaultElevation = 0;

//Default bottom padding used in Wallpapers GridView
const EdgeInsets defaultItemPadding = EdgeInsets.only(bottom: 20);

// Category screen
const List<String> categoryImageList = [
  "assets/Images/Category/Animals.png",
  "assets/Images/Category/Futuristic.png",
  "assets/Images/Category/Car&Vehicle.png",
  "assets/Images/Category/Nature.png",
  "assets/Images/Category/Sky.png",
  "assets/Images/Category/Space.png",
  "assets/Images/Category/Game.jpg",
  "assets/Images/Category/Travel.jpg",
];
const List<String> categoryRequestTerm = [
  "animals",
  "futuristic",
  "vehicle",
  "nature",
  // equal to the sky
  "clouds",
  "space",
  "game",
  "mountains",
];
const double categoryImageHeight = 150;
final PageStorageBucket categoryBucket = PageStorageBucket();
const PageStorageKey categoryPageStorageKey = PageStorageKey("Category");

// Roman numbers list
const List<String> romanNumerals = [
  "",
  "I",
  "II",
  "III",
  "IV",
  "V",
  "VI",
  "VII",
  "VIII",
  "IX",
  "X",
  "XI",
  "XII",
  "XIII",
  "XIV",
  "XV",
  "XVI",
  "XVII",
  "XVIII",
  "XIX",
  "XX",
  "XXI",
  "XXII",
  "XXIII",
  "XXIV",
  "XXV",
  "XXVI",
  "XXVII",
  "XXVIII",
  "XXIX",
  "XXX"
];

// Search box default values
const double defaultBoxHeight = 100;
const double defaultSearchBoxHeght = 50;

//  lotties address
const String emptySearchLottie = "assets/Lotties/empty-search.json";
const String emptyListLottie = "assets/Lotties/empty-list.json";
const String errorLottie = "assets/Lotties/error.json";

// Application screens index
const int homeScreenIndex = 0;
const int favoriteScreenIndex = 1;
const int searchScreenIndex = 2;
const int settingScreenIndex = 3;

// Widgets sizes

final double _screenHeight = Get.height;
final double _screenWidth = Get.width;
const double wallpaperGridWith = 180;
double wallpaperGridHeght({required int index}) {
  if (_screenHeight.lessThan(600)) {
    return (index % 2 + 1) * 50;
  } else if (_screenHeight.lessThan(750)) {
    return (index % 2 + 1) * 80;
  } else if (_screenHeight.lessThan(950)) {
    return (index % 2 + 1) * 110;
  } else {
    return (index % 2 + 1) * 170;
  }
}

double posterSize() {
  if (_screenHeight.lessThan(600)) {
    return 120;
  } else if (_screenHeight.lessThan(750)) {
    return 140;
  } else if (_screenHeight.lessThan(950)) {
    return 165;
  } else {
    return 280;
  }
}

double searchBarWidth() => _screenWidth * 0.8;

// Home screen design expanded flexes
int collectionFlex() {
  if (Get.height < 600) {
    return 3;
  } else {
    return 2;
  }
}

const int wallpaperGridFlex = 4;

// Top Wallpapers title build
String topWallpapersTitle(
    {required AppLocalizations appLocalization, required int index}) {
  final title = "${appLocalization.homeCollection} ${romanNumerals[index]}";
  return title;
}

// set Wallpaper mode
enum WallpaperMode { homeScreen, lockScreen, bothScreen }

// Bottom sheet max height size
double bottomSheetMaxHeight({required double screenHeight}) {
  return screenHeight * 0.75;
}

//  Image crop settings
const CropAspectRatio cropAspectRatio = CropAspectRatio(ratioX: 9, ratioY: 16);
const ImageCompressFormat compressFormat = ImageCompressFormat.png;
const int compressQuality = 100;

//  Theme selection settings
const double checkIconSize = 17;
const double boxBorderWidth = 2;

// Duplicate list tile shape
final OutlineInputBorder customOutlineBordr = OutlineInputBorder(
    borderSide: BorderSide.none,
    borderRadius: BorderRadius.circular(defaultPaddingValue));

//  Duplicate bottom sheet border
const OutlineInputBorder bottomSheetShape = OutlineInputBorder(
  borderSide: BorderSide.none,
  borderRadius: BorderRadius.vertical(
    top: Radius.circular(defaultPaddingValue),
  ),
);

const String contactEmail = "wallpaperx.emirbashiri@gmail.com";
const String shareUrl = "https://github.com/EmirBashiri/wallpaperx";
