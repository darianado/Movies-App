part of 'index.dart';

const String _kGLoginPending = 'Login';

@freezed
class Login with _$Login implements AppAction {
  @Implements<ActionStart>()
  const factory Login.start({
    required String email,
    required String password,
    required ActionResult onResult,
    @Default(_kGLoginPending) String pendingId,
  }) = LoginStart;

  @Implements<UserAction>()
  @Implements<ActionDone>()
  const factory Login.successful(
    AppUser user, [
    @Default(_kGLoginPending) String pendingId,
  ]) = LoginSuccessful;

  @Implements<ActionDone>()
  @Implements<ErrorAction>()
  const factory Login.error(
    Object error,
    StackTrace stackTrace, [
    @Default(_kGLoginPending) String pendingId,
  ]) = LoginError;

  static String get pendingKey => _kGLoginPending;
}
