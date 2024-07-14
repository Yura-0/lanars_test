import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../models/photo_model.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.pexels.com/v1/curated';
  final String apiKey = 'aFOWIfO4wcZXCcsGNMdBiZiGeiEtrDw8lidmMlld5XgrDKorkCFfxKy6';

  PhotoBloc() : super(BeerInitial()) {
    on<LoadPhotos>(_onLoadPhotos);
    on<LoadMorePhotos>(_onLoadMorePhotos);
  }

  Future<void> _onLoadPhotos(LoadPhotos event, Emitter<PhotoState> emit) async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'page': event.page,
        'per_page': 10,
      }, options: Options(headers: {
        'Authorization': apiKey,
      }));
      final List<Photo> photos = (response.data['photos'] as List)
          .map((json) => Photo.fromJson(json))
          .toList();
      emit(PhotosLoaded(photos: photos));
    } catch (error) {
      emit(PhotosError(message: error.toString()));
    }
  }

  Future<void> _onLoadMorePhotos(LoadMorePhotos event, Emitter<PhotoState> emit) async {
    if (state is PhotosLoaded) {
      final currentState = state as PhotosLoaded;
      try {
        final response = await _dio.get(baseUrl, queryParameters: {
          'page': event.page,
          'per_page': 10,
        }, options: Options(headers: {
          'Authorization': apiKey,
        }));
        final List<Photo> newPhotos = (response.data['photos'] as List)
            .map((json) => Photo.fromJson(json))
            .toList();

        final Set<int> existingPhotoIds = currentState.photos.map((photo) => photo.id).toSet();
        final List<Photo> filteredPhotos = newPhotos.where((photo) => !existingPhotoIds.contains(photo.id)).toList();

        emit(PhotosLoaded(photos: currentState.photos + filteredPhotos));
      } catch (error) {
        emit(PhotosError(message: error.toString()));
      }
    }
  }
}
