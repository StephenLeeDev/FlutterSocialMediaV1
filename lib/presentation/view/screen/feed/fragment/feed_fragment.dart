import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/post/item/post_model.dart';
import '../../../../viewmodel/post/list/post_grid_list_viewmodel.dart';
import '../../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../../viewmodel/user/my_info/get/my_user_info_viewmodel.dart';
import '../../../widget/feed/post_widget.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({Key? key, this.isFromMyPage = false, required this.selectedPostId}) : super(key: key);

  final bool isFromMyPage;
  final int selectedPostId; /// Selected post's index from grid feed list screen

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  late final ScrollController _scrollController;

  late final MyUserInfoViewModel _myUserInfoViewModel;
  late final PostListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    // _scrollController.addListener(_scrollListener);

    initViewModels();

    // FIXME : animateTo isn't working and I don't know why yet
    final selectedIndex = _postListViewModel.currentList.indexWhere((post) => post.getId == widget.selectedPostId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedPostId >= 0) {
        _scrollController.animateTo(4, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      }
    });
    // Future.delayed(Duration(seconds: 1), () {
    //   if (widget.selectedPostId >= 0) {
    //     _scrollController.animateTo(4, duration: const Duration(milliseconds: 100), curve: Curves.easeInOut);
    //   }
    // });
  }

  /// ViewModels
  void initViewModels() {
    initMyUserInfoViewModel();
    initListViewModel();
  }

  /// My User Info
  void initMyUserInfoViewModel() {
    _myUserInfoViewModel = context.read<MyUserInfoViewModel>();
  }

  /// List
  void initListViewModel() {
    if (widget.isFromMyPage) {
      _postListViewModel = context.read<MyPostGridListViewModel>();
    } else {
      _postListViewModel = context.read<PostListViewModel>();
    }
    _postListViewModel.setMyEmail(value: _myUserInfoViewModel.myEmail);
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
      ],
      /// Screen
      child: buildSuccessStateUI(),
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
