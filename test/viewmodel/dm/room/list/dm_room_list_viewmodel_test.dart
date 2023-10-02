import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/dm/room/item/dm_room_model.dart';
import 'package:flutter_social_media_v1/data/model/dm/room/list/dm_room_list_state.dart';
import 'package:flutter_social_media_v1/data/repository/dm/dm_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/dm/room/get_dm_room_list_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/dm/room/list/dm_room_list_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {

  final dmRepository = DmRepositoryImpl(Dio());
  final viewModel = DmRoomListViewModel(
    getDmRoomListUseCase: GetDmRoomListUseCase(dmRepository: dmRepository),
  );

  group("setDmRoomListState", () {
    test("Set Ready", () {
      viewModel.setDmRoomListState(dmRoomListState: Ready());
      expect(viewModel.dmRoomListState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setDmRoomListState(dmRoomListState: Loading());
      expect(viewModel.dmRoomListState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setDmRoomListState(dmRoomListState: Fail());
      expect(viewModel.dmRoomListState is Fail, true);
    });

    test("Set Success", () {
      viewModel.setDmRoomListState(dmRoomListState: Success(total: 0, list: []));
      expect(viewModel.dmRoomListState is Success, true);
    });
  });

  /// It contains [_setPage] unit test
  group("increasePage", () {
    test("Increase page", () {
      final initialPage = viewModel.page;
      viewModel.increasePage();
      expect(viewModel.page, initialPage + 1);
    });
  });

  group("setHasNext", () {
    test("Set hasNext", () {
      viewModel.setHasNext(value: true);
      expect(viewModel.hasNext, true);

      viewModel.setHasNext(value: false);
      expect(viewModel.hasNext, false);
    });
  });

  group("setCurrentList", () {
    test("set currentList", () {
      viewModel.setCurrentList(list: []);
      expect(viewModel.currentList, []);

      viewModel.setCurrentList(list: [DmRoomModel(id: 1)]);
      expect(viewModel.currentList.length, 1);
      expect(viewModel.currentList.first.getRoomId, 1);
    });
  });

  group("addAdditionalList", () {
    test("Add additional list", () {
      viewModel.addAdditionalList(additionalList: [DmRoomModel(id: 1)]);
      expect(viewModel.currentList.last.getRoomId, 1);

      viewModel.addAdditionalList(additionalList: [DmRoomModel(id: 2)]);
      expect(viewModel.currentList.last.getRoomId, 2);
    });
  });

  group("prependNewItemToList", () {
    test("Prepend new item to the currentList", () {
      viewModel.reinitialize();
      viewModel.prependNewListToCurrentList(additionalList: [DmRoomModel(id: 3)]);
      expect(viewModel.currentList.first.getRoomId, 3);

      viewModel.prependNewListToCurrentList(index: 1, additionalList: [DmRoomModel(id: 4)]);
      expect(viewModel.currentList.last.getRoomId, 4);
    });
  });

  group("reinitialize", () {
    test("Reinitialize", () {
      viewModel.prependNewListToCurrentList(additionalList: [DmRoomModel(id: 6)]);
      viewModel.setHasNext(value: false);

      viewModel.reinitialize();

      expect(viewModel.currentList.isEmpty, true);
      expect(viewModel.hasNext, true);
    });
  });

  group("removeItemFromListById", () {
    test("Remove specific DM room from the current list by room ID", () {
      viewModel.reinitialize();
      viewModel.addAdditionalList(additionalList: [DmRoomModel(id: 8), DmRoomModel(id: 9), DmRoomModel(id: 10)]);
      viewModel.removeItemFromListById(dmRoomId: 8);

      expect(viewModel.currentList.length, 2);

      final firstItemId = viewModel.currentList.first.getRoomId;
      expect(firstItemId, 9);

      final secondItemId = viewModel.currentList.last.getRoomId;
      expect(secondItemId, 10);
    });
  });

}