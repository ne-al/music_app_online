import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:music_app_online/app/screens/pages/player.dart';
import 'package:popover/popover.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:google_fonts/google_fonts.dart';

class SongTile extends StatelessWidget {
  final Video data;
  const SongTile({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerPage(video: data),
          ),
        );
      },
      child: ListTile(
        leading: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CachedNetworkImage(
              imageUrl: data.thumbnails.highResUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          data.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(fontSize: 15),
        ),
        subtitle: Text(
          data.author,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.lato(),
        ),
        trailing: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              showPopover(
                context: context,
                bodyBuilder: (context) {
                  return const SizedBox(
                    height: 180,
                    width: 120,
                  );
                },
                direction: PopoverDirection.left,
                backgroundColor: Theme.of(context).colorScheme.surface,
              );
            },
            icon: const Icon(Icons.more_vert_rounded),
          );
        }),
      ),
    );
  }
}
