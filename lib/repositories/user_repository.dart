import 'package:eco_quest/models/user.dart';

class UserRepository {
  Future<User> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User.mock();
  }
}