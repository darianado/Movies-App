part of 'index.dart';

const String _kGCreateCommentPendingId = 'CreateComment';

@freezed
class CreateComment with _$CreateComment implements AppAction {
  @Implements<ActionStart>()
  const factory CreateComment.start(
    String text, {
    @Default(_kGCreateCommentPendingId) String pendingId,
  }) = CreateCommentStart;

  @Implements<ActionDone>()
  const factory CreateComment.successful([
    @Default(_kGCreateCommentPendingId) String pendingId,
  ]) = CreateCommentSuccessful;

  @Implements<ActionDone>()
  @Implements<ErrorAction>()
  const factory CreateComment.error(
    Object error,
    StackTrace stackTrace, [
    @Default(_kGCreateCommentPendingId) String pendingId,
  ]) = CreateCommentError;

  static String get pendingKey => _kGCreateCommentPendingId;
}
