class AdmitPatientDto {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String dob;
  final String address;
  final String doctorName;
  final String bedWard;
  final String bedNumber;
  final String admissionDate;
  final String? dischargeDate;
  final double advance;
  final double due;
  final double? total;

  AdmitPatientDto({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.address,
    required this.doctorName,
    required this.bedWard,
    required this.bedNumber,
    required this.admissionDate,
    this.dischargeDate,
    required this.advance,
    required this.due,
    this.total,
  });

  factory AdmitPatientDto.fromJson(Map<String, dynamic> json) {
    return AdmitPatientDto(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      dob: json['dob'],
      address: json['address'],
      doctorName: json['doctorName'],
      bedWard: json['bedWard'],
      bedNumber: json['bedNumber'],
      admissionDate: json['admissionDate'],
      dischargeDate: json['dischargeDate'],
      advance: (json['advanceAmount'] ?? 0).toDouble(),
      due: (json['dueAmount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),

    );
  }
}
