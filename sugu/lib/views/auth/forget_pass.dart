import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/auth/initialize.dart';

class ForgetPassWordView extends StatefulWidget {
  const ForgetPassWordView({super.key});

  @override
  State<ForgetPassWordView> createState() => _ForgetPassWordViewState();
}

class _ForgetPassWordViewState extends State<ForgetPassWordView> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // Contrôleurs pour les champs de formulaire
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 void _submitForm() async {
  if (!_globalKey.currentState!.validate()) return;

  final email = _emailController.text.trim();

  // Affichage d'un indicateur de chargement (optionnel)
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

    Navigator.pop(context); // Fermer le loader

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("📩 Email de réinitialisation envoyé.")),
    );

    // Aller vers un autre écran (optionnel)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => InitializeVew()),
    );
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Fermer le loader si erreur

    String message;
    switch (e.code) {
      case 'user-not-found':
        message = "Aucun utilisateur trouvé avec cet email.";
        break;
      case 'invalid-email':
        message = "Email invalide.";
        break;
      default:
        message = "Erreur : ${e.message}";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ $message")),
    );
  }
}


  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 0.2,
              toolbarHeight: 40.h,
              pinned: true,
              floating: true,
              backgroundColor: Colors.grey[100],
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                 background: Container(color: Colors.grey[100]),
                centerTitle: true,
                title: Text(
                  "Récuperation de compte",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 150.h,
                        child: Image.asset(
                          "assets/logos/logo.png",
                          fit: BoxFit.cover,
                          width: 200.w,
                          height: 200.h,
                        ),
                      ),
                      Text(
                        "Pour récuperer votre compte! ",
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        "Veuiller remplir avec les informations correctes ",
                        style: GoogleFonts.lato(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 8.r),
              sliver: SliverToBoxAdapter(
                child: Form(
                  key: _globalKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 16.r,
                      //     vertical: 8.r,
                      //   ),
                      //   child: TextFormField(
                      //     keyboardType: TextInputType.text,
                      //     controller: _contactController,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Veuillez entrer un numéro ';
                      //       }
                      //       return null;
                      //     },
                      //     decoration: InputDecoration(
                      //       hintText: "Numéro",
                      //       hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                      //       filled: true,
                      //       fillColor: Colors.white,
                      //       contentPadding: EdgeInsets.symmetric(
                      //         horizontal: 16.r,
                      //         vertical: 10.r,
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(10.r),
                      //         borderSide: BorderSide.none,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: GoogleFonts.roboto(fontSize: 16.sp),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.r,
                              vertical: 10.r,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.r),
                  child: ElevatedButton(
                    onPressed: () {
                      _submitForm();
                    },
        
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,
        
                      minimumSize: Size(400.w, 40.h),
                    ),
                    child: Text(
                      "Envoyer",
                      style: GoogleFonts.roboto(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
