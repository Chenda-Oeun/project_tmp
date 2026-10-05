import 'package:project_tmp/export.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context,WidgetRef  ref) {
    final counterNumber = ref.watch(counterProvider);
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("App State: ${appState.buildNumber}"),
            Text("Counter Number is :  $counterNumber"),
            16.gap,
            FilledButton(onPressed: (){
              ref.read(counterProvider.notifier).state ++;
            }, child: Text("+")),
          ],
        ),
      ),
    );
  }
}
