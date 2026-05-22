import "package:just_audio/just_audio.dart";

enum AudioType { meditation, sleepStory, ambient, breathing }

class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final AudioPlayer _ambientPlayer = AudioPlayer();

  AudioPlayer get player => _player;

  double get position => _player.position.inSeconds.toDouble();
  double get duration => _player.duration?.inSeconds.toDouble() ?? 0;
  bool get isPlaying => _player.playing;
  double get volume => _player.volume;

  Stream<double> get positionStream =>
      _player.positionStream.map((p) => p.inSeconds.toDouble());
  Stream<PlayerState> get stateStream => _player.playerStateStream;

  Future<void> playMeditation(String assetPath) async {
    await _player.setAsset(assetPath);
    await _player.play();
  }

  Future<void> playAmbient(String assetPath) async {
    await _ambientPlayer.setAsset(assetPath);
    await _ambientPlayer.setVolume(0.3);
    await _ambientPlayer.setLoopMode(LoopMode.one);
    await _ambientPlayer.play();
  }

  Future<void> stopAmbient() async {
    await _ambientPlayer.stop();
  }

  Future<void> play() async => await _player.play();
  Future<void> pause() async => await _player.pause();
  Future<void> stop() async {
    await _player.stop();
    await _ambientPlayer.stop();
  }
  Future<void> seek(Duration position) async =>
      await _player.seek(position);
  Future<void> setVolume(double v) async => await _player.setVolume(v);

  Future<void> dispose() async {
    await _player.dispose();
    await _ambientPlayer.dispose();
  }
}
