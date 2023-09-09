import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/model/user/simple/item/simple_user_info_model.dart';
import '../../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../../../domain/usecase/follow/get_follower_list_usecase.dart';
import '../../../../domain/usecase/follow/get_following_list_usecase.dart';
import '../../../values/text/text.dart';
import '../../../viewmodel/follow/list/follow_list_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/user/other_user/user_simple_profile_widget.dart';

class FollowListScreen extends StatefulWidget {
  const FollowListScreen({Key? key, required this.isFollowerMode, required this.userEmail}) : super(key: key);

  static const String routeName = "followList";
  static const String routeURL = "/followList";

  /// When it's true, it works as a Follower list screen
  /// When it's false, it works as a Following list screen
  final bool isFollowerMode;
  final String userEmail;

  @override
  State<FollowListScreen> createState() => _FollowListScreenState();
}

class _FollowListScreenState extends State<FollowListScreen> {

  final _scrollController = ScrollController();

  late final FollowListViewModel _followerListViewModel;

  @override
  void initState() {
    super.initState();

    initScrollController();
    initViewModels();
    fetchData();
  }

  void initScrollController() {
    _scrollController.addListener(_scrollListener);
  }

  void initViewModels() {
    _followerListViewModel = FollowListViewModel(
      getFollowerListUseCase: GetIt.instance<GetFollowerListUseCase>(),
      getFollowingListUseCase: GetIt.instance<GetFollowingListUseCase>(),
    );
    _followerListViewModel.setEmail(value: widget.userEmail);
    _followerListViewModel.setIsFollowing(value: widget.isFollowerMode);
  }

  /// Fetch followers/followings
  Future<void> fetchData() async {
    await _followerListViewModel.getFollowList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: Text(
          widget.isFollowerMode ? followers : followings,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      /// Screen
      body: ValueListenableBuilder<SimpleUserListState>(
        valueListenable: _followerListViewModel.followListStateNotifier,
        builder: (context, state, _) {
          /// Loading UI
          if (state is Loading && _followerListViewModel.currentList.isEmpty) {
            return buildLoadingStateUI();
          }
          /// Fail UI
          else if (state is Fail) {
            return buildFailStateUI();
          }
          /// Success UI (default)
          else {
            return buildSuccessStateUI();
          }
        },
      ),
    );
  }

  // TODO : Enhance the loading UI
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

  // Widget buildLoadingStateUI() {
  //   return LayoutBuilder(
  //     builder: (BuildContext context, BoxConstraints constraints) {
  //       return SingleChildScrollView(
  //         physics: const NeverScrollableScrollPhysics(),
  //         child: Column(
  //           children: const [
  //             PostLoadingWidget(),
  //             PostLoadingWidget(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        fetchData();
      }),
    );
  }

  Widget buildSuccessStateUI() {
    return RefreshIndicator(
      onRefresh: () {
        return _followerListViewModel.refresh();
      },
      child: ValueListenableBuilder<List<SimpleUserInfoModel>>(
          valueListenable: _followerListViewModel.currentListNotifier,
          builder: (context, list, _) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return UserSimpleProfileWidget(
                  simpleUserInfoModel: list[index],
                );
              }
            );
          }
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchData();
    }
  }

}
