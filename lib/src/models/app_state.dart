part of 'index.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(1) int page,
    AppUser? user,
    @Default(<String>{}) Set<String> pending,
  }) = AppState$;
}
