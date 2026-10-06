import 'package:project_tmp/export.dart';

class EntryPoint extends StatefulWidget {
  const EntryPoint({super.key});

  @override
  State<EntryPoint> createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  void _init() {
    postFrameCallback(() async {
      if (!mounted) return;
      if (appState.isLoggedIn) {
        pushReplacement(const HomePage(), transition: PageTransitions.fade);
      } else {
        pushReplacement(const LoginPage(), transition: PageTransitions.fade);
      }
    });
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Loading...")));
  }
}
