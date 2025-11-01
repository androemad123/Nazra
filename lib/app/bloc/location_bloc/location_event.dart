// blocs/location_bloc/location_event.dart
import 'package:equatable/equatable.dart';

abstract class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object?> get props => [];
}

class FetchCurrentLocation extends LocationEvent {}
