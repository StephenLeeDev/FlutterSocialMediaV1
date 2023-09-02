import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../viewmodel/user/other_user/get_user_info/other_user_info_viewmodel.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {

  late final OtherUserInfoViewModel _otherUserInfoViewModel;

  @override
  void initState() {
    super.initState();

    _initViewModels();
  }

  /// Initialize ViewModels
  void _initViewModels() {
    _initUserInfoViewModel();
  }

  /// Initialize user information ViewModel
  void _initUserInfoViewModel() {
    _otherUserInfoViewModel = context.read<OtherUserInfoViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),

          Row(
            children: [
              /// User thumbnail
              Container(
                margin: const EdgeInsets.only(right: 0),
                width: 120,
                height: 120,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ValueListenableBuilder<String>(
                  valueListenable: _otherUserInfoViewModel.thumbnailNotifier,
                  builder: (context, thumbnail, _) {
                    return Image.network(
                      thumbnail,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    /// Posts
                    Expanded(
                      child: Column(
                        children: [
                          /// Total posts count
                          ValueListenableBuilder<int>(
                            valueListenable: _otherUserInfoViewModel.totalPostCountNotifier,
                            builder: (context, total, _) {
                              return Text(
                                "$total",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const Text(
                            "Posts",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Followers
                    Expanded(
                      child: Column(
                        children: [
                          /// Total follower count
                          ValueListenableBuilder<int>(
                            valueListenable: _otherUserInfoViewModel.totalFollowerCountNotifier,
                            builder: (context, total, _) {
                              return Text(
                                "$total",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const Text(
                            "Followers",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Following
                    Expanded(
                      child: Column(
                        children: [
                          /// Total following count
                          ValueListenableBuilder<int>(
                            valueListenable: _otherUserInfoViewModel.totalFollowingCountNotifier,
                            builder: (context, total, _) {
                              return Text(
                                "$total",
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          /// Status message
          /// It's not visible when status message is empty
          ValueListenableBuilder<String>(
            valueListenable: _otherUserInfoViewModel.statusMessageNotifier,
            builder: (context, message, _) {
              /// Status message exists
              if (message.isNotEmpty) {
                return Container(
                  constraints: const BoxConstraints(
                    minHeight: 50.0,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      message,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              /// Empty status message space
              else {
                return const SizedBox(height: 50);
              }
            },
          ),
        ],
      ),
    );
  }
}
