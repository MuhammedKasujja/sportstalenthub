part of 'player_attachments_bloc.dart';

class PlayerAttachmentsState extends Equatable {
  final String? error;
  final String? message;
  final AppState status;
  final List<AttachmentModel>? data;

  const PlayerAttachmentsState({
    this.error,
    this.message,
    required this.status,
    this.data,
  });

  factory PlayerAttachmentsState.init() {
    return const PlayerAttachmentsState(status: AppState.initial);
  }

  PlayerAttachmentsState load() {
    return PlayerAttachmentsState(
      data: data,
      status: AppState.loading,
    );
  }

  PlayerAttachmentsState loaded({
    String? message,
    List<AttachmentModel>? data,
  }) {
    return PlayerAttachmentsState(
      message: message,
      data: data ?? this.data,
      status: AppState.success,
    );
  }

  PlayerAttachmentsState failure({
    required String error,
  }) {
    return PlayerAttachmentsState(
      error: error,
      data: data,
      status: AppState.failure,
    );
  }

  @override
  List<Object?> get props => [
        message,
        error,
        status,
      ];
}
