import 'package:audioplayers/audioplayers.dart';

class PracticeTestAudio {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAudio(String audioUrl) async {
    await _audioPlayer.play(AssetSource(audioUrl));
  }

  Future<void> pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> stopAudio() async {
    await _audioPlayer.stop();
  }

  Future<void> seekAudio(Duration position) async {
    await _audioPlayer.seek(position);
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}
