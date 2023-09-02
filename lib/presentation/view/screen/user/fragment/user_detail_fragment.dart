import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/post/list/post_list_state.dart' as PostListState;
import '../../../../../data/model/user/detail_user_info_state.dart' as DetailUserInfoState;
import '../../../../viewmodel/post/list/other_user_post_list_viewmodel.dart';
import '../../../../viewmodel/user/other_user/get_user_info/other_user_info_viewmodel.dart';
import '../../../widget/common/error/error_widget.dart';
import '../../../widget/feed/grid_feed_widget.dart';
import '../../../widget/user/other_user/user_profile_widget.dart';

class UserDetailFragment extends StatefulWidget {
  const UserDetailFragment({Key? key}) : super(key: key);

  @override
  State<UserDetailFragment> createState() => _UserDetailFragmentState();
}

class _UserDetailFragmentState extends State<UserDetailFragment> {

  final ScrollController _scrollController = ScrollController();

  late final OtherUserInfoViewModel _otherUserInfoViewModel;
  late final OtherUserPostGridListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();

    _initScrollController();
    _initViewModels();
  }

  /// Initialize ViewModels
  void _initViewModels() {
    _initUserInfoViewModel();
    _initListViewModel();
  }

  /// Initialize user information ViewModel
  void _initUserInfoViewModel() {
    _otherUserInfoViewModel = context.read<OtherUserInfoViewModel>();
  }

  /// Initialize feed ViewModel
  void _initListViewModel() {
    _postListViewModel = context.read<OtherUserPostGridListViewModel>();
  }

  /// Initialize scroll controller for feed pagination
  void _initScrollController() {
    _scrollController.addListener(_scrollListener);
  }

  /// Fetch feed
  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        children: [
          /// User profile
          ValueListenableBuilder<DetailUserInfoState.DetailUserInfoState>(
            valueListenable: _otherUserInfoViewModel.userInfoStateNotifier,
            builder: (context, state, _) {
              if (state is DetailUserInfoState.Success) {
                return const UserProfileWidget();
              } else {
                // TODO : Implement Loading UI just like FeedScreen
                return Container();
              }
            },
          ),

          // TODO : Implement follow/unfollow button UI & feature

          /// Grid feed
          ValueListenableBuilder<PostListState.PostListState>(
            valueListenable: _postListViewModel.postListStateNotifier,
            builder: (context, state, _) {

              /// Loading UI
              if ((state is PostListState.Loading && _postListViewModel.currentList.isEmpty)) {
                return buildLoadingStateUI();
              }

              /// Fail UI
              else if (state is PostListState.Fail) {
                return buildFailStateUI();
              }

              /// Success UI (default)
              else {
                return const GridFeedWidget(isFromMyPage: false);
              }

            },
          ),
        ],
      ),
    );
  }

  // TODO : Low priority
  // TODO : Enhance loading UI
  /// Loading UI
  Widget buildLoadingStateUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return const Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  /// Fail UI
  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        _postListViewModel.getPostList();
      }),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchPostList();
    }
  }

}
