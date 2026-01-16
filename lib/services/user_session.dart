class UserSession {
  static final UserSession instance = UserSession._internal();
  UserSession._internal();

  Map<String, dynamic>? user;

  void setUser(Map<String, dynamic> data) {
    user = data;
  }

  void clear() {
    user = null;
  }

  String get name => user?['name'] ?? '';
  String get photoUrl => user?['photoUrl'] ?? '';
}
