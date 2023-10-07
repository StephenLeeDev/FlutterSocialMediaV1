import 'package:dio/dio.dart';
import 'package:flutter_social_media_v1/data/model/dm/room/item/dm_room_item_state.dart';
import 'package:flutter_social_media_v1/data/model/dm/room/item/dm_room_model.dart';
import 'package:flutter_social_media_v1/data/repository/dm/dm_repository_impl.dart';
import 'package:flutter_social_media_v1/domain/usecase/dm/room/create_dm_room_usecase.dart';
import 'package:flutter_social_media_v1/presentation/viewmodel/dm/room/create/create_dm_room_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  final dmRepository = DmRepositoryImpl(Dio());
  final viewModel = CreateDmRoomViewModel(
    createDmRoomUseCase: CreateDmRoomUseCase(dmRepository: dmRepository),
  );

  group("setCreateDmRoomState", () {
    test("Set Ready", () {
      viewModel.setCreateDmRoomState(state: Ready());
      expect(viewModel.createDmRoomState is Ready, true);
    });

    test("Set Loading", () {
      viewModel.setCreateDmRoomState(state: Loading());
      expect(viewModel.createDmRoomState is Loading, true);
    });

    test("Set Fail", () {
      viewModel.setCreateDmRoomState(state: Fail());
      expect(viewModel.createDmRoomState is Fail, true);
    });

    test("Set Success", () {
      const id = 1;
      viewModel.setCreateDmRoomState(state: Success(item: DmRoomModel(id: id)));
      expect(viewModel.createDmRoomState is Success, true);

      if (viewModel.createDmRoomState is Success) {
        final state = viewModel.createDmRoomState as Success;
        expect(state.item.id, id);
      }
    });
  });
}