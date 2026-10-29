import 'package:flutter/material.dart';
import 'package:game_app/model/game.dart';
import 'package:game_app/viewmodel/fetchgame.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<Game>> gameList;
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    gameList = fetchGames();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _reload() async {
    final next = fetchGames();
    setState(() => gameList = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      appBar: AppBar(
        title: const Text('Flutter Game Store'),
        backgroundColor: Colors.amber.shade300,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value.trim().toLowerCase()),
                decoration: InputDecoration(
                  hintText: 'Cari game',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    tooltip: 'Hapus pencarian',
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: FutureBuilder<List<Game>>(
                  future: gameList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return _Message(
                        text: 'Gagal memuat game. Periksa koneksi internet.',
                        buttonText: 'Coba lagi',
                        onPressed: _reload,
                      );
                    }
                    final games = (snapshot.data ?? <Game>[])
                        .where((game) => game.title.toLowerCase().contains(_query))
                        .take(25)
                        .toList();
                    if (games.isEmpty) {
                      return Center(
                        child: Text(_query.isEmpty ? 'Tidak ada data game.' : 'Game tidak ditemukan.'),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: _reload,
                      child: ListView.builder(
                        itemCount: games.length,
                        itemBuilder: (context, index) {
                          final game = games[index];
                          return Card(
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              tileColor: Colors.white,
                              leading: SizedBox(
                                width: 72,
                                height: 64,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    game.thumbnail,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.videogame_asset),
                                  ),
                                ),
                              ),
                              title: Text(game.title, maxLines: 2, overflow: TextOverflow.ellipsis),
                              subtitle: Text(game.genre),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: game.id,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, required this.buttonText, required this.onPressed});
  final String text;
  final String buttonText;
  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) => Center(
    child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text(text, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      FilledButton(onPressed: onPressed, child: Text(buttonText)),
    ]),
  );
}
