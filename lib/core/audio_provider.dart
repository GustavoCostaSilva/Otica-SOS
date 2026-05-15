import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter/foundation.dart';

final audioPlayerProvider = Provider<AudioPlayer>((ref) {
  final player = AudioPlayer();

  ref.onDispose(() {
    player.dispose();
  });

  return player;
});

final backgroundMusicProvider = FutureProvider<void>((ref) async {
  final player = ref.watch(audioPlayerProvider);

  try {
    // Usando uma stream de rádio pública e estável que suporta CORS
    await player.setUrl('https://stream.zeno.fm/f3wvbbqmdg8uv');
    await player.setLoopMode(LoopMode.all);
    
    // Apenas tenta tocar; se o navegador bloquear autoplay, ele ignora sem crashar
    await player.play();
  } catch (e) {
    debugPrint('Erro ao inicializar áudio ambiente: $e');
  }
});
