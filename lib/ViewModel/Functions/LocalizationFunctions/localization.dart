import 'package:flutter/material.dart';
import 'package:flutter_wallpaper_x/Model/GetX/Controllers/initial_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationFunctions {
  final String localizationPreferences = "LocalizationPreferences";
  final List<String> applicationLanguages = ["English", "Türkçe", "فارسی"];
  late final Map<String, Locale> languageLocale = {
    applicationLanguages[0]: const Locale("en"),
    applicationLanguages[1]: const Locale("tr"),
    applicationLanguages[2]: const Locale("fa"),
  };

  Future<void> setLocale(
      {required Locale newLoclae,
      required InitialController initialController,
      required BuildContext context}) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    initialController.applicationLocale.value = newLoclae;
    await sharedPreferences.setString(
        localizationPreferences, newLoclae.languageCode);
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<Locale> getLocale() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    String? languageCode = sharedPreferences.getString(localizationPreferences);
    final InitialController initialController = Get.find();

    if (languageCode != null) {
      final Locale savedLocale = Locale(languageCode);
      initialController.applicationLocale.value = savedLocale;
      return savedLocale;
    } else {
      return initialController.initialLocale;
    }
  }
}
