import 'package:flutter/material.dart';
import 'package:kuku/screens/addstory/add_story.dart';
import 'package:kuku/screens/community/communitypage.dart';
import 'package:kuku/screens/home/home_page.dart';
import 'package:kuku/widgets/bottonnavbarwidget.dart';

class MyBottomNavBarPage extends StatefulWidget {
  MyBottomNavBarPage({Key key}) : super(key: key);

  @override
  _MyBottomNavBarPageState createState() => _MyBottomNavBarPageState();
}

class _MyBottomNavBarPageState extends State<MyBottomNavBarPage> {
  final PageStorageBucket bucket = PageStorageBucket();
  int _selectedIndex = 0;
  //list of pages
  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('Page1'),
    ),
    AddStory(
      key: PageStorageKey('Page2'),
    ),
    CommunityPage(
      key: PageStorageKey('Page3'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTap: _onItemTapped,
      ),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddStory()));
      } else
        _selectedIndex = index;
    });
  }
}
