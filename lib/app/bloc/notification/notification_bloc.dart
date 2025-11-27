import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/notification_model.dart';
import '../../repositories/notification_repository.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;
  StreamSubscription? _notificationSubscription;

  NotificationBloc({required NotificationRepository notificationRepository})
      : _notificationRepository = notificationRepository,
        super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<UpdateNotifications>(_onUpdateNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
  }

  void _onLoadNotifications(LoadNotifications event, Emitter<NotificationState> emit) {
    emit(NotificationLoading());
    _notificationSubscription?.cancel();
    _notificationSubscription = _notificationRepository.watchNotifications().listen(
      (notifications) => add(UpdateNotifications(notifications)),
      onError: (error) => print('Notification stream error: $error'), // Ideally emit error state or handle gracefully
    );
  }

  void _onUpdateNotifications(UpdateNotifications event, Emitter<NotificationState> emit) {
    emit(NotificationLoaded(event.notifications));
  }

  Future<void> _onMarkAsRead(MarkAsRead event, Emitter<NotificationState> emit) async {
    await _notificationRepository.markAsRead(event.notificationId);
  }
  
  Future<void> _onMarkAllAsRead(MarkAllAsRead event, Emitter<NotificationState> emit) async {
    await _notificationRepository.markAllAsRead();
  }

  @override
  Future<void> close() {
    _notificationSubscription?.cancel();
    return super.close();
  }
}
