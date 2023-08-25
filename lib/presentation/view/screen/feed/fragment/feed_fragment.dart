import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../data/model/post/item/post_model.dart';
import '../../../../viewmodel/post/list/post_grid_list_viewmodel.dart';
import '../../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../../viewmodel/user/my_info/get/my_user_info_viewmodel.dart';
import '../../../widget/feed/post_widget.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({Key? key, this.isFromMyPage = false, required this.selectedPostId, this.title = ""}) : super(key: key);

  final bool isFromMyPage;
  final int selectedPostId; /// Selected post's index from grid feed list screen
  final String title; /// Feed's title for appbar

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  late final ItemScrollController _scrollController;
  late final ItemPositionsListener _itemPositionsListener;

  late final MyUserInfoViewModel _myUserInfoViewModel;
  late final PostListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();

    initViewModels();
    _initScroll();

    /// Selected post's index from grid feed list screen
    final selectedIndex = _postListViewModel.currentList.indexWhere((post) => post.getId == widget.selectedPostId);

    /// Jump to the selected post
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.selectedPostId >= 0) {
        _scrollController.jumpTo(index: selectedIndex);
      }
    });
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

  /// ItemScrollController & ItemPositionsListener
  void _initScroll() {
    _scrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();

    _itemPositionsListener.itemPositions.addListener(() {
      final currentIndex = _itemPositionsListener.itemPositions.value.last.index;
      final currentListLength = _postListViewModel.currentList.length - 1;

      /// It means, reached the bottom
      /// Load more feed
      if (currentIndex == currentListLength) {
        fetchPostList();
      }
    });
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
        /// Appbar
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
            ),
          ),
        ),
          body: SafeArea(
              child: buildSuccessStateUI(),
          ),
      ),
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
            return ScrollablePositionedList.separated(
              itemScrollController: _scrollController,
              itemCount: list.length,
              itemPositionsListener: _itemPositionsListener,
              itemBuilder: (context, index) {
                return PostWidget(
                  postModel: list[index],
                );
              }, separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            );
          }
      ),
    );
  }

}
