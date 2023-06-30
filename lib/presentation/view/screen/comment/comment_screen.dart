import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/comment/comment_model.dart';
import '../../../viewmodel/comment/comment_list_viewmodel.dart';
import '../../widget/comment/comment_widget.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({Key? key}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late CommentListViewModel commentListViewModel;

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    commentListViewModel = context.read<CommentListViewModel>();
    commentListViewModel.getCommentList();
    _scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Selector<CommentListViewModel, List<CommentModel>>(
          selector: (_, viewModel) => viewModel.currentList,
          builder: (context, list, _) {
            return ListView.separated(
              controller: _scrollController,
              itemCount: list.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: CommentWidget(
                    commentModel: list[index],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 20),
            );
          }),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      commentListViewModel.getCommentList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
