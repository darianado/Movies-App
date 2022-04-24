part of 'index.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(true) bool isLoading,
    @Default(1) int page,
    AppUser? user,
  }) = AppState$;
}
