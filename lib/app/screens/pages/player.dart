import 'package:audio_service/audio_service.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:music_app_online/core/helper/audio_helper.dart';
import 'package:music_app_online/main.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class PlayerPage extends StatefulWidget {
  final Video video;
  const PlayerPage({
    super.key,
    required this.video,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  void initPlayer() async {
    String url = await AudioHelper().convertToMusicUrl(widget.video.url);

    await audioHandler.playFromUri(Uri.parse(url));

    audioHandler.play();
  }

  @override
  Widget build(BuildContext context) {
    var data = widget.video;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.7,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.28,
                    child: CachedNetworkImage(
                      imageUrl: data.thumbnails.highResUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(data.title),
                  Text(data.author),
                ],
              ),
            ),
            const Gap(20),
            StreamBuilder<PlaybackState>(
              stream: audioHandler.playbackState.stream,
              builder: (context, snapshot) {
                Duration progress = snapshot.data?.position ?? Duration.zero;
                Duration total =
                    snapshot.data?.bufferedPosition ?? Duration.zero;
                Duration buffered =
                    snapshot.data?.bufferedPosition ?? Duration.zero;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    children: [
                      ProgressBar(
                        buffered: buffered,
                        progress: progress,
                        total: total,
                        onSeek: (value) {
                          audioHandler.seek(value);
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            iconSize: 52,
                            onPressed: () {
                              audioHandler.skipToPrevious();
                            },
                            icon: const Icon(Icons.skip_previous_rounded),
                          ),
                          IconButton(
                            iconSize: 60,
                            onPressed: () {
                              !snapshot.data!.playing
                                  ? audioHandler.play()
                                  : audioHandler.pause();
                            },
                            icon: !snapshot.data!.playing
                                ? const Icon(Icons.play_arrow_rounded)
                                : const Icon(Icons.pause_rounded),
                          ),
                          IconButton(
                            iconSize: 52,
                            onPressed: () {
                              audioHandler.skipToNext();
                            },
                            icon: const Icon(Icons.skip_next_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
