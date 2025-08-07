class LiftHistory {
  final String barbellType;
  final double totalWeight;
  final bool isMetric;
  final List<Map<String, dynamic>> plates;
  final DateTime timestamp;
  final bool isSuccess;

  LiftHistory({
    required this.barbellType,
    required this.totalWeight,
    required this.isMetric,
    required this.plates,
    required this.timestamp,
    required this.isSuccess,
  });

  // Convert to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'barbellType': barbellType,
      'totalWeight': totalWeight,
      'isMetric': isMetric,
      'plates': plates,
      'timestamp': timestamp.toIso8601String(),
      'isSuccess': isSuccess,
    };
  }

  // Create from Map
  factory LiftHistory.fromMap(Map<String, dynamic> map) {
    return LiftHistory(
      barbellType: map['barbellType'],
      totalWeight: map['totalWeight'],
      isMetric: map['isMetric'],
      plates: List<Map<String, dynamic>>.from(map['plates']),
      timestamp: DateTime.parse(map['timestamp']),
      isSuccess: map['isSuccess'],
    );
  }
} 