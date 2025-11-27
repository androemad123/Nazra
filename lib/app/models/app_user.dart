// app_user.dart
class AppUser {
  final String uid;
  final String email;
  final String? displayName;
  final String? phoneNumber;
  final String role;

  AppUser({
    required this.uid,
    required this.email,
    this.displayName,
    this.phoneNumber,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'role': role,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      phoneNumber: map['phoneNumber'],
      role: map['role'] ?? 'user',
    );
  }
}
