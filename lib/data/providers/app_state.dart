

import 'package:flutter_riverpod/legacy.dart';
import 'package:project_tmp/data/models/app_state.dart';

final appStateProvider = ChangeNotifierProvider(
      (ref) => AppState.fromStorage(),
);
