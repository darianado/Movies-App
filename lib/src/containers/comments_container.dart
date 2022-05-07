import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:movies/src/models/index.dart';

class CommentsContainer extends StatelessWidget {
  const CommentsContainer({Key? key, required this.builder}) : super(key: key);

  final ViewModelBuilder<List<Comment>> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Comment>>(
      converter: (Store<AppState> store) =>
          store.state.comments.where((Comment comment) => comment.movieId == store.state.selectedMovieId)
          .where((comment) => store.state.users[comment.uid]!=null)
          .toList(),
      builder: builder,
    );
  }
}
