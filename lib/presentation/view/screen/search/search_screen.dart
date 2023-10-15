import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../data/model/user/simple/item/simple_user_info_model.dart';
import '../../../../data/model/user/simple/list/simple_user_list_state.dart';
import '../../../../domain/usecase/user/list/get_user_list_by_keyword_usecase.dart';
import '../../../values/color/color.dart';
import '../../../values/text/text.dart';
import '../../../viewmodel/user/list/user_list_by_keyword_viewmodel.dart';
import '../../widget/common/error/error_widget.dart';
import '../../widget/user/other_user/user_simple_profile_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  static const String routeName = "search";
  static const String routeURL = "/search";

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textEditingController = TextEditingController();

  late final UserListByKeywordViewModel _userListByKeywordViewModel;

  @override
  void initState() {
    super.initState();

    initScrollController();
    initViewModels();
    fetchData();
  }

  void initScrollController() {
    _scrollController.addListener(_scrollListener);
  }

  void initViewModels() {
    _userListByKeywordViewModel = UserListByKeywordViewModel(
      getUserListByKeywordUseCase: GetIt.instance<GetUserListByKeywordUseCase>(),
    );
  }

  /// Fetch followers/followings
  Future<void> fetchData() async {
    await _userListByKeywordViewModel.getUserListByKeyword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// Appbar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          searchUser,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      /// Screen
      body: Column(
        children: [
          /// Search keyword text input
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: greyF7F7F7,
                      /// Hint text
                      hintText: search,
                      hintStyle: const TextStyle(
                        color: greyB4B4B5,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      /// Enabled border style
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      /// Focused border style
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                        ),
                      ),
                      /// Prefix
                      prefixIcon: const Icon(Icons.search, color: darkGrey666666),
                    ),
                    minLines: 1,
                    maxLines: 1,
                    onChanged: (newKeyword) {
                      _userListByKeywordViewModel.setKeyword(value: newKeyword);
                      /// Delay for 300 milliseconds and then fetch users by new keyword
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _userListByKeywordViewModel.getUserListByKeyword();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          /// Divider
          Container(
            color: greyEEEEEF,
            height: 1,
          ),

          /// User list
          Expanded(
            child: ValueListenableBuilder<SimpleUserListState>(
              valueListenable: _userListByKeywordViewModel.userListStateNotifier,
              builder: (context, state, _) {
                /// Loading UI
                if (state is Loading && _userListByKeywordViewModel.currentList.isEmpty) {
                  return buildLoadingStateUI();
                }
                /// Fail UI
                else if (state is Fail) {
                  return buildFailStateUI();
                }
                /// Success UI (default)
                else {
                  return buildSuccessStateUI();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // TODO : Enhance the loading UI
  Widget buildLoadingStateUI() {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return const Center(
          child: SizedBox(
            width: 36,
            height: 36,
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  // Widget buildLoadingStateUI() {
  //   return LayoutBuilder(
  //     builder: (BuildContext context, BoxConstraints constraints) {
  //       return SingleChildScrollView(
  //         physics: const NeverScrollableScrollPhysics(),
  //         child: Column(
  //           children: const [
  //             PostLoadingWidget(),
  //             PostLoadingWidget(),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        fetchData();
      }),
    );
  }

  Widget buildSuccessStateUI() {
    return ValueListenableBuilder<List<SimpleUserInfoModel>>(
        valueListenable: _userListByKeywordViewModel.currentListNotifier,
        builder: (context, list, _) {
          /// List UI
          if (list.isNotEmpty) {
            return ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return UserSimpleProfileWidget(
                    simpleUserInfoModel: list[index],
                  );
                }
            );
          }
          /// Empty list UI
          else {
            return const Center(
              child: Text(
                noSearchResultFound,
                style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey
                ),
                maxLines: 3,
              ),
            );
          }
        }
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      fetchData();
    }
  }

}
