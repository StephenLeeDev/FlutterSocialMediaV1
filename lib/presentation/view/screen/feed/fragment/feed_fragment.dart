import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../data/model/post/item/post_model.dart';
import '../../../../viewmodel/post/list/current_user_post_grid_list_viewmodel.dart';
import '../../../../viewmodel/post/list/other_user_post_list_viewmodel.dart';
import '../../../../viewmodel/post/list/post_list_viewmodel.dart';
import '../../../../viewmodel/user/current_user/get_user_info/current_user_info_viewmodel.dart';
import '../../../widget/feed/post_widget.dart';

class FeedFragment extends StatefulWidget {
  const FeedFragment({Key? key, this.isFromMyPage = false, this.selectedIndex, this.title = ""}) : super(key: key);

  final bool isFromMyPage;
  final int? selectedIndex; /// Selected post's index from grid feed list screen
  final String title; /// Feed's title for appbar

  @override
  State<FeedFragment> createState() => _FeedFragmentState();
}

class _FeedFragmentState extends State<FeedFragment> {
  final ItemScrollController _scrollController = ItemScrollController();
  late final ItemPositionsListener _itemPositionsListener;

  late final CurrentUserInfoViewModel _myUserInfoViewModel;
  late final PostListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();

    initViewModels();
    _initPositionListener();

    /// Jump to the selected post
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final selected = widget.selectedIndex ?? -1;
      if (selected >= 0) {
        _scrollController.jumpTo(index: selected);
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
    _myUserInfoViewModel = context.read<CurrentUserInfoViewModel>();
  }

  /// List
  /// This FeedFragment is used from multiple screens, so _postListViewModel branching is needed
  void initListViewModel() {
    if (widget.isFromMyPage) {
      _postListViewModel = context.read<CurrentUserPostGridListViewModel>();
      _postListViewModel.setMyEmail(value: _myUserInfoViewModel.myEmail);
    } else {
      _postListViewModel = context.read<OtherUserPostGridListViewModel>();
    }
  }

  void fetchData() async {
    await fetchPostList();
  }

  /// Fetch feed
  Future<void> fetchPostList() async {
    await _postListViewModel.getPostList();
  }

  /// Initialize ItemPositionsListener
  void _initPositionListener() {
    _itemPositionsListener = ItemPositionsListener.create();

    _itemPositionsListener.itemPositions.addListener(() {
      final itemPositions = _itemPositionsListener.itemPositions;
      // QUESTION : Sometimes, ValueNotifier<Iterable<ItemPosition>> issue occurs here
      // QUESTION : It's rarely happens, and I don't know why yet
      // QUESTION : Luckily, it does not cause critical issues such as NPE
      // QUESTION : So I just added a simple conditional statement for the exception
      if (itemPositions.value.isNotEmpty) {
        final currentIndex = itemPositions.value.last.index ?? 0;
        final currentListLength = _postListViewModel.currentList.length - 1;

        /// It means, reached the bottom
        /// Load more feed
        if (currentIndex == currentListLength) {
          fetchPostList();
        }
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
        body: buildSuccessStateUI(),
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
                  isAbleToMoveUserDetailScreen: false,
                );
              }, separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            );
          }
      ),
    );
  }

}
