import 'package:flutter/foundation.dart';
import 'package:flutter_social_media_v1/data/model/user/my_user_info_state.dart';
import 'package:flutter_social_media_v1/domain/usecase/user/get_my_user_info_usecase.dart';

class MyUserInfoViewModel extends ChangeNotifier {
  final GetMyUserInfoUseCase _getMyUserInfoUseCase;

  MyUserInfoViewModel({
    required GetMyUserInfoUseCase getMyUserInfoUseCase,
  }) : _getMyUserInfoUseCase = getMyUserInfoUseCase;

  MyUserInfoState _myUserInfoState = Ready();
  MyUserInfoState get myUserInfoState => _myUserInfoState;

  setMyUserInfoState({required MyUserInfoState state}) {
    _myUserInfoState = state;
  }

  Future<void> getMyUserInfo() async {
    setMyUserInfoState(state: Loading());

    final state = await _getMyUserInfoUseCase.execute();
    setMyUserInfoState(state: state);
  }

}