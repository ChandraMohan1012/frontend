class VastuScore {
  final int score;
  final String complianceLevel;
  final List<String> positivePoints;
  final List<String> negativePoints;

  VastuScore({
    required this.score,
    required this.complianceLevel,
    required this.positivePoints,
    required this.negativePoints,
  });

  factory VastuScore.fromJson(Map<String, dynamic> json) {
    return VastuScore(
      score: json['score'] ?? 0,
      complianceLevel: json['complianceLevel'] ?? 'Unknown',
      positivePoints: List<String>.from(json['positivePoints'] ?? []),
      negativePoints: List<String>.from(json['negativePoints'] ?? []),
    );
  }

  factory VastuScore.mock() {
    return VastuScore(
      score: 75,
      complianceLevel: 'Good',
      positivePoints: [
        'Main entrance is North-East facing',
        'Kitchen is in South-East direction',
        'Master bedroom is in South-West',
      ],
      negativePoints: [
        'Staircase is in the North',
        'Bathroom is near the kitchen',
      ],
    );
  }
}
