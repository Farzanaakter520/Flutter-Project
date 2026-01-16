class AdmitPatient {
  final int? id;
  final int? bedId;
  final int? doctorId;
  final String? doctorName;
  final String? ward;
  final double? due;
  final String address;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final DateTime dob;
  final double advanceAmount;

  AdmitPatient({
    this.id,
    required this.bedId,
    required this.doctorId,
    this.doctorName,
    this.ward,
    this.due,
    required this.address,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.dob,
    required this.advanceAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'bedId': bedId,
      'doctorId': doctorId,
      'address': address,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob.toIso8601String(), // e.g., "1995-08-15"
      'advanceAmount': advanceAmount,
    };
  }

  /// Create object from JSON response
  factory AdmitPatient.fromJson(Map<String, dynamic> json) {
    return AdmitPatient(
      id: json['id'] as int?,
      bedId: json['bedId'] ?? 0,
      doctorId: json['doctorId'] ?? 0,
      address: json['address'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      gender: json['gender'] ?? '',
      dob: DateTime.tryParse(json['dob'] ?? '') ?? DateTime(1900, 1, 1),
      advanceAmount: (json['advanceAmount'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
