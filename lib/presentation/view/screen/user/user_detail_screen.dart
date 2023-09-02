import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../domain/usecase/post/list/get_post_list_by_user_email_usecase.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import '../../../../domain/usecase/user/other_user/get_user_info_by_email_usecase.dart';
import '../../../viewmodel/post/list/other_user_post_list_viewmodel.dart';
import '../../../viewmodel/user/other_user/get_user_info/other_user_info_viewmodel.dart';
import '../feed/fragment/feed_fragment.dart';
import 'fragment/user_detail_fragment.dart';

/// This screen displays detailed information about other users
/// It's not for current user (Current user has to use MyPageScreen to display user's own information, not this)
class UserDetailScreen extends StatefulWidget {
  const UserDetailScreen({Key? key, required this.userEmail}) : super(key: key);

  static const String routeName = "userDetail";
  static const String routeURL = "/userDetail";

  final String userEmail;

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {

  final PageController _pageController = PageController();

  late final OtherUserInfoViewModel _otherUserInfoViewModel;
  late final OtherUserPostGridListViewModel _postListViewModel;

  final List<Widget> fragments = [
    const UserDetailFragment(),
    const FeedFragment(),
  ];

  @override
  void initState() {
    super.initState();

    _initViewModels();
    _fetchData();
  }

  /// Initialize ViewModels
  void _initViewModels() {
    _initUserInfoViewModel();
    _initListViewModel();
  }

  /// Initialize user information ViewModel
  void _initUserInfoViewModel() {
    _otherUserInfoViewModel = OtherUserInfoViewModel(getUserInfoByEmailUseCase: GetIt.instance<GetUserInfoByEmailUseCase>());
  }

  /// Initialize feed ViewModel
  void _initListViewModel() {
    _postListViewModel = OtherUserPostGridListViewModel(
      getPostListUseCase: GetIt.instance<GetPostListUseCase>(),
      getPostListByUserEmailUseCase: GetIt.instance<GetPostListByUserEmailUseCase>(),
    );
    _postListViewModel.setEmail(email: widget.userEmail);
    _postListViewModel.setLimit(value: 15);
  }

  /// Fetch data
  void _fetchData() async {
    /// User profile
    await _getUserInfoByEmail(userEmail: widget.userEmail);
    /// Feed
    fetchPostList();
  }

  /// Fetch user information
  Future<void> _getUserInfoByEmail({required String userEmail}) async {
    _otherUserInfoViewModel.getUserInfoByEmail(userEmail: userEmail);
  }

  /// Fetch feed
  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<OtherUserInfoViewModel>(
          create: (context) => _otherUserInfoViewModel,
        ),
        Provider<OtherUserPostGridListViewModel>(
          create: (context) => _postListViewModel,
        ),
      ],
      /// PageView screen
      /// UserProfile, and Feed fragments
      child: Scaffold(
        backgroundColor: Colors.white,
        /// Appbar
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: /// User's name
            ValueListenableBuilder<String>(
              valueListenable: _otherUserInfoViewModel.usernameNotifier,
              builder: (context, name, _) {
                return Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w900,
                  ),
                );
              },
            ),
        ),
        body: SafeArea(
          bottom: false,
          child: PageView.builder(
            controller: _pageController,
            // physics: const NeverScrollableScrollPhysics(),
            itemCount: fragments.length,
            itemBuilder: (context, index) {
              return fragments[index];
            },
          ),
        ),
      ),
    );
  }
}
