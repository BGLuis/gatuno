import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:path_provider/path_provider.dart';
import '../dio_client.dart';

Future<FileCacheStore> _createFileCacheStore() async {
  final cacheDir = await getApplicationCacheDirectory();
  return FileCacheStore(cacheDir.path);
}

Future<void> setupCacheInterceptor(
  DioClient dioClient, {
  CacheStore? store,
}) async {
  final effectiveStore = store ?? await _createFileCacheStore();

  final cacheOptions = CacheOptions(
    store: effectiveStore,
    policy: CachePolicy.request,
    maxStale: const Duration(days: 7),
    priority: CachePriority.normal,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  dioClient.dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
}
