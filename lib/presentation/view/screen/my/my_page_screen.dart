import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../../../data/model/post/list/post_list_state.dart' as PostListState;
import '../../../../data/model/user/my_user_info.dart';
import '../../../../data/model/user/my_user_info_state.dart' as MyUserInfoState;
import '../../../../domain/usecase/post/list/get_my_post_list_usecase.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import '../../../viewmodel/post/list/post_grid_list_viewmodel.dart';
import '../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../viewmodel/user/my_info/get/my_user_info_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/feed/post_grid_widget.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  static const String routeName = "myPage";
  static const String routeURL = "/myPage";

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  final _scrollController = ScrollController();

  late final MyUserInfoViewModel _myUserInfoViewModel;
  late final MyPostGridListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    initViewModels();
  }

  /// ViewModels
  void initViewModels() {
    initMyUserInfoViewModel();
    initListViewModel();
  }

  /// My User Info
  void initMyUserInfoViewModel() {
    _myUserInfoViewModel = GetIt.instance<MyUserInfoViewModel>();
  }

  /// List
  void initListViewModel() {
    _postListViewModel = MyPostGridListViewModel(
        getPostListUseCase: GetIt.instance<GetPostListUseCase>(),
        getMyPostListUseCase: GetIt.instance<GetMyPostListUseCase>()
    );
    _postListViewModel.setLimit(value: 18);
  }

  void fetchData() async {
    await fetchPostList();
  }

  /// Fetch feed
  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    /// Provider
    return MultiProvider(
      providers: [
        Provider<PostListViewModel>(
          create: (context) => _postListViewModel,
        ),
        Provider<MyUserInfoViewModel>(
          create: (context) => _myUserInfoViewModel,
        ),
      ],

      /// Screen
      child: SafeArea(
        child: RefreshIndicator(
          onRefresh: () {
            return _refresh();
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: _scrollController,
            children: [
              /// User profile
              ValueListenableBuilder<MyUserInfoState.MyUserInfoState>(
                valueListenable: _myUserInfoViewModel.myUserInfoStateNotifier,
                builder: (context, state, _) {
                  if (state is MyUserInfoState.Success) {
                    fetchData();
                    return buildUserProfileUI(myUserInfo: state.getMyUserInfo);
                  } else {
                    return Container();
                  }
                },
              ),

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
                    return buildSuccessStateUI();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// User profile layout
  Widget buildUserProfileUI({required MyUserInfo myUserInfo}) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Appbar
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Text(
                      myUserInfo.getUserName,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  /// User thumbnail
                  Container(
                    margin: const EdgeInsets.only(right: 0),
                    width: 120,
                    height: 120,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Image.network(
                      myUserInfo.getUserThumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// Posts
                        Expanded(
                          child: Column(
                            children: const [
                              Text(
                                // TODO : Replace with actual state later
                                "0",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Posts",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Followers
                        Expanded(
                          child: Column(
                            children: const [
                              Text(
                                // TODO : Replace with actual state later
                                "0",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Followers",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// Following
                        Expanded(
                          child: Column(
                            children: const [
                              Text(
                                // TODO : Replace with actual state later
                                "0",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Following",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// Status message
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 12, left: 12, right: 12),
                child: Text(
                  // TODO : Replace with actual state later
                  "Lorem ipsum",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

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
        fetchPostList();
      }),
    );
  }

  /// Success UI (default)
  Widget buildSuccessStateUI() {
    return ValueListenableBuilder<List<PostModel>>(
      valueListenable: _postListViewModel.currentListNotifier,
      builder: (context, list, _) {
        // TODO : Implement empty list
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
          ),
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: PostGridWidget(
                postModel: list[index],
              ),
            );
          },
        );
      },
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchPostList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    _postListViewModel.refresh();
    _postListViewModel.setLimit(value: 15);
    await _myUserInfoViewModel.getMyUserInfo();
  }

}
