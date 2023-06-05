import 'package:flutter/material.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/post_list_viewmodel.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/post/post_list_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/post/post_list_state.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  static const String routeName = "feed";
  static const String routeURL = "/feed";

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

  @override
  void initState() {
    super.initState();
    context.read<PostListViewModel>().getPostList(page: 1, limit: 10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Selector<PostListViewModel, PostListState>(
        selector: (_, viewModel) => viewModel.postListState,
        builder: (context, state, _) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                if (state is Success)
                Text(
                  "${state.total}",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
