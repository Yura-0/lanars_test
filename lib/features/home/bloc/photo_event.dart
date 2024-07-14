
part of 'photo_bloc.dart';

// events.dart
abstract class PhotoEvent {}

class LoadPhotos extends PhotoEvent {
  final int page;

  LoadPhotos({this.page = 1});
}

class LoadMorePhotos extends PhotoEvent {
  final int page;

  LoadMorePhotos({required this.page});
}
