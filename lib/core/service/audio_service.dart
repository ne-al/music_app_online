import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MyAudioHandler extends BaseAudioHandler with SeekHandler, QueueHandler {
  final _player = AudioPlayer();

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() => _player.stop();

  @override
  Future<void> seek(Duration position) => _player.seek(position);
}
