import 'package:flutter/material.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/list/post_list_viewmodel.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/user/my_info/my_user_info_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/item/post_model.dart';
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
  late final PostListViewModel postListViewModel;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    fetchData();
  }

  Future<void> fetchData() async {
    // TODO : Relocation to inside of the MainNavigation later
    await GetIt.instance<MyUserInfoViewModel>().getMyUserInfo();

    if (context.mounted) postListViewModel = context.read<PostListViewModel>();
    postListViewModel.getPostList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () {
          return postListViewModel.refresh();
        },
        child: Selector<PostListViewModel, List<PostModel>>(
          selector: (_, viewModel) => viewModel.currentList,
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
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      context.read<PostListViewModel>().getPostList();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

}
