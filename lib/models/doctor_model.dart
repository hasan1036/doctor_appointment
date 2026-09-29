class Doctor {
  final int id;
  final String departmentName;
  final String name;
  final String specialization;
  final String qualification;
  final String designation;
  final String? registrationNumber;
  final String? image;
  final String? bio;
  final String phone;
  final String? hospital;

  Doctor({
    required this.id,
    required this.departmentName,
    required this.name,
    required this.specialization,
    required this.qualification,
    required this.designation,
    this.registrationNumber,
    this.image,
    this.bio,
    required this.phone,
    this.hospital,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? 0,
      departmentName: json['departmentName'] ?? '',
      name: json['name'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      designation: json['designation'] ?? '',
      registrationNumber: json['registrationNumber'],
      image: json['image'],
      bio: json['bio'],
      phone: json['phone'] ?? '',
      hospital: json['hospital'],
    );
  }
}