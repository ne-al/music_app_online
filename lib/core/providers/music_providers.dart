import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final homeMusicProvider = FutureProvider.autoDispose<List<Video>>((ref) async {
  ref.keepAlive();
  final yt = YoutubeExplode();
  List<Video> music = [];

  var response = await yt.search.search(
    'latest trending songs this year',
    filter: DurationFilters.short,
  );

  for (var musicVid in response) {
    music.add(musicVid);
  }
  return music;
});

final searchMusicProvider =
    FutureProvider.family.autoDispose<List<Video>, String>((ref, query) async {
  final yt = YoutubeExplode();
  List<Video> music = [];

  var response = await yt.search.search(
    query,
    filter: DurationFilters.short,
  );

  for (var data in response) {
    music.add(data);
  }
  return music;
});
