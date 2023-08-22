import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../data/constant/text.dart';
import '../../../../data/model/post/item/post_model.dart';
import '../../../../domain/usecase/post/list/get_my_post_list_usecase.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import '../../../util/snackbar/snackbar_util.dart';
import '../../../viewmodel/post/list/post_grid_list_viewmodel.dart';
import '../../widget/navigation/navigation_tab.dart';
import '../feed/feed_screen.dart';
import '../my/my_page_screen.dart';
import '../notification/notification_screen.dart';
import '../post/create/create_post_screen.dart';
import '../search/search_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key, required this.tab}) : super(key: key);

  static const String routeName = "mainNavigation";

  final String tab;

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {

  late final MyPostGridListViewModel _postGridListViewModel;

  /// Tab items
  final List<String> _tabs = [
    FeedScreen.routeName,
    SearchScreen.routeName,
    CreatePostScreen.routeName,
    NotificationScreen.routeName,
    MyPageScreen.routeName,
  ];

  /// Selected tap index
  late int _selectedIndex = _tabs.indexOf(widget.tab);

  /// On bottom navigation tab clicked
  void _onTap(int index) {
    context.go("/${_tabs[index]}");
    setState(() {
      _selectedIndex = index;
    });
  }

  /// On create a new post tab
  void _onCreatePostTap() async {
    String? createdPostString = await context.pushNamed(CreatePostScreen.routeName);

    /// If created post exists, prepend it to the grid list and move to the my page screen
    if (createdPostString != null) {
      final createdPost = PostModel.fromJson(jsonDecode(createdPostString));
      _postGridListViewModel.prependNewCommentToList(additionalList: [createdPost]);
      if (context.mounted) showSnackBar(context: context, text: postCreatedMessage);
      _onTap(4);
    }
  }

  @override
  void initState() {
    super.initState();

    initViewModels();
  }

  /// ViewModels
  void initViewModels() {
    initGridListViewModel();
  }

  /// List
  void initGridListViewModel() {
    _postGridListViewModel = MyPostGridListViewModel(
      getPostListUseCase: GetIt.instance<GetPostListUseCase>(),
      getMyPostListUseCase: GetIt.instance<GetMyPostListUseCase>(),
    );
    _postGridListViewModel.setLimit(value: 18);
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
          MultiProvider(
            providers: [
              Provider<MyPostGridListViewModel>(
                create: (context) => _postGridListViewModel,
              ),
            ],
            child: Offstage(
              offstage: _selectedIndex != 4,
              child: const MyPageScreen(),
            ),
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
                onTap: () => _onCreatePostTap(),
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