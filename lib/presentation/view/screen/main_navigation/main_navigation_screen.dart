import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../widget/navigation/navigation_tab.dart';
import '../feed/feed_screen.dart';
import '../my/my_page_screen.dart';
import '../notification/notification_screen.dart';
import '../post/create_post_screen.dart';
import '../search/search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key, required this.tab}) : super(key: key);

  static const String routeName = "mainNavigation";

  final String tab;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

  final List<String> _tabs = [
    FeedScreen.routeName,
    SearchScreen.routeName,
    CreatePostScreen.routeName,
    NotificationScreen.routeName,
    MyPageScreen.routeName,
  ];

  late int _selectedIndex = _tabs.indexOf(widget.tab);

  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCameraButtonTap() {
    context.pushNamed(CreatePostScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      body: Stack(
        children: [
          Offstage(
            offstage: _selectedIndex != 0,
            child: const FeedScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 1,
            child: const SearchScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 3,
            child: const NotificationScreen(),
          ),
          Offstage(
            offstage: _selectedIndex != 4,
            child: const MyPageScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
              width: 1.0,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NavigationTab(
                isSelected: _selectedIndex == 0,
                icon: Icons.home,
                onTap: () => _onTap(0),
                selectedIndex: _selectedIndex,
              ),
              NavigationTab(
                isSelected: _selectedIndex == 1,
                icon: Icons.search,
                onTap: () => _onTap(1),
                selectedIndex: _selectedIndex,
              ),
              NavigationTab(
                isSelected: false,
                icon: Icons.add_box_outlined,
                onTap: () => _onCameraButtonTap(),
                selectedIndex: _selectedIndex,
              ),
              // TODO : Replace it to DirectMessage screen
              NavigationTab(
                isSelected: _selectedIndex == 3,
                icon: Icons.notifications,
                onTap: () => _onTap(3),
                selectedIndex: _selectedIndex,
              ),
              NavigationTab(
                isSelected: _selectedIndex == 4,
                icon: Icons.person,
                onTap: () => _onTap(4),
                selectedIndex: _selectedIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }
}