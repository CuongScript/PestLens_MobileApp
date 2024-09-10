import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/profile_image_picker.dart';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileDetailPage extends StatelessWidget {
  final UserFullInfoModel user;
  final Function(UserFullInfoModel, bool)? onStatusChange;
  final bool isFromSettings;

  const UserProfileDetailPage({
    super.key,
    required this.user,
    this.onStatusChange,
    this.isFromSettings = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.userProfileDetail,
            style: CustomTextStyles.pageTitle),
        leading: IconButton(
          icon: const MyBackButton(),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 45,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ProfileImagePicker(
              imageUrl: user.avatarUrl,
              isReadOnly: true,
            ),
            const SizedBox(height: 24),
            _buildInfoField(AppLocalizations.of(context)!.username,
                user.username, Icons.person),
            const SizedBox(height: 20),
            _buildInfoField(AppLocalizations.of(context)!.logInEmail,
                user.email, Icons.email),
            const SizedBox(height: 20),
            _buildInfoField(AppLocalizations.of(context)!.firstName,
                user.firstName, Icons.person_outline),
            const SizedBox(height: 20),
            _buildInfoField(AppLocalizations.of(context)!.lastName,
                user.lastName, Icons.person_outline),
            const SizedBox(height: 20),
            if (user.phoneNumber != null && user.phoneNumber != '') ...[
              _buildInfoField(AppLocalizations.of(context)!.phone,
                  user.phoneNumber, Icons.phone),
              const SizedBox(height: 20),
            ],
            if (user.roles.isNotEmpty) ...[
              _buildInfoField(
                  AppLocalizations.of(context)!.role,
                  user.roles
                      .map((r) => r.toString().split('.').last)
                      .join(', '),
                  Icons.work),
            ] else ...[
              _buildInfoField(
                  AppLocalizations.of(context)!.role, "ROLE_USER", Icons.work),
            ],
            if (!isFromSettings) ...[
              const SizedBox(height: 20),
              _buildInfoField(
                  AppLocalizations.of(context)!.accountStatus,
                  user.accountStatus.toString().split('.').last,
                  Icons.verified_user),
              const SizedBox(height: 20),
              _buildInfoField(AppLocalizations.of(context)!.createdAt,
                  _formatDate(user.createdAt), Icons.calendar_today),
              const SizedBox(height: 20),
              _buildInfoField(AppLocalizations.of(context)!.lastLogin,
                  _formatDate(user.lastLogin), Icons.access_time),
              const SizedBox(height: 20),
              _buildInfoField(AppLocalizations.of(context)!.activateAt,
                  _formatDate(user.activatedAt), Icons.check_circle_outline),
              const SizedBox(height: 20),
              _buildInfoField(
                  AppLocalizations.of(context)!.newUser,
                  user.newUser
                      ? AppLocalizations.of(context)!.yes
                      : AppLocalizations.of(context)!.no,
                  Icons.new_releases),
              const SizedBox(height: 24),
              if (onStatusChange != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: _buildActionButtons(context),
                ),
            ],
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String? value, IconData icon) {
    if (value == 'ROLE_USER') {
      value = 'Farmer';
    } else if (value == 'ROLE_ADMIN') {
      value = 'Administator';
    }

    return MyTextFormField(
      controller: TextEditingController(text: value ?? 'N/A'),
      obscureText: false,
      prefixIcon: Icon(icon, color: Colors.black),
      labelText: label,
      textInputAction: TextInputAction.next,
      readOnly: true,
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy').format(date);
  }

  Widget _buildActionButtons(BuildContext context) {
    final activatedButton = MySubmitButton(
      onTap: () => onStatusChange!(user, true),
      buttonText: AppLocalizations.of(context)!.activate,
      isFilled: true,
      filledColor: Colors.green,
    );
    final deactivatedButton = MySubmitButton(
      onTap: () => onStatusChange!(user, false),
      buttonText: AppLocalizations.of(context)!.deactivate,
      isFilled: true,
      filledColor: Colors.red,
    );

    if (user.accountStatus == AccountStatusEnum.PENDING) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          activatedButton,
          const SizedBox(height: 10),
          deactivatedButton,
        ],
      );
    } else if (user.accountStatus == AccountStatusEnum.INACTIVE) {
      return activatedButton;
    } else if (user.accountStatus == AccountStatusEnum.ACTIVE) {
      return deactivatedButton;
    } else {
      return Container();
    }
  }
}
