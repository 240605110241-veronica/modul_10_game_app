import 'dart:convert';

import 'package:game_app/model/game.dart';
import 'package:http/http.dart' as http;

const _apiBase = 'https://www.freetogame.com/api';

Future<List<Game>> fetchGames() async {
  final response = await http.get(Uri.parse('$_apiBase/games'));
  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil daftar game (${response.statusCode})');
  }
  final data = jsonDecode(response.body) as List<dynamic>;
  return data
      .map((item) => Game.fromJson(item as Map<String, dynamic>))
      .toList();
}

Future<Map<String, dynamic>> fetchDataFromAPI(int idGame) async {
  final response = await http.get(Uri.parse('$_apiBase/game?id=$idGame'));
  if (response.statusCode != 200) {
    throw Exception('Gagal mengambil detail game (${response.statusCode})');
  }
  final data = jsonDecode(response.body);
  if (data is Map<String, dynamic>) return data;
  throw const FormatException('Format data detail game tidak sesuai.');
}
