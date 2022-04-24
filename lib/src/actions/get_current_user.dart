
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/app_user.dart';
import 'package:movies/src/models/movie.dart';

part 'get_current_user.freezed.dart';

@freezed
class GetCurrentUser with _$GetCurrentUser implements AppAction {
  const factory GetCurrentUser() = GetCurrentUserStart;
  const factory GetCurrentUser.successful(AppUser? user) = GetCurrentUserSuccessful;

  @Implements<ErrorAction>()
  const factory GetCurrentUser.error(Object error, StackTrace stackTrace) = GetCurrentUserError;
}
