import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoRepository {
  Future<PackageInfo> getPackageInfo() {
    return PackageInfo.fromPlatform();
  }
}

final packageInfoRepositoryProvider = Provider<PackageInfoRepository>((ref) {
  return PackageInfoRepository();
});
