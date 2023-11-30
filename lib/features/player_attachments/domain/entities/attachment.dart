import 'package:equatable/equatable.dart';

class Attachment extends Equatable {
  final String filename;
  final String playerId;

  const Attachment({
    required this.filename,
    required this.playerId,
  });

  @override
  List<Object> get props => [filename, playerId];
}
