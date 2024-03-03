import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioHelper {
  Future<String> convertToMusicUrl(String ytUrl) async {
    var youtube = YoutubeExplode();

    var streamManifest = await youtube.videos.streamsClient.getManifest(ytUrl);
    var audioOnlyStreams = streamManifest.audioOnly;
    var audioStream = audioOnlyStreams.withHighestBitrate();

    youtube.close();
    return audioStream.url.toString();
  }
}
