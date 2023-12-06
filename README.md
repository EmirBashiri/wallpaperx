
# WallpaperX

A wallpaper app developed with Flutter and [Wallhaven](https://wallhaven.cc/) API.

## Screenshots

![1](https://github.com/EmirBashiri/wallpaperx/assets/111413480/eb8c5db7-7d1a-48e0-86a1-2f30b38aa16a)
![2](https://github.com/EmirBashiri/wallpaperx/assets/111413480/c69d5ff3-dd16-4a72-afb6-7e0bfc27be1f)
![3](https://github.com/EmirBashiri/wallpaperx/assets/111413480/8409c250-e3df-4e13-bc5c-3efe518e7e38)
![4](https://github.com/EmirBashiri/wallpaperx/assets/111413480/8b097756-d37c-490c-8200-3f31d677810c)
![5](https://github.com/EmirBashiri/wallpaperx/assets/111413480/44f4731c-aac3-4c69-be86-4b26f360ddd3)
![6](https://github.com/EmirBashiri/wallpaperx/assets/111413480/1a3a5cea-b886-435f-88a6-236c7043b58c)
![7](https://github.com/EmirBashiri/wallpaperx/assets/111413480/9f42b7cd-b31b-4cae-9ee4-82151267f22d)
![8](https://github.com/EmirBashiri/wallpaperx/assets/111413480/9362a642-6e49-4450-9339-7cc8bb7c9cef)
![9](https://github.com/EmirBashiri/wallpaperx/assets/111413480/4d17e76c-7243-46da-921a-7a36d43fd348)

## Features

- Vast Wallpaper Collection
- Categories and Themes
- Dark Mode Support
- Multi-language support
- Daily Wallpaper
- Favorites/Bookmark
- Download and Save
- Search Functionality
- Set as Wallpaper
- HD and 4K wallpapers
- Notification
- Performance Optimization
- Localized Content

## Tech Stack

**Framework:** [Flutter](https://flutter.dev)

**State Management:** [Bloc](https://bloclibrary.dev)

**Analytics & Notification:** [Firebase](https://firebase.google.com)

## Used Packages

[firebase_core](https://pub.dev/packages/firebase_core)
& [flutter_bloc](https://pub.dev/packages/flutter_bloc) & [GetX](https://pub.dev/packages/get) & [google_fonts](https://pub.dev/packages/google_fonts) & [font_awesome_flutter](https://pub.dev/packages/font_awesome_flutter) & [flutter_spinkit](https://pub.dev/packages/flutter_spinkit) &    [dio](https://pub.dev/packages/dio) & [path_provider](https://pub.dev/packages/path_provider) &  [extended_image](https://pub.dev/packages/extended_image)  & [change_app_package_name](https://pub.dev/packages/change_app_package_name) & [url_launcher](https://pub.dev/packages/url_launcher) & [share_plus](https://pub.dev/packages/share_plus) & [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) & [intl](https://pub.dev/packages/intl) & [shared_preferences](https://pub.dev/packages/shared_preferences) & [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) & [lottie](https://pub.dev/packages/lottie) & [hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter) & [image_gallery_saver](https://pub.dev/packages/image_gallery_saver) & [fluttertoast](https://pub.dev/packages/fluttertoast) & [image_cropper](https://pub.dev/packages/image_cropper) & [just_the_tooltip](https://pub.dev/packages/just_the_tooltip) & [async_wallpaper](https://pub.dev/packages/async_wallpaper) & [page_transition](https://pub.dev/packages/page_transition) & [firebase_messaging](https://pub.dev/packages/firebase_messaging) & [flutter_cache_manager](https://pub.dev/packages/flutter_cache_manager)

## Screens

Splash , Home , Settings , Favorite , Category , Top Wallpapers , Wallpaper , Collection , Search , Theme selection , Language selection , Error , Loading 

## Installation & Development

For the purpose of testing and usage, kindly download the latest release from the 'Release' section on this page.

For debugging and development purposes, follow these steps :

1- Clone the project [from here](https://github.com/EmirBashiri/wallpaperx/archive/refs/heads/master.zip)

2- Open the project in your preferred Integrated Development Environment (IDE).

3- Run 'flutter pub get' in the terminal.

4- To integrate Firebase Analytics and notifications, consult the official documentation [here](https://firebase.google.com/docs/flutter/setup)

5- After completing the Firebase configuration, create a folder named 'Firebase' in the path `lib/Model` and move the file created at `lib/firebase_options.dart` to `lib/Model/Firebase`. The updated location of the `firebase_options.dart` file should be `lib/Model/Firebase/firebase_options.dart`.

6- Run 'flutter run' in terminal

The project is now ready for use.
    
## Author

- [@Amir Bashiri](https://www.github.com/emirbashiri)
