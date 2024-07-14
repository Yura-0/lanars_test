import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  final List<Photo> _photosCache = [];
  bool _isLoading = false;
  int _currentPage = 1;
  StreamSubscription? _beerBlocSubscription;

  final _alphabet =
      List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadPhotos();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge && _scrollController.position.pixels != 0) {
      _loadMorePhotos();
    }
  }

  Future<void> _loadPhotos() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final BeerBloc beerBloc = context.read<BeerBloc>();
    beerBloc.add(LoadPhotos(page: _currentPage));
    _currentPage++;

    _beerBlocSubscription?.cancel();
    _beerBlocSubscription = beerBloc.stream.listen((state) {
      if (state is PhotosLoaded) {
        setState(() {
          final Set<int> existingPhotoIds = _photosCache.map((photo) => photo.id).toSet();
          final List<Photo> newPhotos = state.photos.where((photo) => !existingPhotoIds.contains(photo.id)).toList();
          
          // Limit new photos to ensure total photos don't exceed 50
          final int currentTotalPhotos = _photosCache.length;
          if (currentTotalPhotos + newPhotos.length > 50) {
            final int remainingSpace = 50 - currentTotalPhotos;
            _photosCache.addAll(newPhotos.take(remainingSpace));
          } else {
            _photosCache.addAll(newPhotos);
          }

          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadMorePhotos() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    final BeerBloc beerBloc = context.read<BeerBloc>();
    beerBloc.add(LoadMorePhotos(page: _currentPage));
    _currentPage++;

    _beerBlocSubscription?.cancel();
    _beerBlocSubscription = beerBloc.stream.listen((state) {
      if (state is PhotosLoaded) {
        setState(() {
          final Set<int> existingPhotoIds = _photosCache.map((photo) => photo.id).toSet();
          final List<Photo> newPhotos = state.photos.where((photo) => !existingPhotoIds.contains(photo.id)).toList();
          
          // Limit new photos to ensure total photos don't exceed 50
          final int currentTotalPhotos = _photosCache.length;
          if (currentTotalPhotos + newPhotos.length > 50) {
            final int remainingSpace = 50 - currentTotalPhotos;
            _photosCache.addAll(newPhotos.take(remainingSpace));
          } else {
            _photosCache.addAll(newPhotos);
          }

          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _beerBlocSubscription?.cancel();
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
          if (state is BeerInitial || _isLoading && _photosCache.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PhotosLoaded || _photosCache.isNotEmpty) {
            final photos = _photosCache;
            final Map<String, List<Photo>> alphabetMap = {};

            for (var photo in photos) {
              final firstLetter = photo.photographer[0].toUpperCase();
              if (!alphabetMap.containsKey(firstLetter)) {
                alphabetMap[firstLetter] = [];
              }
              alphabetMap[firstLetter]!.add(photo);
            }

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
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _alphabet.length,
                    itemBuilder: (context, index) {
                      final letter = _alphabet[index];
                      final photosForLetter = alphabetMap[letter] ?? [];

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
                                      leading: CachedNetworkImage(
                                        imageUrl: photo.imageUrl,
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => const Image(
                                          image: AssetImage('assets/images/default_avatar.png'),
                                        ),
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

