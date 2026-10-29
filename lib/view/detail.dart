import 'package:flutter/material.dart';
import 'package:game_app/model/detailgame.dart';
import 'package:game_app/viewmodel/fetchgame.dart';
import 'package:readmore/readmore.dart';

class Detail extends StatelessWidget {
  const Detail({super.key, required this.gameTerpilih});
  final int gameTerpilih;

  Future<DetailGame> fetchData() async {
    final jsonData = await fetchDataFromAPI(gameTerpilih);
    return DetailGame.fromJson(jsonData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      body: FutureBuilder<DetailGame>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }
          final game = snapshot.data;
          if (game == null) return const Center(child: Text('Data tidak tersedia'));
          final requirements = game.minimumSystemRequirements;
          return SafeArea(
            child: Column(children: [
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Stack(fit: StackFit.expand, children: [
                  Image.network(game.thumbnail, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(color: Colors.blueGrey)),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        color: Colors.white,
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16, right: 16, bottom: 14,
                    child: Text(game.title,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                        maxLines: 2, overflow: TextOverflow.ellipsis),
                  ),
                ]),
              ),
              Expanded(
                child: ListView(padding: const EdgeInsets.all(12), children: [
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Informasi Game', style: Theme.of(context).textTheme.titleMedium),
                        _infoRow('Genre', game.genre),
                        _infoRow('Platform', game.platform),
                        _infoRow('Developer', game.developer),
                        _infoRow('Publisher', game.publisher),
                        _infoRow('Tanggal rilis', game.releaseDate),
                      ]),
                    ),
                  ),
                  if (requirements != null)
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Minimum System Requirements', style: Theme.of(context).textTheme.titleMedium),
                          _infoRow('OS', requirements.os),
                          _infoRow('Processor', requirements.processor),
                          _infoRow('Memory', requirements.memory),
                          _infoRow('Graphics', requirements.graphics),
                          _infoRow('Storage', requirements.storage),
                        ]),
                      ),
                    ),
                  if (game.screenshots.isNotEmpty) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('Screenshot', style: Theme.of(context).textTheme.titleMedium),
                    ),
                    SizedBox(
                      height: 170,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: game.screenshots.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(game.screenshots[index].image,
                              width: 250, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const SizedBox(width: 250, child: Icon(Icons.broken_image))),
                        ),
                      ),
                    ),
                  ],
                  Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: ReadMoreText(
                        game.description ?? game.shortDescription ?? 'Tidak ada deskripsi.',
                        trimLines: 3,
                        colorClickableText: Colors.deepOrange,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Selengkapnya',
                        trimExpandedText: 'Lebih sedikit',
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
          );
        },
      ),
    );
  }
}

Widget _infoRow(String label, String? value) {
  final text = (value == null || value.isEmpty) ? '-' : value;
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 105, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
      const Text(':  '),
      Expanded(child: Text(text)),
    ]),
  );
}
