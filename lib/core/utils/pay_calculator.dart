import '../../domain/models/pay_settings.dart';
import '../../domain/models/work_entry.dart';

class PayCalculator {
  const PayCalculator(this.settings);

  final PaySettings? settings;

  double totalForEntry(WorkEntry entry) {
    if (settings == null) return 0;
    final base = entry.daytimeHours * settings!.hourlyRate;
    final overtimeRate = settings!.hourlyRate * settings!.overtimeMultiplier;
    final overtime = entry.overtimeHours * overtimeRate;
    return base + overtime;
  }

  double totalForEntries(Iterable<WorkEntry> entries) {
    return entries.fold<double>(
      0,
      (sum, entry) => sum + totalForEntry(entry),
    );
  }
}
