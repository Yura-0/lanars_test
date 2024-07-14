import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/bloc/auth_bloc.dart';
import '../bloc/photo_bloc.dart';
import '../models/photo_model.dart';
import '../widgets/user_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  final _alphabet = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<BeerBloc>().add(LoadPhotos());
  }

  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      final currentState = context.read<BeerBloc>().state;
      if (currentState is PhotosLoaded) {
        final page = (currentState.photos.length ~/ 10) + 1;
        context.read<BeerBloc>().add(LoadMorePhotos(page: page));
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'List Page',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthSuccess) {
            return UserDrawer(user: state.user);
          } else {
            return const UserDrawer(user: null);
          }
        },
      ),
      body: BlocBuilder<BeerBloc, BeerState>(
        builder: (context, state) {
          if (state is BeerInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotosLoaded) {
            final photos = state.photos;
            final Map<String, List<Photo>> alphabetMap = {};

            for (var photo in photos) {
              final firstLetter = photo.photographer[0].toUpperCase();
              if (!alphabetMap.containsKey(firstLetter)) {
                alphabetMap[firstLetter] = [];
              }
              alphabetMap[firstLetter]!.add(photo);
            }

            print('Alphabet Map Length: ${alphabetMap.length}');

            return Row(
              children: [
                Container(
                  width: 50,
                  child: ListView.builder(
                    itemCount: _alphabet.length,
                    itemBuilder: (context, index) {
                      final letter = _alphabet[index];
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          letter,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      context.read<BeerBloc>().add(LoadPhotos());
                    },
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _alphabet.length,
                      itemBuilder: (context, index) {
                        final letter = _alphabet[index];
                        final photosForLetter = alphabetMap[letter] ?? [];

                        if (photosForLetter.isEmpty) {
                          print('Letter $letter has no photos');
                        }

                        return photosForLetter.isNotEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  ...photosForLetter.map((photo) {
                                    return Card(
                                      child: ListTile(
                                        leading: Image.network(
                                          photo.imageUrl,
                                          height: 50,
                                          width: 50,
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text(photo.photographer),
                                        subtitle: Text(
                                          'Photo ID: ${photo.id}',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    );
                                  }),
                                ],
                              )
                            : Container();
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is PhotosError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Check your internet connection'));
          }
        },
      ),
    );
  }
}
