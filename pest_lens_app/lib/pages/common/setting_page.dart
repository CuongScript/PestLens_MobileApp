import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:pest_lens_app/components/my_text_style.dart';
import 'package:pest_lens_app/models/role_enum.dart';
import 'package:pest_lens_app/pages/authen/login_page.dart';
import 'package:pest_lens_app/preferences/user_preferences.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pest_lens_app/provider/language_provider.dart';
import 'package:pest_lens_app/services/auth_service.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pest_lens_app/pages/common/user_profile_detail_page.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final AuthService _authService = AuthService();
  UserFullInfoModel? userFullInfo;
  double _pestThreshold = 50.0; // Default value
  int _averageDays = 7; // Default value

  @override
  void initState() {
    super.initState();
    _checkAndFetchUserInfo();
  }

  Future<void> _checkAndFetchUserInfo() async {
    userFullInfo = await UserPreferences.getCurrentUserProfileInformation();
    if (userFullInfo == null) {
      await _fetchUserFullInfo();
    }
    setState(() {});
  }

  Future<void> _fetchUserFullInfo() async {
    bool success = await _authService.fetchUserFullInformation();
    if (success) {
      userFullInfo = await UserPreferences.getCurrentUserProfileInformation();
      setState(() {});
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch user information')),
        );
      }
    }
  }

  void _logout(BuildContext context) async {
    await UserPreferences.clearUser();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text(AppLocalizations.of(context)!.setting,
            style: CustomTextStyles.pageTitle),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          _buildUserInfoTile(),
          const SizedBox(height: 24),
          _buildSettingsSection([
            _buildNotificationTile(),
            _buildPestAlertTile(),
            _buildLanguageTile(currentLocale),
            _buildLogoutTile(),
          ]),
        ],
      ),
    );
  }

  Widget _buildUserInfoTile() {
    if (userFullInfo == null) {
      return const SizedBox
          .shrink(); // Return an empty widget if userFullInfo is null
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey[300],
          child: userFullInfo!.avatarUrl != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: userFullInfo!.avatarUrl!,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                )
              : const Icon(Icons.person, size: 30),
        ),
        title: Text(
          '${userFullInfo!.firstName} ${userFullInfo!.lastName}',
          style:
              CustomTextStyles.subtitle.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          userFullInfo!.email,
          style: CustomTextStyles.subtitle.copyWith(color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserProfileDetailPage(
                user: userFullInfo!,
                isFromSettings: true,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsSection(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNotificationTile() {
    return SwitchSettingsTile(
      settingKey: 'key-notification',
      title: "Notification",
      activeColor: appNameColor,
      leading: const Icon(Icons.notifications_rounded, color: fontTitleColor),
      titleTextStyle: CustomTextStyles.subtitle,
      onChange: (bool value) {
        // Handle notification toggle
      },
    );
  }

  Widget _buildPestAlertTile() {
    if (userFullInfo != null && userFullInfo!.roles.contains(Role.ROLE_ADMIN)) {
      return const SizedBox.shrink();
    }
    return ExpandableSettingsTile(
      title: "Pest Alert Settings",
      leading: const Icon(Icons.pest_control, color: fontTitleColor),
      titleTextStyle: CustomTextStyles.subtitle,
      children: [
        SliderSettingsTile(
          title: 'Pest Threshold',
          settingKey: 'pest-threshold',
          defaultValue: _pestThreshold,
          decimalPrecision: 0,
          min: 0,
          max: 100,
          step: 5,
          leading: const Icon(Icons.percent_rounded),
          onChange: (value) {
            setState(() {
              _pestThreshold = value;
            });
          },
        ),
        SliderSettingsTile(
          title: 'Number of Average Days',
          settingKey: 'average-days',
          defaultValue: _averageDays.toDouble(),
          decimalPrecision: 0,
          min: 1,
          max: 30,
          step: 1,
          leading: const Icon(Icons.calendar_today),
          onChange: (value) {
            setState(() {
              _averageDays = value.toInt();
            });
          },
        ),
      ],
    );
  }

  Widget _buildLanguageTile(Locale currentLocale) {
    return DropDownSettingsTile<String>(
      title: "Current Language",
      settingKey: 'key-language',
      values: const <String, String>{
        'en': 'English',
        'vi': 'Tiếng Việt',
      },
      titleTextStyle: CustomTextStyles.subtitle,
      selected: currentLocale.languageCode,
      leading: const Icon(Icons.language_rounded, color: fontTitleColor),
      onChange: (String newValue) {
        ref.read(localeProvider.notifier).setLocale(newValue);
      },
    );
  }

  Widget _buildLogoutTile() {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: fontTitleColor),
      title: Text(
        AppLocalizations.of(context)!.logout,
        style: CustomTextStyles.subtitle,
      ),
      onTap: () => _logout(context),
    );
  }
}
