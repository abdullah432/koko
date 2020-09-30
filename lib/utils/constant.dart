import 'package:kuku/model/Story.dart';
import 'package:flutter/material.dart';
import 'package:kuku/styles/gradientcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Constant {
  //setting loaded
  static bool settingLoaded = false;

  static List<bool> unlockTheme = [];
  static bool primiumThemeSelected;
  static Color selectedColor = color1;
  static Color gradientStartColor;
  static LinearGradient selectedGradient = GradientColors.gradient1;
  static LinearGradient selectedButtonGradient = GradientColors.gradientbutton1;

  static Color color1 = Color.fromRGBO(253, 152, 86, 1.0);
  static Color color2 = Color.fromRGBO(235, 223, 217, 1.0);
  static Color color3 = Color.fromRGBO(224, 135, 153, 1.0);
  static Color color4 = Color.fromRGBO(10, 49, 128, 1.0);
  static Color color5 = Color.fromRGBO(30, 32, 41, 1.0);

  static List<Color> listOfColors = [color1, color2, color3, color4, color5];
  static List<LinearGradient> listOfPremium = [GradientColors.gradient1];
  static List<LinearGradient> listOfPremiumButtons = [
    GradientColors.gradientbutton1
  ];

  //List of feeling
  static List<String> listOfFeelings = ['SAD', 'COMPLETELY OK', 'HAPPY'];
  //List of reason
  static List<String> listOfReasons = [
    "Realationship",
    "Work",
    "Family",
    "Traveling",
    "Food",
    "Education",
    "Exercise",
    "Friends",
    "Others"
  ];

  //user name
  static String username;
  //user id
  static String useruid;

  //ads: videoAd = true means show video ad
  static bool videoAd = true;
  static bool facebooknative = true;

  //functions
  static DateTime getActiveStoryDate(String value) {
    DateTime date = DateTime.parse(value);
    return date;
  }

  //
  static AssetImage getImageAsset(Story storyList) {
    switch (storyList.reason) {
      case 'Traveling':
        AssetImage assetImage = AssetImage('images/iceforestroad.jpg');
        return assetImage;
        break;
      case 'Education':
        AssetImage assetImage = AssetImage('images/study.jpg');
        return assetImage;
        break;
      case 'Family':
        AssetImage assetImage = AssetImage('images/family2.jpg');
        return assetImage;
        break;
      case 'Food':
        AssetImage assetImage = AssetImage('images/food.jpg');
        return assetImage;
        break;
      case 'Work':
        AssetImage assetImage = AssetImage('images/work2.jpg');
        return assetImage;
        break;
      case 'Friends':
        AssetImage assetImage = AssetImage('images/friends.jpg');
        return assetImage;
        break;
      default:
        AssetImage assetImage = AssetImage('images/milky-way.jpg');
        return assetImage;
        break;
    }
  }

  //check username and color
  static Future<bool> checkUserAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('name') ?? '';
    final colorIndex = prefs.getInt('colorIndex') ?? 0;
    //Now initialize selectedColor
    Constant.selectedColor = Constant.listOfColors[colorIndex];
    Constant.username = username;

    if (username.isNotEmpty)
      return true;
    else
      return false;
  }

  //check morning, evening, afternon
  static String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  //load setting
  static loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    int selectedThemIndex = prefs.getInt('selectedThemIndex') ?? 0;
    primiumThemeSelected = prefs.getBool('primiumThemeSelected') ?? false;
    //Now initialize selectedColor
    if (primiumThemeSelected) {
      selectedGradient = Constant.listOfPremium[selectedThemIndex];
      selectedButtonGradient = Constant.listOfPremiumButtons[selectedThemIndex];
      gradientStartColor =
          GradientColors.listOfGradientStartColor[selectedThemIndex];
    } else
      Constant.selectedColor = Constant.listOfColors[selectedThemIndex];
  }
}
