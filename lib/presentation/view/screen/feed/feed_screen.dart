import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../../../data/model/post/list/post_list_state.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import '../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../viewmodel/user/my_info/get/my_user_info_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/feed/post_loading_widget.dart';
import '../../widget/feed/post_widget.dart';

// TODO : Might enhance it from replace with FeedFragment
// TODO : But low priority
class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  static const String routeName = "feed";
  static const String routeURL = "/feed";

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final _scrollController = ScrollController();

  late final MyUserInfoViewModel _myUserInfoViewModel;
  late final PostListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    initViewModels();
    fetchData();
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
    _postListViewModel = PostListViewModel(getPostListUseCase: GetIt.instance<GetPostListUseCase>());
  }

  void fetchData() async {
    await fetchMyUserInfo();
    await fetchPostList();
  }

  /// Fetch my user information first before the list
  Future<void> fetchMyUserInfo() async {
    _postListViewModel.setPostListState(postListState: MyUserInfoLoading());
    await _myUserInfoViewModel.getMyUserInfo();
    _postListViewModel.setMyEmail(value: _myUserInfoViewModel.myEmail);
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
      ],
      /// Screen
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<PostListState>(
          valueListenable: _postListViewModel.postListStateNotifier,
          builder: (context, state, _) {
            /// Loading UI
            if ((state is MyUserInfoLoading) || (state is Loading && _postListViewModel.currentList.isEmpty)) {
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
      ),
    );
  }

  Widget buildLoadingStateUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: const [
              PostLoadingWidget(),
              PostLoadingWidget(),
            ],
          ),
        );
      },
    );
  }

  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        fetchPostList();
      }),
    );
  }

  // TODO : Might enhance it from replace with FeedFragment
  // TODO : But low priority
  Widget buildSuccessStateUI() {
    return RefreshIndicator(
      onRefresh: () {
        return _postListViewModel.refresh();
      },
      child: ValueListenableBuilder<List<PostModel>>(
          valueListenable: _postListViewModel.currentListNotifier,
          builder: (context, list, _) {
            return ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return PostWidget(
                  postModel: list[index],
                );
              }, separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            );
          }
      ),
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

}
