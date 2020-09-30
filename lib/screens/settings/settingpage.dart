import 'package:kuku/screens/settings/webviewpage.dart';
import 'package:kuku/screens/settings/themepage.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku/widgets/gradienticons.dart';
import 'package:kuku/widgets/gradienttext.dart';
import 'package:kuku/widgets/nonpremiumcontainer.dart';
import 'package:kuku/widgets/premiumcontainer.dart';
import 'profileupdatepage.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {
  List<String> listOfItems = ['Profile & Theme', 'Privacy Policy', 'Theme'];

  // String privacypolicyLink = 'https://drive.google.com/file/d/1uCOH6y_xsYamTwCOoLmoT_0lJ0XvDiZ1/view?usp=sharing';
  String facebookLink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constant.primiumThemeSelected
              ? Constant.gradientStartColor
              : Constant.selectedColor,
          title: Text('Settings'),
          // title: GradientText(text: 'Settings', size: 20.0, gradient: Constant.selectedButtonColor,)
        ),
        body: Constant.primiumThemeSelected
            ? PremiumContainer(
                child: mainBody(),
                gradient: Constant.selectedGradient,
              )
            : NonPremiumContainer(
                child: mainBody(),
                color: Constant.selectedColor,
              ));
  }

  Widget mainBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: ListView.builder(
          itemCount: listOfItems.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Constant.primiumThemeSelected
                    ? GradientText(
                        text: listOfItems[index],
                        gradient: Constant.selectedButtonGradient,
                        size: 18.0,
                      )
                    : Text(
                        listOfItems[index],
                        style: TextStyle(
                          color: Constant.selectedColor,
                        ),
                      ),
                trailing: Constant.primiumThemeSelected
                    ? GradientIcon(
                        icon: Icons.arrow_forward_ios,
                        gradient: Constant.selectedButtonGradient,
                        size: 20,
                      )
                    : Icon(
                        Icons.arrow_forward_ios,
                        color: Constant.selectedColor,
                      ),
                onTap: () => onListTileTap(index),
              ),
            );
          }),
    );
  }

  onListTileTap(index) {
    switch (index) {
      case 0:
        navigateToPage(ProfileUpdate());
        break;
      case 1:
        // navigateToPage(WebViewPage(link: privacypolicyLink,));
        navigateToPage(WebViewPage());
        break;
      case 2:
        // navigateToPage(WebViewPage(link: privacypolicyLink,));
        navigateToThemePage();
        break;
    }
  }

  navigateToPage(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }

  navigateToThemePage() async {
    bool returnValue = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => ThemePage()));
    print(returnValue.toString());
    if (returnValue != null) {
      setState(() {
        print('setting page updated');
      });
    }
  }

}
