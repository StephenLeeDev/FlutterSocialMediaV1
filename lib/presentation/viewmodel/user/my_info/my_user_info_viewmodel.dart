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

  _setMyUserInfoState({required MyUserInfoState state}) {
    _myUserInfoState = state;
    if (state is Success) {
      _setMyEmail(myEmail: state.getMyUserInfo.getEmail);
    }
  }

  Future<void> getMyUserInfo() async {
    _setMyUserInfoState(state: Loading());

    final state = await _getMyUserInfoUseCase.execute();
    _setMyUserInfoState(state: state);
  }

  String _myEmail = "";
  String get myEmail => _myEmail;

  _setMyEmail({required String myEmail}) {
    _myEmail = myEmail;
  }

}