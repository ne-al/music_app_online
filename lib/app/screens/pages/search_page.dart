import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app_online/app/widgets/song_tile.dart';
import 'package:music_app_online/core/providers/music_providers.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<Video> musicList = [];
  bool isLoading = false;

  void searchMusic() {
    _searchFocusNode.unfocus();
    if (_searchController.text.trim().isEmpty) {
      return;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 0,
        leading: Container(),
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton.filledTonal(
              onPressed: searchMusic,
              icon: const Icon(Icons.search_rounded),
            ),
          ),
        ],
      ),
      body: ref.watch(searchMusicProvider(_searchController.text.trim())).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return SongTile(data: data[index]);
                },
              );
            },
            error: (error, stackTrace) => Center(
              child: Text('$error'),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
          ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }
}
