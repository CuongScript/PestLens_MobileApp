import 'package:flutter/material.dart';
import 'package:pest_lens_app/assets/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiveCustomDateMonitorButton extends StatelessWidget {
  final bool isLive;
  final VoidCallback onPressed;

  const LiveCustomDateMonitorButton({
    Key? key,
    required this.isLive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: isLive ? Colors.white : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton.icon(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isLive ? Icons.live_tv_outlined : Icons.date_range,
              color: isLive ? fontTitleColor : Colors.grey[700],
              size: 18,
              key: ValueKey<bool>(isLive),
            ),
          ),
          label: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              isLive
                  ? AppLocalizations.of(context)!.liveMonitor
                  : AppLocalizations.of(context)!.selectCustomDate,
              style: TextStyle(
                color: isLive ? fontTitleColor : Colors.grey[700],
                fontSize: 14,
              ),
              key: ValueKey<bool>(isLive),
            ),
          ),
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          ),
        ),
      ),
    );
  }
}
