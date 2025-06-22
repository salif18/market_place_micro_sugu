import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/profil/widget/a_propos_btn.dart';
import 'package:sugu/views/profil/widget/abonnement_btn.dart';
import 'package:sugu/views/profil/widget/aide_btn.dart';
import 'package:sugu/views/profil/widget/annonces_btn.dart';
import 'package:sugu/views/profil/widget/boost_btn.dart';
import 'package:sugu/views/profil/widget/connexion_btn.dart';
// import 'package:sugu/views/profil/widget/copyrigth.dart';
import 'package:sugu/views/profil/widget/deconnexion_btn.dart';
import 'package:sugu/views/profil/widget/delete_btn.dart';
import 'package:sugu/views/profil/widget/infos_profil.dart';
import 'package:sugu/views/profil/widget/notification_btn.dart';
import 'package:sugu/views/profil/widget/security_btn.dart';
import 'package:sugu/views/profil/widget/share_btn.dart';
import 'package:sugu/views/profil/widget/stats_btn.dart';

class ProfilView extends StatefulWidget {
  const ProfilView({super.key});

  @override
  State<ProfilView> createState() => _ProfilViewState();
}

class _ProfilViewState extends State<ProfilView> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    checkIfAdmin();
  }

  Future<void> checkIfAdmin() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final isUserAdmin = doc.data()?['role'] == 'admin';
      setState(() {
        isAdmin = isUserAdmin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
                background: Container(color: Colors.white),
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
                BuildProfilInfos(user: user),    
                if (user != null) BuildAbonementBouton(),
                if (user != null)BuildBoostBouton(),
                BuildAnnonceBouton(),
                if(isAdmin) BuildStatBouton(),
                BuildNotificationBtn(),
                BuildHelpBouton(),
                BuildAboutBouton(),
                BuildShareBouton(),
                if (user != null) BuildSecurityBouton(),
                if (user != null) BuildDeleteBouton(),
                if (user == null) BuildConnexionBouton(),
                if (user != null) BuildLogoutBouton(),
                // SizedBox(height: 125.h),
                // BuildCopyrigth(),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
