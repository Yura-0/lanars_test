
part of 'photo_bloc.dart';

abstract class BeerEvent extends Equatable {
  const BeerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPhotos extends BeerEvent {}

class LoadMorePhotos extends BeerEvent {
  final int page;

  LoadMorePhotos({required this.page});

  @override
  List<Object?> get props => [page];
}
