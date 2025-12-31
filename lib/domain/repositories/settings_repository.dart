import '../models/pay_settings.dart';

abstract class SettingsRepository {
  Future<PaySettings?> getPaySettings();
  Stream<PaySettings?> watchPaySettings();
  Future<void> savePaySettings(PaySettings settings);
}
