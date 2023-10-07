import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../data/model/dm/room/item/dm_room_model.dart';
import '../../../../../data/model/dm/room/list/dm_room_list_state.dart';
import '../../../../viewmodel/dm/room/list/dm_room_list_viewmodel.dart';
import '../../../widget/common/error/error_widget.dart';
import '../../../widget/dm/room/dm_room_item_widget.dart';

class DmRoomListScreen extends StatefulWidget {
  const DmRoomListScreen({Key? key}) : super(key: key);

  static const String routeName = "dm/list";
  static const String routeURL = "/dm/list";

  @override
  State<DmRoomListScreen> createState() => _DmRoomListScreenState();
}

class _DmRoomListScreenState extends State<DmRoomListScreen> {

  final ScrollController _scrollController = ScrollController();

  late final DmRoomListViewModel _dmRoomListViewModel;

  @override
  void initState() {
    super.initState();

    _initViews();
    _initViewModels();
    _fetchData();
  }

  void _initViews() {
    _scrollController.addListener(_scrollListener);
  }

  void _initViewModels() {
    _dmRoomListViewModel = context.read<DmRoomListViewModel>();
  }

  Future<void> _fetchData() async {
    await _dmRoomListViewModel.getDmRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// AppBar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text(
          "DMs",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
      /// Screen
      body: ValueListenableBuilder<DmRoomListState>(
        valueListenable: _dmRoomListViewModel.dmRoomListStateNotifier,
        builder: (context, state, _) {
          /// Loading UI
          if (state is Loading && _dmRoomListViewModel.currentList.isEmpty) {
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

  Widget buildFailStateUI() {
    return Center(
      child: CustomErrorWidget(listener: () {
        _fetchData();
      }),
    );
  }

  Widget buildSuccessStateUI() {
    return RefreshIndicator(
      onRefresh: () {
        return _dmRoomListViewModel.refresh();
      },
      child: ValueListenableBuilder<List<DmRoomModel>>(
          valueListenable: _dmRoomListViewModel.currentListNotifier,
          builder: (context, list, _) {
            return ListView.builder(
                controller: _scrollController,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return DmRoomItemWidget(
                    dmRoomModel: list[index],
                  );
                }
            );
          }
      ),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter == 0) {
      _fetchData();
    }
  }

}
