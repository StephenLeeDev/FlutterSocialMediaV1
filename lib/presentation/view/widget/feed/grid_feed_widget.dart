import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/item/post_model.dart';
import '../../../viewmodel/post/list/other_user_post_list_viewmodel.dart';
import 'post_grid_widget.dart';

class GridFeedWidget extends StatefulWidget {
  const GridFeedWidget({Key? key}) : super(key: key);

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
                isFromMyPage: true,
                onTap: () {
                  /// Move to the selected item's index in the FeedFragment
                  // TODO : Move to the next page in this PageView
                },
              ),
            );
          },
        );
      },
    );
  }
}
