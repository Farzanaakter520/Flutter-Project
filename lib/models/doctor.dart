class Doctor {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String specialization;
  final String qualification;
  final int? experience;
  final String hospitalName;
  final String phone;
  final String? image;
  final String date;

  Doctor({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.specialization,
    required this.qualification,
    this.experience,
    required this.hospitalName,
    required this.phone,
    this.image,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'specialization': specialization,
      'qualification': qualification,
      'experience': experience,
      'hospitalName': hospitalName,
      'phone': phone,
      'image': image,
      'date': date,
    };
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      specialization: json['specialization'] as String? ?? '',
      qualification: json['qualification'] as String? ?? '',
      experience: json['experience'] as int? ?? 0,
      hospitalName: json['hospitalName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      image: json['image'] as String?,
      date: json['date'] as String? ?? '',
    );
  }
}
