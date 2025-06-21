import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/routes.dart';
import 'package:sugu/views/payement/payement_view.dart';

class AbonnementPage extends StatefulWidget {
  const AbonnementPage({super.key});

  @override
  State<AbonnementPage> createState() => _AbonnementPageState();
}

class _AbonnementPageState extends State<AbonnementPage> {
  bool hasTried = false;
  bool isLoading = false; // Pour afficher un loader pendant un paiement

  // Fonction pour activer un abonnement premium pendant 90 jours
  Future<void> activerEssay(BuildContext context) async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final finAbonnement = DateTime.now().add(Duration(days: 1));

      // ⚠️ À décommenter si tu veux enregistrer dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
            'isPremium': true,
            'subscriptionUntil': finAbonnement.toIso8601String(),
            'startTrial': DateTime.now().toIso8601String(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Abonnement activé jusqu’au ${finAbonnement.day}/${finAbonnement.month}/${finAbonnement.year}",
          ),
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyRoots()),
        (route) => false,
      );
    } catch (e) {
      print("Erreur abonnement : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfUserHasTried();
  }

  // verification si le essay est epuise pour interdire certaine truc
  Future<void> checkIfUserHasTried() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
    final data = doc.data();

    if (data != null && data['startTrial'] != null) {
      setState(() {
        hasTried = true; // utilisateur a déjà activé un essai
        isLoading = false;
      });
    } else {
      setState(() {
        hasTried = false; // pas encore essayé
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0.2,
                toolbarHeight: 45.h,
                pinned: true,
                floating: true,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(color: Colors.white),
                  centerTitle: true,
                  title: Text(
                    "Abonnement premium",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16.r),
                sliver: SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activer votre compte premium",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "✅ Créez un nombre illimité d'événements\n"
                        "✅ Suivi des ventes et des revenus\n"
                        "✅ Statistiques avancées\n"
                        "✅ Priorité dans l'affichage",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Tarif : 10 000 FCFA / 3 mois",
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 200.h),
                      ElevatedButton.icon(
                        onPressed:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PayementView(amount: 10000),
                              ),
                            ),
                        icon: Icon(
                          Icons.lock_open,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                        label: Text(
                          "Activer maintenant",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: EdgeInsets.symmetric(vertical: 14.r),
                          minimumSize: Size.fromHeight(50.r),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : (!hasTried
                              ? ElevatedButton.icon(
                                onPressed: () => activerEssay(context),
                                icon: Icon(
                                  Icons.lock_open,
                                  size: 24.sp,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Mode d’Essai 1 jour",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  padding: EdgeInsets.symmetric(vertical: 14.r),
                                  minimumSize: Size.fromHeight(50.r),
                                ),
                              )
                              : SizedBox()), // bouton caché si déjà essayé
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
