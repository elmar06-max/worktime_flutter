import 'package:hive/hive.dart';

import '../../domain/models/pay_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../hive/pay_settings_hive_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._box);

  final Box<PaySettingsHiveModel> _box;
  static const _payKey = 'pay_settings';

  @override
  Future<PaySettings?> getPaySettings() async {
    final model = _box.get(_payKey);
    return model?.toDomain();
  }

  @override
  Stream<PaySettings?> watchPaySettings() async* {
    yield await getPaySettings();
    yield* _box.watch(key: _payKey).map(
          (_) => _box.get(_payKey)?.toDomain(),
        );
  }

  @override
  Future<void> savePaySettings(PaySettings settings) async {
    await _box.put(_payKey, PaySettingsHiveModel.fromDomain(settings));
  }
}
