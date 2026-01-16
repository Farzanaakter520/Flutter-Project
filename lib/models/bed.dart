class Bed {
  final int? id;
  final String ward;
  final String bedNumber;
  final double feePerDay;
  final bool occupied;

  Bed({
    this.id,
    required this.ward,
    required this.bedNumber,
    required this.feePerDay,
    required this.occupied,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ward': ward,
      'bedNumber': bedNumber,
      'feePerDay': feePerDay,
      'occupied': occupied,
    };
  }

  factory Bed.fromJson(Map<String, dynamic> json) {
    return Bed(
      id: json['id'] as int?,
      ward: json['ward'] as String? ?? '',
      bedNumber: json['bedNumber'] as String? ?? '',
      feePerDay: (json['feePerDay'] as num?)?.toDouble() ?? 0.0,
      occupied: json['occupied'] as bool? ?? false,
    );
  }
}
