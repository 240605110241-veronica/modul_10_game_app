import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game_app/view/detail.dart';
import 'package:game_app/view/home.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Game Store',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/detail': (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return Detail(gameTerpilih: id);
        },
      },
    );
  }
}
