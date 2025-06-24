import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugu/provider/notification_provider.dart';
import 'package:sugu/views/profil/notification_setting.dart';

class BuildNotificationBtn extends StatefulWidget {
  const BuildNotificationBtn({super.key});

  @override
  State<BuildNotificationBtn> createState() => _BuildNotificationBtnState();
}

class _BuildNotificationBtnState extends State<BuildNotificationBtn> {
  bool showNotificationPanel = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.grey[200]!),
              ),
            ),
            child: ListTile(
              onTap: () {
                setState(() {
                  showNotificationPanel = !showNotificationPanel;
                });
              },
              leading: Consumer<NotificationController>(
                builder: (context, controller, _) {
                  return Icon(
                    controller.isEnabled
                        ? Icons.notifications_none
                        : Icons.notifications_off_outlined,
                    size: 22.sp,
                    color: Colors.black
                  );
                },
              ),
              title: Text(
                "Notification",
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              trailing: Icon(
                showNotificationPanel
                    ? Icons.keyboard_arrow_down_outlined
                    : Icons.arrow_forward_ios_rounded,
                size: 18.sp,
              ),
            ),
          ),
          // Panneau notification visible seulement si activé
          if (showNotificationPanel) NotificationSettingsPage(),
        ],
      ),
    );
  }
}
