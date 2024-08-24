import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pest_lens_app/models/user_full_info_model.dart';
import 'package:pest_lens_app/models/account_status_enum.dart';
import 'package:pest_lens_app/components/user_brief_info_row.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MySlidable extends StatelessWidget {
  final UserFullInfoModel user;
  final Function(UserFullInfoModel, bool) onStatusChange;
  final VoidCallback onTap;

  const MySlidable({
    super.key,
    required this.user,
    required this.onStatusChange,
    required this.onTap,
  });

  Future<bool?> _showConfirmationDialog(
      BuildContext context, bool isActivate) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isActivate
              ? AppLocalizations.of(context)!.activeUser
              : AppLocalizations.of(context)!.deactiveUser),
          content: Text(isActivate
              ? AppLocalizations.of(context)!.activateUser
              : AppLocalizations.of(context)!.deactivateUser),
          // 'Are you sure you want to ${isActivate ? 'activate' : 'deactivate'} this user?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppLocalizations.of(context)!.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(AppLocalizations.of(context)!.confirm),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SlidableAction> actions = [];

    // Add Activate button for INACTIVE or PENDING users
    if (user.accountStatus == AccountStatusEnum.INACTIVE) {
      actions.add(
        SlidableAction(
          onPressed: (context) async {
            bool? confirm = await _showConfirmationDialog(context, true);
            if (confirm == true) {
              onStatusChange(user, true);
            }
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.check,
          label: AppLocalizations.of(context)!.activate,
        ),
      );
    } else if (user.accountStatus == AccountStatusEnum.PENDING) {
      actions.add(
        SlidableAction(
          onPressed: (context) async {
            bool? confirm = await _showConfirmationDialog(context, true);
            if (confirm == true) {
              onStatusChange(user, true);
            }
          },
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.check,
          label: AppLocalizations.of(context)!.activate,
        ),
      );
      actions.add(
        SlidableAction(
          onPressed: (context) async {
            bool? confirm = await _showConfirmationDialog(context, false);
            if (confirm == true) {
              onStatusChange(user, false);
            }
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: AppLocalizations.of(context)!.deactivate,
        ),
      );
    }

    // Add Deactivate button for ACTIVE users
    else if (user.accountStatus == AccountStatusEnum.ACTIVE) {
      actions.add(
        SlidableAction(
          onPressed: (context) async {
            bool? confirm = await _showConfirmationDialog(context, false);
            if (confirm == true) {
              onStatusChange(user, false);
            }
          },
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: AppLocalizations.of(context)!.deactivate,
        ),
      );
    }

    return Slidable(
      key: Key(user.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: actions,
      ),
      child: UserBriefInfoRow(user: user, onTap: onTap),
    );
  }
}
