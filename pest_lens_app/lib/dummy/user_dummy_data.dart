import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';

// Dummy data for UI testing
final List<UserFullInfoModel> dummyUsers = [
  UserFullInfoModel(
    id: 'user_0',
    username: 'username_0',
    email: 'user0@example.com',
    firstName: 'FirstName0',
    lastName: 'LastName0',
    phoneNumber: '0987678987',
    avatarUrl:
        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    createdAt: DateTime.now().subtract(const Duration(days: 0)),
    lastLogin: DateTime.now().subtract(const Duration(days: 0)),
    activatedAt: DateTime.now().subtract(const Duration(days: 0)),
    roles: [Role.ROLE_ADMIN],
    accountStatus: AccountStatusEnum.ACTIVE,
    inactiveUser: false,
    newUser: false,
  ),
  UserFullInfoModel(
    id: 'user_1',
    username: 'username_1',
    email: 'user1@example.com',
    firstName: 'FirstName1',
    lastName: 'LastName1',
    phoneNumber: '0987678987',
    avatarUrl:
        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    createdAt: DateTime.now().subtract(const Duration(days: 30)),
    lastLogin: null,
    activatedAt: null,
    roles: [Role.ROLE_USER],
    accountStatus: AccountStatusEnum.INACTIVE,
    inactiveUser: true,
    newUser: true,
  ),
  UserFullInfoModel(
    id: 'user_19',
    username: 'username_19',
    email: 'user19@example.com',
    firstName: 'FirstName19',
    lastName: 'LastName19',
    phoneNumber: '0987678987',
    avatarUrl:
        'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500',
    createdAt: DateTime.now().subtract(const Duration(days: 570)),
    lastLogin: null,
    activatedAt: null,
    roles: [Role.ROLE_USER],
    accountStatus: AccountStatusEnum.PENDING,
    inactiveUser: false,
    newUser: true,
  ),
];
