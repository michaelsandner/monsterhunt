import 'package:equatable/equatable.dart';

class MonsterProperty extends Equatable {
  const MonsterProperty({
    required this.name,
    required this.unit,
    required this.currentValue,
    required this.maxValue,
  });
  final String name;
  final String unit;
  final double currentValue;
  final double maxValue;

  double get percentage {
    if (maxValue == 0) {
      return 0;
    }
    return (currentValue / maxValue * 100).clamp(0, 100);
  }

  bool get isCompleted => currentValue <= 0;

  MonsterProperty copyWith({
    final String? name,
    final String? unit,
    final double? currentValue,
    final double? maxValue,
  }) => MonsterProperty(
    name: name ?? this.name,
    unit: unit ?? this.unit,
    currentValue: currentValue ?? this.currentValue,
    maxValue: maxValue ?? this.maxValue,
  );

  @override
  List<Object?> get props => [name, unit, currentValue, maxValue];
}
