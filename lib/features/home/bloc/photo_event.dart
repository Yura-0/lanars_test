
part of 'photo_bloc.dart';

// events.dart
abstract class BeerEvent {}

class LoadPhotos extends BeerEvent {
  final int page;

  LoadPhotos({this.page = 1});
}

class LoadMorePhotos extends BeerEvent {
  final int page;

  LoadMorePhotos({required this.page});
}
