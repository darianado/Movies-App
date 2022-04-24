
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/app_user.dart';
import 'package:movies/src/models/movie.dart';

part 'login.freezed.dart';

@freezed
class Login with _$Login implements AppAction {
  const factory Login({
    required String email, 
    required String password,
    required ActionResult onResult,
  }) = LoginStart;

  const factory Login.successful(AppUser user) = LoginSuccessful;
 
  @Implements<ErrorAction>()
  const factory Login.error(Object error, StackTrace stackTrace) = LoginError;
}
