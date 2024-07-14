part of 'photo_bloc.dart';

abstract class BeerState extends Equatable {
  const BeerState();

  @override
  List<Object?> get props => [];
}

class BeerInitial extends BeerState {}

class PhotosLoaded extends BeerState {
  final List<Photo> photos;

  const PhotosLoaded({required this.photos});

  @override
  List<Object?> get props => [photos];
}

class PhotosError extends BeerState {
  final String message;

  const PhotosError({required this.message});

  @override
  List<Object?> get props => [message];
}
