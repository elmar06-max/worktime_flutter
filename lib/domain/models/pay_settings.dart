class PaySettings {
  const PaySettings({
    required this.hourlyRate,
    required this.overtimeMultiplier,
  });

  final double hourlyRate;
  final double overtimeMultiplier;

  PaySettings copyWith({
    double? hourlyRate,
    double? overtimeMultiplier,
  }) {
    return PaySettings(
      hourlyRate: hourlyRate ?? this.hourlyRate,
      overtimeMultiplier: overtimeMultiplier ?? this.overtimeMultiplier,
    );
  }
}
