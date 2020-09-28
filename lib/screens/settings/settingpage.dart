import 'package:kuku/screens/settings/webviewpage.dart';
import 'package:kuku/utils/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kuku/widgets/gradientappbar.dart';
import 'package:kuku/widgets/gradienticons.dart';
import 'package:kuku/widgets/gradienttext.dart';
import 'package:kuku/widgets/premiumcontainer.dart';
import 'profileupdatepage.dart';

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingPageState();
  }
}

class SettingPageState extends State<SettingPage> {
  List<String> listOfItems = ['Profile & Theme', 'Privacy Policy'];

  // String privacypolicyLink = 'https://drive.google.com/file/d/1uCOH6y_xsYamTwCOoLmoT_0lJ0XvDiZ1/view?usp=sharing';
  String facebookLink = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Constant.selectedColor,
          title: Text('Settings'),
          // title: GradientText(text: 'Settings', size: 20.0, gradient: Constant.selectedButtonColor,)
        ),
        body: PremiumContainer(
          child: mainBody(),
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
                title: GradientText(text: listOfItems[index], gradient: Constant.selectedButtonColor, size: 20.0,),
                // Text(
                //   listOfItems[index],
                  
                //   style: TextStyle(
                //     color: Constant.selectedColor,
                //   ),
                // ),
                trailing: GradientIcon(
                  icon: Icons.arrow_forward_ios,
                  gradient: Constant.selectedButtonColor,
                  size: 20,
                ),
                // Icon(
                //   Icons.arrow_forward_ios,
                //   color: Constant.selectedColor,
                // ),
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
    }
  }

  navigateToPage(page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
