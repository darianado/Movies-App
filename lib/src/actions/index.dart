import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/models/index.dart';

part 'create_user.dart';
part 'get_current_user.dart';
part 'get_movies.dart';
part 'index.freezed.dart';
part 'login.dart';
part 'update_favorites.dart';
part 'logout.dart';
part 'listen_for_comments.dart';
part 'set.dart';
part 'create_comment.dart';
part 'get_user.dart';

abstract class AppAction {}

abstract class ErrorAction implements AppAction {
  Object get error;
  StackTrace get stackTrace;
}

abstract class UserAction implements AppAction {
  AppUser? get user;
}

abstract class PendingAction {
  String get pendingId;
}

abstract class ActionStart implements PendingAction {}

abstract class ActionDone implements PendingAction {}

typedef ActionResult = void Function(AppAction action);
