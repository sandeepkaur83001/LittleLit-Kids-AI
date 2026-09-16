import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:little_kids_ai/core/services/shared_manager.dart';

class BackgroundMusicService extends GetxService {
  static BackgroundMusicService get to => Get.find<BackgroundMusicService>();

  final AudioPlayer _player = AudioPlayer();
  final RxBool isMusicEnabled = true.obs;
  final RxString currentPlayingUrl = ''.obs;

  static const String _prefKeyMusicEnabled = 'KEY_BG_MUSIC_ENABLED';

  @override
  void onInit() {
    super.onInit();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Configure looping mode
      await _player.setReleaseMode(ReleaseMode.loop);
    } catch (_) {}

    try {
      // Load saved music preference
      final saved = await SharedManager.getBoolSharePreferences(_prefKeyMusicEnabled);
      if (saved != null) {
        isMusicEnabled.value = saved;
      }
    } catch (_) {}
  }

  /// Play or switch background music according to mood musicUrl
  Future<void> playMoodMusic(String? musicUrl) async {
    if (musicUrl == null || musicUrl.trim().isEmpty) {
      return;
    }

    final trimmedUrl = musicUrl.trim();

    // If already playing this exact track, don't restart it
    if (currentPlayingUrl.value == trimmedUrl && _player.state == PlayerState.playing) {
      return;
    }

    currentPlayingUrl.value = trimmedUrl;

    if (!isMusicEnabled.value) {
      return;
    }

    try {
      await _player.stop();
      await _player.play(UrlSource(trimmedUrl));
    } catch (e) {
      // Fallback silently if network or codec fails
    }
  }

  /// Toggle background music on/off (used from Music Settings)
  Future<void> setMusicEnabled(bool enabled) async {
    isMusicEnabled.value = enabled;
    await SharedManager.setBoolSharePreferences(_prefKeyMusicEnabled, enabled);

    if (enabled) {
      if (currentPlayingUrl.value.isNotEmpty) {
        try {
          await _player.play(UrlSource(currentPlayingUrl.value));
        } catch (_) {}
      }
    } else {
      await _player.pause();
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _player.pause();
    } catch (_) {}
  }

  Future<void> resumeMusic() async {
    if (isMusicEnabled.value && currentPlayingUrl.value.isNotEmpty) {
      try {
        await _player.resume();
      } catch (_) {}
    }
  }

  Future<void> stopMusic() async {
    try {
      currentPlayingUrl.value = '';
      await _player.stop();
    } catch (_) {}
  }

  @override
  void onClose() {
    _player.dispose();
    super.onClose();
  }
}
