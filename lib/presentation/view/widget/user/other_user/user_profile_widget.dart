import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/common/single_integer_state.dart' as SingleIntegerState;
import '../../../../../data/model/dm/room/item/dm_room_item_state.dart' as DmRoomItemState;
import '../../../../../domain/usecase/dm/room/create_dm_room_usecase.dart';
import '../../../../../domain/usecase/follow/start_follow_usecase.dart';
import '../../../../../domain/usecase/follow/unfollow_usecase.dart';
import '../../../../util/dialog/dialog_util.dart';
import '../../../../values/color/color.dart';
import '../../../../values/text/text.dart';
import '../../../../viewmodel/dm/room/create/create_dm_room_viewmodel.dart';
import '../../../../viewmodel/dm/room/list/dm_room_list_viewmodel.dart';
import '../../../../viewmodel/follow/create_delete/follow_viewmodel.dart';
import '../../../../viewmodel/user/other_user/get_user_info/other_user_info_viewmodel.dart';
import '../../../screen/dm/room/dm_room_screen.dart';
import '../../../screen/follow/follow_list_screen.dart';
import '../../common/button/custom_animated_button.dart';

class UserProfileWidget extends StatefulWidget {
  const UserProfileWidget({Key? key}) : super(key: key);

  @override
  State<UserProfileWidget> createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> {

  late final OtherUserInfoViewModel _otherUserInfoViewModel;
  late final FollowViewModel _followViewModel;
  late final CreateDmRoomViewModel _createDmRoomViewModel;
  late final DmRoomListViewModel _dmRoomListViewModel;

  @override
  void initState() {
    super.initState();

    _initViewModels();
  }

  /// Initialize ViewModels
  void _initViewModels() {
    _initUserInfoViewModel();
    _initFollowViewModel();
    _initCreateDmRoomViewModel();
    _initDmRoomListViewModel();
  }

  /// Initialize user information ViewModel
  void _initUserInfoViewModel() {
    _otherUserInfoViewModel = context.read<OtherUserInfoViewModel>();
  }

  /// Initialize follow ViewModel
  void _initFollowViewModel() {
    _followViewModel = FollowViewModel(
      startFollowUseCase: GetIt.instance<StartFollowUseCase>(),
      unfollowUseCase: GetIt.instance<UnfollowUseCase>(),
    );
  }

  /// Initialize create DM room ViewModel
  void _initCreateDmRoomViewModel() {
    _createDmRoomViewModel = CreateDmRoomViewModel(
      createDmRoomUseCase: GetIt.instance<CreateDmRoomUseCase>(),
    );
  }

  /// Initialize DM room list ViewModel
  void _initDmRoomListViewModel() {
    _dmRoomListViewModel = context.read<DmRoomListViewModel>();
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
                      child: GestureDetector(
                        onTap: () {
                          /// Move to the follower list screen
                          context.pushNamed(
                            FollowListScreen.routeName,
                            queryParameters: {
                              "userEmail": _otherUserInfoViewModel.email,
                              "isFollowerMode": "true",
                            },
                          );
                        },
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
                    ),

                    /// Following
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          /// Move to the following list screen
                          context.pushNamed(
                            FollowListScreen.routeName,
                            queryParameters: {
                              "userEmail": _otherUserInfoViewModel.email,
                              "isFollowerMode": "false",
                            },
                          );
                        },
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
          const SizedBox(height: 8),

          Row(
            children: [

              /// Follow/Unfollow button
              Flexible(
                flex: 1,
                child: ValueListenableBuilder<bool>(
                    valueListenable: _otherUserInfoViewModel.isFollowingNotifier,
                    builder: (context, isFollowing, _) {
                      return CustomAnimatedButton(
                        text: isFollowing ? following : follow,
                        color: lightBlue00A7FF,
                        isEnabled: isFollowing,
                        /// [Unfollow]
                        /// Current state is [Following] the user
                        /// Execute unfollowing API
                        onPositiveListener: () async {
                          /// Avoid multiple calling
                          if (_followViewModel.unfollowingState is SingleIntegerState.Loading) return;
                          /// Execute unfollowing API
                          final unFollowState = await _followViewModel.unfollowTheUser(userEmail: _otherUserInfoViewModel.email);
                          /// Unfollow successfully
                          if (unFollowState is SingleIntegerState.Success) {
                            _otherUserInfoViewModel.setTotalFollowerCount(totalFollowerCount: unFollowState.getValue);
                            _otherUserInfoViewModel.setIsFollowing(isFollowing: false);
                          }
                          else {
                            showErrorMessageDialog();
                          }
                        },
                        /// [Follow]
                        /// Current state is [Unfollowing] the user
                        /// Execute start following API
                        onNegativeListener: () async {
                          /// Avoid multiple calling
                          if (_followViewModel.followingState is SingleIntegerState.Loading) return;
                          /// Execute unfollowing API
                          final followState = await _followViewModel.startFollowTheUser(userEmail: _otherUserInfoViewModel.email);
                          /// Unfollow successfully
                          if (followState is SingleIntegerState.Success) {
                            _otherUserInfoViewModel.setTotalFollowerCount(totalFollowerCount: followState.getValue);
                            _otherUserInfoViewModel.setIsFollowing(isFollowing: true);
                          }
                          else {
                            showErrorMessageDialog();
                          }
                        },
                      );
                    }
                ),
              ),

              const SizedBox(width: 8),

              /// Direct Message
              Flexible(
                flex: 1,
                child: CustomAnimatedButton(
                  text: message,
                  color: lightBlue00A7FF,
                  /// Create the DM room, and move to the created room; or move to the existing DM room
                  onPositiveListener: () async {
                    final state = await _createDmRoomViewModel.createDmRoom(receiverEmail: _otherUserInfoViewModel.email);
                    /// Success
                    if (state is DmRoomItemState.Success && context.mounted) {
                      /// When created, add the room on the DM room list
                      if (!_dmRoomListViewModel.isAlreadyExisting(dmRoomId: state.item.getRoomId)) {
                        _dmRoomListViewModel.prependNewListToCurrentList(additionalList: [state.item]);
                      }
                      context.pushNamed(DmRoomScreen.routeName);
                    }
                    /// Fail
                    else {
                      showErrorMessageDialog();
                    }

                  },
                ),
              )

            ],
          ),

        ],
      ),
    );
  }

  void showErrorMessageDialog() {
    showTwoButtonDialog(
      context: context,
      title: whoops,
      message: somethingWentWrongPleaseTryAgain,
      firstButtonText: ok,
    );
  }

}
