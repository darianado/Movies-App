import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/models/index.dart';
import 'package:movies/src/reducer/auth_reducer.dart';

Future<void> main() async {
  final Map<String, dynamic> stateData = jsonDecode(
      File('./test/unit/reducer/res/state_with_user.json')
          .readAsStringSync()) as Map<String, dynamic>;
  final Map<String, dynamic> userData =
      jsonDecode(File('./test/unit/reducer/res/user.json').readAsStringSync())
          as Map<String, dynamic>;

  test('_logoutSuccessful', () {
    final AppState initial = AppState.fromJson(stateData);
    final result = authReducer(initial, const Logout.successful());
    expect(result.user, isNull);
  });

  test('_userAction', () {
    const AppState initial = AppState();
    final AppUser user = AppUser.fromJson(userData);
    final result = authReducer(initial, Login.successful(user));
    expect(result, isNotNull);
  });

  group("_updateFavoritesStart", () {
    final AppState initial = AppState.fromJson(stateData);
    test('add', () {
      const action = UpdateFavorites(4, add: true);
      final result = authReducer(initial, action);
      expect(result.user!.favoriteMovies, [1, 2, 3, 4]);
    });
    test('remove', () {
    const action = UpdateFavorites(3, add: false);
    final result = authReducer(initial, action);
    expect(result.user!.favoriteMovies, [1,2]);
  });
  });
}
