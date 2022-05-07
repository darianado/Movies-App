import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:movies/src/actions/index.dart';
import 'package:movies/src/containers/home_page_container.dart';
import 'package:movies/src/containers/movies_container.dart';
import 'package:movies/src/containers/pending_container.dart';
import 'package:movies/src/containers/user_container.dart';
import 'package:movies/src/models/index.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();
  String genre = "";

  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false)
        .dispatch(GetMovies.start(genre, _onResult));
    _controller.addListener(_onScroll);
  }

  void _onScroll() {
    final double extent = _controller.position.maxScrollExtent;
    final double offset = _controller.offset;
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final bool isLoading = <String>[
      GetMovies.pendingKey,
      GetMovies.pendingKeyMore,
    ].any(store.state.pending.contains);
    if (offset >= extent - MediaQuery.of(context).size.height && !isLoading) {
      StoreProvider.of<AppState>(context)
          .dispatch(GetMovies.more(genre, _onResult));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onResult(AppAction action) {
    if (action is GetMoviesSuccessful) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("page loaded")));
    } else if (action is GetMoviesError) {
      final Object error = action.error;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $error")));
    }
  }

  // void onSelected(context, item) {
  //   StoreProvider.of<AppState>(context, listen: false)
  //       .dispatch(GetMoviesGenre.start(item.toString(), _onResult));
  // }

  @override
  Widget build(BuildContext context) {
    // final Store<AppState> store = StoreProvider.of<AppState>(context);
    return HomePageContainer(
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFFD4D1E6),
            foregroundColor: Color(0xFF231123),
            actions: [
              PopupMenuButton<String>(
                onSelected: (item) {
                  state.movies.clear();
                  genre = item.toString();
                  StoreProvider.of<AppState>(context, listen: false)
                      .dispatch(GetMovies.start(genre, _onResult));
                },
                itemBuilder: (context) => [
                  const PopupMenuItem<String>(
                    value: "",
                    child: Text("All"),
                  ),
                   const PopupMenuItem<String>(
                    value: "Action",
                    child: Text("Action"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Adventure",
                    child: Text("Adventure"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Animation",
                    child: Text("Animation"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Comedy",
                    child: Text("Comedy"),
                  ),
                   const PopupMenuItem<String>(
                    value: "Drama",
                    child: Text("Drama"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Romance",
                    child: Text("Romance"),
                  ),
                  const PopupMenuItem<String>(
                    value: "Thriller",
                    child: Text("Thriller"),
                  ),
                ],
              ),
            ],
            leading: IconButton(
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(const Logout());
              },
              icon: const Icon(Icons.power_settings_new),
            ),
            title: const Text('Movies'),
          ),
          body: PendingContainer(
            builder: (BuildContext context, Set<String> pending) {
              return MoviesContainer(
                builder: (BuildContext context, List<Movie> movies) {
                  final isLoading =
                      state.pending.contains(GetMovies.pendingKey) ;
                  final isLoadingMore =
                      state.pending.contains(GetMovies.pendingKey) ;
                  if (isLoading && movies.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // print(movies[0]);
                  return UserContainer(
                    builder: (BuildContext context, AppUser? user) {
                      // ignore: dead_code
                      return ListView.builder(
                        controller: _controller,
                        itemCount: movies.length + (isLoading ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == movies.length) {
                            return const CircularProgressIndicator();
                          }
                          final Movie movie = movies[index];

                          final bool isFavorite =
                              user!.favoriteMovies.contains(movie.id);

                          return GestureDetector(
                            onTap: () {
                              StoreProvider.of<AppState>(context)
                                  .dispatch(SetSelectedMovieId(movie.id));
                              Navigator.pushNamed(context, '/comments');
                            },
                            child: Column(
                              children: <Widget>[
                                Stack(children: <Widget>[
                                  SizedBox(
                                    height: 320,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top:33.0),
                                      child: Image.network(movie.poster),
                                    ),
                                  ),
                                  IconButton(
                                      iconSize: 50,
                                      color:Color(0xFF82204A),
                                      onPressed: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(UpdateFavorites(movie.id,
                                                add: !isFavorite));
                                      },
                                      icon: Icon(isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border))
                                ]),
                                Center(
                                  child: Text(movie.title,style:TextStyle(fontSize: 20,),),
                                ),
                                Center(
                                  child: Text(movie.genres.join(', ')),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
