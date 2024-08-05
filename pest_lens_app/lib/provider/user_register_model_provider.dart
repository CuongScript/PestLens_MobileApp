import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/models/farmer_register_model.dart';

class UserRegisterModelNotifier extends StateNotifier<FarmerRegisterModel> {
  UserRegisterModelNotifier()
      : super(FarmerRegisterModel(
          username: '',
          email: '',
          password: '',
          firstName: '',
          lastName: '',
          phoneNumber: '',
          avatarUrl: null,
        ));

  void reset() {
    state = FarmerRegisterModel(
      username: '',
      email: '',
      password: '',
      firstName: '',
      lastName: '',
      phoneNumber: '',
      avatarUrl: null,
    );
  }

  void updateModel(FarmerRegisterModel model) {
    state = model;
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void updateFirstName(String firstName) {
    state = state.copyWith(firstName: firstName);
  }

  void updateLastName(String lastName) {
    state = state.copyWith(lastName: lastName);
  }

  void updatePhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void updateAvatarUrl(String? avatarUrl) {
    state = state.copyWith(avatarUrl: avatarUrl);
  }
}

final userRegisterModelProvider =
    StateNotifierProvider<UserRegisterModelNotifier, FarmerRegisterModel>(
        (ref) {
  return UserRegisterModelNotifier();
});
