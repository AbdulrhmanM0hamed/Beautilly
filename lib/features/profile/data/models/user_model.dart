class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String location;
  final bool isVerified;
  final DateTime createdAt;
  final List<String> favorites;
  final UserSettings settings;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    required this.location,
    required this.isVerified,
    required this.createdAt,
    required this.favorites,
    required this.settings,
  });
}

class UserSettings {
  final bool notifications;
  final String language;
  final String theme;
  final bool locationServices;

  UserSettings({
    required this.notifications,
    required this.language,
    required this.theme,
    required this.locationServices,
  });
}
