import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:music_app_online/app/screens/pages/search_page.dart';
import 'package:music_app_online/core/helper/audio_helper.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final homeMusicProvider = FutureProvider<List<Video>>((ref) async {
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

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeMusic = ref.watch(homeMusicProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(),
                ),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: homeMusic.when(
        data: (data) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              var music = data[index];
              return !music.isLive
                  ? GestureDetector(
                      onTap: () async {
                        String musicUrl =
                            await AudioHelper().convertToMusicUrl(music.url);
                        Logger().d(musicUrl);
                      },
                      child: ListTile(
                        leading: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: CachedNetworkImage(
                              imageUrl: music.thumbnails.highResUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          music.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 15),
                        ),
                        subtitle: Text(
                          music.author,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_vert_rounded),
                        ),
                      ),
                    )
                  : Container();
            },
          );
        },
        error: (error, stackTrace) => const Center(
          child: Text('Error'),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
