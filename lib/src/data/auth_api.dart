import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movies/src/models/index.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _favoriteMoviesKey = "user_favorite_movies";

class AuthApi {
  AuthApi(this._auth, this._preferences);

  final FirebaseAuth _auth;
  final SharedPreferences _preferences;

  Future<AppUser?> getCurrentUser() async {
    if (_auth.currentUser != null) {
      final List<int> favorites = _getCurrentFavorites();

      return AppUser(
          email: _auth.currentUser!.email!,
          uid: _auth.currentUser!.uid,
          username: _auth.currentUser!.displayName!,
          favoriteMovies:  favorites,
          );
          
    }
    return null;
  }

  Future<AppUser> login(
      {required String email, required String password}) async {
    final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    final List<int> favorites = _getCurrentFavorites();

    return AppUser(
        uid: credential.user!.uid,
        email: email,
        username: credential.user!.displayName!,
        favoriteMovies: favorites,
        );
  }

  Future<AppUser> create(
      {required String email,
      required String password,
      required String username}) async {
    final UserCredential credential = await _auth
        .createUserWithEmailAndPassword(email: email, password: password);
    await _auth.currentUser!.updateDisplayName(username);

    return AppUser(
        uid: credential.user!.uid,
        email: email,
        username: credential.user!.displayName!);
  }

  Future<void> updateFavorites(int id, {required bool add}) async {
    final List<int> ids = _getCurrentFavorites();
    if (add) {
      ids.add(id);
    } else {
      ids.remove(id);
    }

    _preferences.setString(_favoriteMoviesKey, jsonEncode(ids));
  }

  List<int> _getCurrentFavorites() {
    final String? data = _preferences.getString(_favoriteMoviesKey);
    List<int> ids;
    if (data != null) {
      ids = List<int>.from(jsonDecode(data) as List<dynamic>);
    } else {
      ids = <int>[];
    }
    return ids;
  }
}
