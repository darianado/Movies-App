import 'package:movies/src/actions/index.dart';
import 'package:movies/src/data/auth_api.dart';
import 'package:movies/src/data/movie_api.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class MovieEpic {
  MovieEpic(this._movieApi);

  final MovieApi _movieApi;

  Epic<AppState> getEpics() {
    return combineEpics(<Epic<AppState>>[
      _getMovies,
      _listenForComments,
      TypedEpic<AppState, CreateCommentStart>(_createCommentStart),
    ]);
  }

  Stream<AppAction> _getMovies(
      Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .where((dynamic action) =>
            action is GetMoviesStart || action is GetMoviesMore)
        .flatMap((dynamic action) {
      String pendingId = '';
      ActionResult onResult = (_) {};
      if (action is GetMoviesStart) {
        pendingId = action.pendingId;
        onResult = action.onResult;
      } else if (action is GetMoviesMore) {
        pendingId = action.pendingId;
        onResult = action.onResult;
      }

      return Stream<void>.value(null)
          .asyncMap((_) => _movieApi.getMovies(store.state.page))
          .map<GetMovies>((List<Movie> movies) {
        return GetMovies.successful(movies, pendingId);
      }).onErrorReturnWith((Object error, stackTrace) {
        return GetMovies.error(error, stackTrace, pendingId);
      }).doOnData(onResult);
    });
  }

  Stream<AppAction> _listenForComments(
      Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .whereType<ListenForCommentsStart>()
        .flatMap((ListenForCommentsStart action) {
      return _movieApi
          .listenForComments(action.movieId)
          .expand((List<Comment> comments) {
        return <AppAction>[
          ListenForComments.event(comments),
          ...comments
            .where((comment) => store.state.users[comment.uid]==null)
            .map((comment) => GetUser(comment.uid))
            .toSet()
          ];
      }).takeUntil<dynamic>(actions.where((dynamic event) {
        return event is ListenForCommentsDone &&
            event.movieId == action.movieId;
      })).onErrorReturnWith($ListenForComments.error);
    });
  }

  Stream<AppAction> _createCommentStart(
      Stream<CreateCommentStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((action) {
      return Stream<void>.value(null)
          .asyncMap((_) => _movieApi.createComment(
                uid: store.state.user!.uid,
                movieId: store.state.selectedMovieId!,
                text: action.text,
              ))
          .mapTo(const CreateComment.successful())
          .onErrorReturnWith($CreateComment.error);
    });
  }
}
