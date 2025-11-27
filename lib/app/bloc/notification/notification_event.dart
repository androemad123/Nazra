part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class UpdateNotifications extends NotificationEvent {
  final List<AppNotification> notifications;

  const UpdateNotifications(this.notifications);

  @override
  List<Object> get props => [notifications];
}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {}
