import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dio/dio.dart';
import '../models/photo_model.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class BeerBloc extends Bloc<BeerEvent, BeerState> {
  final Dio _dio = Dio();
  final String baseUrl = 'https://api.pexels.com/v1/curated';
  final String apiKey = 'aFOWIfO4wcZXCcsGNMdBiZiGeiEtrDw8lidmMlld5XgrDKorkCFfxKy6'; 

  BeerBloc() : super(BeerInitial()) {
    on<LoadPhotos>(_onLoadPhotos);
    on<LoadMorePhotos>(_onLoadMorePhotos);
  }

  Future<void> _onLoadPhotos(LoadPhotos event, Emitter<BeerState> emit) async {
    try {
      final response = await _dio.get(baseUrl, queryParameters: {
        'page': 1,
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

  Future<void> _onLoadMorePhotos(LoadMorePhotos event, Emitter<BeerState> emit) async {
    if (state is PhotosLoaded) {
      final currentState = state as PhotosLoaded;
      final page = (currentState.photos.length ~/ 10) + 1;
      try {
        final response = await _dio.get(baseUrl, queryParameters: {
          'page': page,
          'per_page': 30,
        }, options: Options(headers: {
          'Authorization': apiKey,
        }));
        final List<Photo> photos = (response.data['photos'] as List)
            .map((json) => Photo.fromJson(json))
            .toList();
        emit(PhotosLoaded(photos: currentState.photos + photos));
      } catch (error) {
        emit(PhotosError(message: error.toString()));
      }
    }
  }
}
