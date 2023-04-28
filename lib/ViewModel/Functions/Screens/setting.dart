import 'package:flutter/services.dart';
import 'package:flutter_wallpaper_x/Model/Constant/const.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreenFunctions {
  final String _privacyPolicyPage =
      "https://sites.google.com/view/wallpaperx-app-privacy-policy/home";
  final Uri _emailUrl = Uri.parse("mailto:$contactEmail?$applicationName");

  Future<String> launchPrivacyPolicyPage({required String errorMessage}) async {
    final Uri url = Uri.parse(_privacyPolicyPage);
    try {
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return "";
    } catch (e) {
      return errorMessage;
    }
  }

  Future<String> launchNativeEmail({required String errorMessage}) async {
    try {
      await launchUrl(_emailUrl);
      return "";
    } catch (e) {
      return errorMessage;
    }
  }

  Future<String> shareApp(
      {required String title, required String errorMessage}) async {
    try {
      await Share.share(shareUrl, subject: title);
      return "";
    } catch (e) {
      return errorMessage;
    }
  }

  Future<String> saveEmailInClipboard(
      {required String errorMessage, required String result}) async {
    try {
      await Clipboard.setData(
        const ClipboardData(text: contactEmail),
      );
      return result;
    } catch (e) {
      return errorMessage;
    }
  }
}
