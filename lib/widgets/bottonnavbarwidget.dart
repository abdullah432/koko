import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:kuku/utils/constant.dart';
import 'package:kuku/widgets/gradienticons.dart';

class BottomNavBarWidget extends StatelessWidget {
  final void Function(int index) onItemTap;
  final int selectedIndex;
  const BottomNavBarWidget({
    @required this.onItemTap,
    @required this.selectedIndex,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: (Constant.primiumThemeSelected && selectedIndex == 0
              ? GradientIcon(
                  icon: FlutterIcons.home_ent,
                  size: 32,
                  // gradient: Constant.selectedButtonGradient,
                  gradient: getColor(0),
                )
              : Icon(
                  FlutterIcons.home_ent,
                  // color: Constant.selectedColor,
                  color: getColor(0),
                  size: 32,
                )),
          label: 'Home',
        ),
        BottomNavigationBarItem(
            icon: Icon(
              FlutterIcons.ios_add_circle_ion,
              size: 30,
              color: getColor(1),
            ),
            label: 'Explore'),
        BottomNavigationBarItem(
            icon: (Constant.primiumThemeSelected && selectedIndex == 2
                ? GradientIcon(
                    icon: FlutterIcons.users_faw5s,
                    size: 32,
                    // gradient: Constant.selectedButtonGradient,
                    gradient: getColor(2),
                  )
                : Icon(
                    FlutterIcons.users_faw5s,
                    // color: Constant.selectedColor,
                    color: getColor(2),
                    size: 32,
                  )),
            // Icon(
            //   FlutterIcons.users_faw5s,
            //   size: 30,
            //   color: getColor(2),
            // ),
            label: 'Explore'),
      ],
      currentIndex: selectedIndex,
      selectedItemColor: Colors.blue,
      onTap: (index) => onItemTap(index),
    );
  }

  getColor(int index) {
    if (index == selectedIndex) {
      if (Constant.primiumThemeSelected)
        return Constant.selectedButtonGradient;
      else
        return Constant.selectedColor;
    } else {
      return Colors.black38;
    }
  }
}
