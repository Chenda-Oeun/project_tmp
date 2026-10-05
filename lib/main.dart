

import 'export.dart';

void main() {
  runApp(
    ProviderScope(
      child: _MyApp(),

    ),
  );
}
class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter project template',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  HomePage(),
    );
  }
}
