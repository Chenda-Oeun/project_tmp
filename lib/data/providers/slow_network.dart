import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_tmp/utils/helper/accessors.dart';


class RealSlowNetwork extends Notifier<bool> {
  @override
  bool build() => false;

  void setSlow(bool value) => state = value;
}

final realSlowNetworkProvider = NotifierProvider<RealSlowNetwork, bool>(RealSlowNetwork.new);


class ShouldDisplaySlowOverlay extends Notifier<bool> {
  @override
  bool build() => false;

  void setDisplay(bool value) => state = value;
}

final shouldDisplaySlowOverlay = NotifierProvider<ShouldDisplaySlowOverlay, bool>(ShouldDisplaySlowOverlay.new);


class IsInternetConnected extends Notifier<bool> {
  @override
  bool build() => false;

  void setConnected(bool value) => state = value;
}

final isInternetConnectedProvider = NotifierProvider<IsInternetConnected, bool>(IsInternetConnected.new);


class IsRequireSelectLineOnPreload extends Notifier<bool> {
  @override
  bool build() => false;

  void setRequire(bool value) => state = value;
}

final isRequireSelectLineOnPreloadProvider = NotifierProvider<IsRequireSelectLineOnPreload, bool>(
  IsRequireSelectLineOnPreload.new,
);


// --- Provider with Ref lifecycle & clean Timer management ---

final displaySlowNetworkProvider = Provider<bool>((ref) {
  Timer? slowDebounce;

  ref.onDispose(() {
    slowDebounce?.cancel();
  });

  ref.listen<bool>(realSlowNetworkProvider, (previous, current) {
    if (previous != current) {
      if (current) {
        slowDebounce?.cancel();
        slowDebounce = null;
        ref.invalidateSelf();
      } else {
        slowDebounce = Timer(const Duration(seconds: 1), () {
          ref.invalidateSelf();
        });
      }
    }
  });

  return ref.watch(realSlowNetworkProvider);
});


// Helper update method
void setSlowNetworkProvider(bool isSlow) {
  appRef.read(realSlowNetworkProvider.notifier).setSlow(isSlow);
}