import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pest_lens_app/components/my_back_button.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/components/profile_image_picker.dart';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/components/my_submit_button.dart';
import 'package:pest_lens_app/components/my_text_form_field.dart';

class UserProfileDetailPage extends StatelessWidget {
  final UserFullInfoModel user;
  final Function(UserFullInfoModel, bool) onStatusChange;
  const UserProfileDetailPage(
      {super.key, required this.user, required this.onStatusChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Details',
            style: CustomTextStyles.pageTitle),
        leading: IconButton(
          icon: const MyBackButton(),
          onPressed: () => {Navigator.of(context).pop()},
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
            _buildInfoField('Username', user.username, Icons.person),
            const SizedBox(height: 20),
            _buildInfoField('Email', user.email, Icons.email),
            const SizedBox(height: 20),
            _buildInfoField('First Name', user.firstName, Icons.person_outline),
            const SizedBox(height: 20),
            _buildInfoField('Last Name', user.lastName, Icons.person_outline),
            const SizedBox(height: 20),
            _buildInfoField('Phone', user.phoneNumber, Icons.phone),
            const SizedBox(height: 20),
            _buildInfoField(
                'Role',
                user.roles.map((r) => r.toString().split('.').last).join(', '),
                Icons.work),
            const SizedBox(height: 20),
            _buildInfoField(
                'Account Status',
                user.accountStatus.toString().split('.').last,
                Icons.verified_user),
            const SizedBox(height: 20),
            _buildInfoField('Created At', _formatDate(user.createdAt),
                Icons.calendar_today),
            const SizedBox(height: 20),
            _buildInfoField(
                'Last Login', _formatDate(user.lastLogin), Icons.access_time),
            const SizedBox(height: 20),
            _buildInfoField('Activated At', _formatDate(user.activatedAt),
                Icons.check_circle_outline),
            const SizedBox(height: 20),
            _buildInfoField(
                'New User', user.newUser ? 'Yes' : 'No', Icons.new_releases),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: _buildActionButtons(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String? value, IconData icon) {
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
      onTap: () => onStatusChange(user, true),
      buttonText: 'Activate',
      isFilled: true,
      filledColor: Colors.green,
    );
    final deactivatedButton = MySubmitButton(
      onTap: () => onStatusChange(user, false),
      buttonText: 'Deactivate',
      isFilled: true,
      filledColor: Colors.red,
    );
    if (user.accountStatus == AccountStatusEnum.PENDING) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          activatedButton,
          deactivatedButton,
        ],
      );
    } else if (user.accountStatus == AccountStatusEnum.INACTIVE) {
      return Center(
        child: activatedButton,
      );
    } else if (user.accountStatus == AccountStatusEnum.ACTIVE) {
      return Center(
        child: deactivatedButton,
      );
    } else {
      return Container();
    }
  }
}
