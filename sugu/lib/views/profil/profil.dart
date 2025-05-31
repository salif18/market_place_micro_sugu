import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/about/about.dart';
import 'package:sugu/views/annonces/annonce.dart';
import 'package:sugu/views/auth/connexion.dart';
import 'package:sugu/views/auth/update_pass.dart';
import 'package:sugu/views/help/help.dart';
import 'package:sugu/views/profil/widget/share.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white, // Couleur opaque
              elevation: 0, // Supprime l'ombre si nécessaire
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              flexibleSpace: FlexibleSpaceBar(
                 background: Container(color: Colors.white,),
                centerTitle: true,
                title: Text(
                  "Profil",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 16.r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: Column(
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
                          "Username@gmail.com",
                          style: GoogleFonts.roboto(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.mode_edit_outline_outlined,
                        size: 20.sp,
                      ),
                      title: Text(
                        "Modifier profil",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ConnexionView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.tagOutline, size: 20.sp),
                      title: Text(
                        "Vos annonces",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const VosAnnonceView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.help, size: 20.sp),
                      title: Text(
                        "Aide",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AideView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.informationOutline, size: 20.sp),
                      title: Text(
                        "A propos de Micro Sugu",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AboutView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.share_outlined, size: 20.sp),
                      title: Text(
                        "Partager",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => ShareAppUtils.shareApp(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.securityNetwork, size: 20.sp),
                      title: Text(
                        "Sécurités",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UpdatePassView(),
                            ),
                          ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.deleteOutline, size: 20.sp),
                      title: Text(
                        "Supprimer votre compte",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => _showDeleteAccountDialog(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.grey[200]!),
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(Mdi.logout, size: 20.sp),
                      title: Text(
                        "Se déconnecter",
                        style: GoogleFonts.roboto(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 18.sp,
                      ),
                      onTap: () => _showLogoutDialog(context),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.r),
                   height: 100.h,
                    color: Colors.grey[200],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                                  
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Copyright ",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Icon(Mdi.copyright, size: 14.sp),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "2025",
                                  style: GoogleFonts.roboto(
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                  "assets/logos/logo.png",
                                  width: 80.w,
                                  height: 100.h,
                                  fit: BoxFit.cover,
                                ),
                              ),
                                  
                             
                            ],
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text("Développer par Salif Moctar")
                            ),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _showDeleteAccountDialog(BuildContext context) async {
    return await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder:
          (context) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Icon(
                      Icons.warning_rounded,
                      size: 48.sp,
                      color: Colors.orange[700],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Suppression de compte",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.red[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Êtes-vous sûr de vouloir supprimer définitivement votre compte ? "
                    "Cette action est irréversible et toutes vos données seront perdues.",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Annuler",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            padding: EdgeInsets.symmetric(vertical: 16.r),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "Supprimer",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  _showLogoutDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout_rounded,
                    size: 48.sp,
                    color: Colors.deepOrange[700],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Déconnexion",
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "Voulez-vous vraiment vous déconnecter ?",
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.r),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(
                            "Non",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange[700],
                            padding: EdgeInsets.symmetric(vertical: 14.r),
                          ),
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(
                            "Oui",
                            style: GoogleFonts.roboto(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
