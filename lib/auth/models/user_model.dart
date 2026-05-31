class UserModel {
  final String id;
  final String email;
  final String name;
  final bool isProfileComplete;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.isProfileComplete = true, // Default true untuk flow lama
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      isProfileComplete: json['isProfileComplete'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'isProfileComplete': isProfileComplete,
    };
  }
}
