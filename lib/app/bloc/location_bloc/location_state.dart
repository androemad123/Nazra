// blocs/location_bloc/location_state.dart
import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationState extends Equatable {
  final bool isLoading;
  final LatLng? position;
  final String? address;
  final String? error;

  const LocationState({
    this.isLoading = false,
    this.position,
    this.address,
    this.error,
  });

  LocationState copyWith({
    bool? isLoading,
    LatLng? position,
    String? address,
    String? error,
  }) {
    return LocationState(
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      address: address ?? this.address,
      error: error,
    );
  }

  @override
  List<Object?> get props => [isLoading, position, address, error];
}
