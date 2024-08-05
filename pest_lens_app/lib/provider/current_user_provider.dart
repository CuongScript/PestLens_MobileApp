import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/user.dart';
import 'package:pest_lens_app/utils/user_preferences.dart';

final userProvider = FutureProvider<User?>((ref) async {
  return UserPreferences.getUser();
});
