class Bill {
  final int? id;
  final double roomCharge;
  final double doctorFee;
  final double medicineCost;
  final double total;

  Bill({
    this.id,
    required this.roomCharge,
    required this.doctorFee,
    required this.medicineCost,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomCharge': roomCharge,
      'doctorFee': doctorFee,
      'medicineCost': medicineCost,
      'total': total,
    };
  }

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'] as int?,
      roomCharge: (json['roomCharge'] as num?)?.toDouble() ?? 0.0,
      doctorFee: (json['doctorFee'] as num?)?.toDouble() ?? 0.0,
      medicineCost: (json['medicineCost'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
