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
        padding: EdgeInsets.symmetric(horizontal: 16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          // border: Border(
          //   bottom: BorderSide(width: 1, color: Colors.orange.shade700),
          // ),
        ),
        child:
            user != null
                ? StreamBuilder(
                  stream:
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(user.uid)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || !snapshot.data!.exists) {
                      return Text('Profil utilisateur introuvable.');
                    }

                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        userData["photo"] != null &&
                                userData["photo"].toString().isNotEmpty
                            ? CircleAvatar(
                              radius: 35.r,
                              backgroundColor: Colors.grey[200],
                              child: ClipOval(
                                child: Image.network(
                                  userData["photo"],
                                  width: 60.w,
                                  height: 60.h,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                            : Icon(Icons.person_outline_rounded, size: 50.sp),
                        userData["name"] != null &&
                                userData["name"].toString().isNotEmpty
                            ? Text(
                              userData["name"],
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            )
                            : Text(
                              "Mon Micro Sugu",
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),

                        Text(
                          userData["email"],
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    );
                  },
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_outline_rounded, size: 50.sp),
                    Text(
                      "Mon Micro Sugu",
                      style: GoogleFonts.roboto(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    Text(
                      "example@gmail.com",
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
