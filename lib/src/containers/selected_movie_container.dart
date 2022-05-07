import 'package:flutter/cupertino.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

class SelectedMovieContainer extends StatelessWidget {
  const SelectedMovieContainer({Key? key, required this.builder}) : super(key: key);

  final ViewModelBuilder<Movie> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState,Movie>(
      converter: (Store<AppState> store) => store.state.movies.firstWhere((Movie element) => element.id==store.state.selectedMovieId),
      builder: builder,
    );
  }
}
