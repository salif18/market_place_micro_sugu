import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildProfilInfos extends StatelessWidget {
  final user;
  BuildProfilInfos({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 12.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: user != null
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Text('Profil utilisateur introuvable.');
                  }

                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      userData["photo"] != null &&
                              userData["photo"].toString().isNotEmpty
                          ? CircleAvatar(
                              radius: 35.r,
                              backgroundColor: Colors.grey[200],
                              backgroundImage:
                                  NetworkImage(userData["photo"]),
                            )
                          : Icon(Icons.person_outline_rounded,
                              size: 60.sp, color: Colors.grey),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData["name"]?.toString().isNotEmpty == true
                                  ? userData["name"]
                                  : "Mon Micro Sugu",
                              style: GoogleFonts.roboto(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              userData["email"] ?? "",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                },
              )
            : Row(
                children: [
                  Icon(Icons.person_outline_rounded,
                      size: 60.sp, color: Colors.grey),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Mon Micro Sugu",
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "example@gmail.com",
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
