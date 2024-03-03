import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
      extendBody: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            leadingWidth: 0,
            leading: Container(),
            title: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: const Icon(Icons.music_note_rounded),
                filled: true,
                fillColor: Colors.grey.shade800.withOpacity(0.3),
                hintText: 'Search music',
                hintStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w300,
                  fontSize: 15,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
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
          SliverToBoxAdapter(
            child: ref
                .watch(searchMusicProvider(_searchController.text.trim().isEmpty
                    ? 'Trending music this year'
                    : _searchController.text.trim()))
                .when(
                  data: (data) {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
          )
        ],
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
