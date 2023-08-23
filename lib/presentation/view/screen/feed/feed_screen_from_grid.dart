import 'package:flutter/material.dart';

import 'fragment/feed_fragment.dart';

/// It's another feed screen called from grid list screen, just like Instagram's
/// I separated it because it has little different features between FeedScreen
// TODO : Might integrate both, but low priority
class FeedScreenFromGrid extends StatelessWidget {
  const FeedScreenFromGrid({Key? key, required this.selectedPostId}) : super(key: key);

  static const String routeName = "feedFromGrid";
  static const String routeURL = "/feedFromGrid";

  final int selectedPostId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FeedFragment(
        isFromMyPage: true,
        selectedPostId: selectedPostId,
      ),
    );
  }
}
