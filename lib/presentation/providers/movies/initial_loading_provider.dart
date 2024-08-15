import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'movies_providers.dart';

final Provider<bool> initialLoadingProvider = Provider((ref) {
    final step = ref.watch(nowPlayingMoviesProvider).isEmpty;
    final step2 = ref.watch(popularMoviesProvider).isEmpty;
    final step3 = ref.watch(topRatedMoviesProvider).isEmpty;
    final step4 = ref.watch(upComingMoviesProvider).isEmpty;

    if( step || step2 || step3 || step4 ) return true;

    return false;
});

