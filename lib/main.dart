import 'export.dart';

void main() async {
  await bootstrap();
  runApp(UncontrolledProviderScope(container: appRef, child: const _MyApp()));
}

class _MyApp extends StatelessWidget {
  const _MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: NavigationService.key,
      title: 'Flutter Login Screen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6366F1),
          brightness: Brightness.dark,
        ),
      ),
      home: Builder(
        builder: (context) {
          return EntryPoint();
        },
      ),
    );
  }
}
