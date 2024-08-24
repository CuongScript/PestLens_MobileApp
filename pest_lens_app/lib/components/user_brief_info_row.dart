import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/services/s3_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserBriefInfoRow extends StatelessWidget {
  final UserFullInfoModel user;
  final VoidCallback onTap;

  const UserBriefInfoRow({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    String roleDisplayName =
        user.roles.isNotEmpty && user.roles.first == Role.ROLE_ADMIN
            ? AppLocalizations.of(context)!.adminAccount
            : AppLocalizations.of(context)!.farmerAccount;

    TextStyle statusTextStyle;
    switch (user.accountStatus) {
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
      case AccountStatusEnum.INACTIVE:
        statusTextStyle = const TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.bold,
        );
        break;
      default:
        statusTextStyle = const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
    }

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: _buildProfileImage(),
            title: Text(user.username, style: CustomTextStyles.subtitle),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(roleDisplayName),
                Text(user.accountStatus.toString().split('.').last,
                    style: statusTextStyle),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return ClipOval(
      child: SizedBox(
        width: 48,
        height: 48,
        child: _buildImageContent(),
      ),
    );
  }

  Widget _buildImageContent() {
    if (user.avatarUrl == null || user.avatarUrl!.isEmpty) {
      return _buildPlaceholderImage();
    }

    if (Uri.tryParse(user.avatarUrl!)?.hasScheme ?? false) {
      return _buildNetworkImage(user.avatarUrl!);
    } else {
      return _buildS3Image(user.avatarUrl!);
    }
  }

  Widget _buildPlaceholderImage() {
    return Image.asset(
      'lib/assets/images/placeholder_profile_image.png',
      fit: BoxFit.cover,
      width: 48,
      height: 48,
    );
  }

  Widget _buildNetworkImage(String url) {
    return FadeInImage.assetNetwork(
      placeholder: 'lib/assets/images/placeholder_profile_image.png',
      image: url,
      fit: BoxFit.cover,
      width: 48,
      height: 48,
      imageErrorBuilder: (context, error, stackTrace) {
        return _buildPlaceholderImage();
      },
    );
  }

  Widget _buildS3Image(String objectKey) {
    return FutureBuilder<Uint8List>(
      future: S3Service().getUserProfileImageData(objectKey),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Image.memory(
            snapshot.data!,
            fit: BoxFit.cover,
            width: 48,
            height: 48,
          );
        } else if (snapshot.hasError) {
          return _buildPlaceholderImage();
        } else {
          return _buildPlaceholderImage();
        }
      },
    );
  }
}
