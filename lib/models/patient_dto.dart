class PatientDto {
  final int? id;
  final String? name;
  final String? email;
  final String? phone;
  final String? doctorName;
  final String? bedWard;
  final String? bedNumber;
  final double? dueAmount;
  final double? totalBill;
  final DateTime? dischargeDate;
  final DateTime? admissionDate;
  final double? advanceAmount;

  PatientDto({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.doctorName,
    this.bedWard,
    this.bedNumber,
    this.dueAmount,
    this.totalBill,
    this.dischargeDate,
    this.admissionDate,
    this.advanceAmount,
  });

  factory PatientDto.fromJson(Map<String, dynamic> json) {
    return PatientDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      doctorName: json['doctorName'],
      bedWard: json['bedWard'],
      bedNumber: json['bedNumber'],
      dueAmount: (json['dueAmount'] as num?)?.toDouble(),
      totalBill: (json['totalBill'] as num?)?.toDouble(),
      dischargeDate: json['dischargeDate'] != null
          ? DateTime.parse(json['dischargeDate'])
          : null,
      admissionDate: json['admissionDate'] != null
          ? DateTime.parse(json['admissionDate'])
          : null,
      advanceAmount: (json['advanceAmount'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'doctorName': doctorName,
      'bedWard': bedWard,
      'bedNumber': bedNumber,
      'dueAmount': dueAmount,
      'totalBill': totalBill,
      'dischargeDate':
      dischargeDate != null ? dischargeDate!.toIso8601String() : null,
      'admissionDate':
      admissionDate != null ? admissionDate!.toIso8601String() : null,
      'advanceAmount': advanceAmount,
    };
  }
}
