import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../../services/location_service.dart';

abstract class LocationEvent {}
class FetchLocation extends LocationEvent {}

abstract class LocationState {}
class LocationInitial extends LocationState {}
class LocationLoading extends LocationState {}
class LocationLoaded extends LocationState {
  final Position position;
  final String address;
  LocationLoaded({required this.position, required this.address});
}
class LocationError extends LocationState {
  final String message;
  LocationError(this.message);
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationService locationService;
  LocationBloc(this.locationService) : super(LocationInitial()) {
    on<FetchLocation>((event, emit) async {
      emit(LocationLoading());
      try {
        final position = await locationService.getCurrentPosition();
        final address = await locationService.getAddressFromPosition(position);
        emit(LocationLoaded(position: position, address: address));
      } catch (e) {
        emit(LocationError(e.toString()));
      }
    });
  }
}
