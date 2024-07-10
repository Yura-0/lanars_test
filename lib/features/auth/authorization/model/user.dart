// User model abstraction
import 'i_user.dart';

class User implements IUser {
  @override
  final String name;
  @override
  final String email;
  @override
  final String imageUrl;

  User({required this.name, required this.email, required this.imageUrl});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: '${json['name']['first']} ${json['name']['last']}',
      email: json['email'],
      imageUrl: json['picture']['large'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
    };
  }
}