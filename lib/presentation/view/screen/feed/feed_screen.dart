import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../../../data/model/post/list/post_list_state.dart';
import '../../../../domain/usecase/post/list/get_post_list_usecase.dart';
import '../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../viewmodel/user/my_info/my_user_info_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/feed/post_widget.dart';

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

  Future<void> fetchMyUserInfo() async {
    await _myUserInfoViewModel.getMyUserInfo();
    _postListViewModel.setMyEmail(value: _myUserInfoViewModel.myEmail);
  }

  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PostListViewModel>(
          create: (context) => _postListViewModel,
        ),
      ],
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<PostListState>(
          valueListenable: _postListViewModel.postListStateNotifier,
          builder: (context, state, _) {
            /// Loading UI
            if (state is Loading && _postListViewModel.currentList.isEmpty) {
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

  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        fetchPostList();
      }),
    );
  }

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
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: PostWidget(
                    postModel: list[index],
                  ),
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
