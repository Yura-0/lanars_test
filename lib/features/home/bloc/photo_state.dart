part of 'photo_bloc.dart';

abstract class PhotoState extends Equatable {
  const PhotoState();

  @override
  List<Object?> get props => [];
}

class BeerInitial extends PhotoState {}

class PhotosLoaded extends PhotoState {
  final List<Photo> photos;

  const PhotosLoaded({required this.photos});

  @override
  List<Object?> get props => [photos];
}

class PhotosError extends PhotoState {
  final String message;

  const PhotosError({required this.message});

  @override
  List<Object?> get props => [message];
}
