import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:project_tmp/data/models/app_state.dart';
import 'package:project_tmp/data/providers/app_state.dart';


AppState get appState => appRef.read(appStateProvider);



final appRef = ProviderContainer();

// BuildContext get appContext => NavigationService.key.currentContext!;

const unfreezedNoCopy = Freezed(
  copyWith: true, // Required for hive_ce_generator
  equal: false,
  addImplicitFinal: false,
  makeCollectionsUnmodifiable: false,
);