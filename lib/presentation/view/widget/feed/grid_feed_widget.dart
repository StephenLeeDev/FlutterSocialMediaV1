import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../../viewmodel/post/list/other_user_post_list_viewmodel.dart';
import '../../screen/feed/feed_screen_from_grid.dart';
import 'post_grid_widget.dart';

class GridFeedWidget extends StatefulWidget {
  const GridFeedWidget({Key? key, this.isFromMyPage = true, this.scrollController}) : super(key: key);

  final bool isFromMyPage;
  final ItemScrollController? scrollController;

  @override
  State<GridFeedWidget> createState() => _GridFeedWidgetState();
}

class _GridFeedWidgetState extends State<GridFeedWidget> {

  late final OtherUserPostGridListViewModel _postListViewModel;

  @override
  void initState() {
    super.initState();

    _initViewModels();
  }

  /// Initialize ViewModels
  void _initViewModels() {
    _initListViewModel();
  }

  /// Initialize feed ViewModel
  void _initListViewModel() {
    _postListViewModel = context.read<OtherUserPostGridListViewModel>();
  }

  @override
  Widget build(BuildContext context) {
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
                isFromMyPage: widget.isFromMyPage,
                onTap: () {
                  /// Move to the selected item's index in the FeedScreen
                  context.pushNamed(
                      FeedScreenFromGrid.routeName,
                      queryParameters: {
                        "isFromMyPage": "false",
                        "selectedIndex": "$index",
                        "title": "${list[index].getUserName}'s feed",
                      }
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
