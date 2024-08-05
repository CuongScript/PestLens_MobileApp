import 'package:flutter/material.dart';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/models/role_enum.dart'; // Import Role enum

class UserBriefInfoRow extends StatelessWidget {
  final UserFullInfoModel user;

  const UserBriefInfoRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Determine the display name for the role
    String roleDisplayName =
        user.roles == Role.ROLE_ADMIN ? 'Admin Account' : 'Farmer Account';

    // Determine the text style for the account status
    TextStyle statusTextStyle;
    switch (user.status) {
      case AccountStatusEnum.ACTIVE:
        statusTextStyle = const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        );
        break;
      case AccountStatusEnum.DEACTIVATED:
        statusTextStyle = const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        );
        break;
      case AccountStatusEnum.PENDING:
        statusTextStyle = const TextStyle(
          color: Colors.orange,
          fontWeight: FontWeight.bold,
        );
        break;
      default:
        statusTextStyle = const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2), // Shadow position
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            radius: 24,
            child: ClipOval(
              child: Image.asset(
                'lib/assets/images/placeholder_profile_image.png',
                fit: BoxFit.cover,
                width: 48,
                height: 48,
              ),
            ),
          ),
          title: Text(user.username, style: CustomTextStyles.subtitle),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(roleDisplayName),
              Text(user.status.toString().split('.').last,
                  style: statusTextStyle),
            ],
          ),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
