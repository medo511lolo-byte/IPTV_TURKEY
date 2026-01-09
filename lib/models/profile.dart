class UserProfile {
  final String id;
  final String username;
  final String password;
  final DateTime lastLogin;
  final String? displayName;

  UserProfile({
    required this.id,
    required this.username,
    required this.password,
    required this.lastLogin,
    this.displayName,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'lastLogin': lastLogin.toIso8601String(),
      'displayName': displayName,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      lastLogin: DateTime.parse(json['lastLogin'] as String),
      displayName: json['displayName'] as String?,
    );
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? password,
    DateTime? lastLogin,
    String? displayName,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      lastLogin: lastLogin ?? this.lastLogin,
      displayName: displayName ?? this.displayName,
    );
  }
}
