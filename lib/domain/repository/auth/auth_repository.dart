import '../../../data/model/auth/auth_request.dart';
import '../../../data/model/auth/auth_state.dart';

abstract class AuthRepository {
  Future<AuthState> signIn({required AuthRequest authRequest});
}
