import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movies/src/models/app_user.dart';
import 'package:movies/src/models/movie.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    @Default(<Movie>[]) List<Movie> movies,
    @Default(true) bool isLoading,
    @Default(1) int page,
    AppUser? user,
  }) = AppState$;
}
