import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:music_app_online/app/screens/pages/search_page.dart';
import 'package:music_app_online/app/widgets/song_tile.dart';
import 'package:music_app_online/core/helper/audio_helper.dart';
import 'package:music_app_online/core/providers/music_providers.dart';

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
                      child: SongTile(data: music),
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
