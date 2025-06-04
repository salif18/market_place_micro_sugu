import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/auth/initialize.dart';
// import 'package:sugu/views/auth/forget_pass.dart';

class UpdatePassView extends StatefulWidget {
  const UpdatePassView({super.key});

  @override
  State<UpdatePassView> createState() => _UpdatePassViewState();
}

class _UpdatePassViewState extends State<UpdatePassView> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  // Contrôleurs pour les champs de formulaire
  final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _newPassword = TextEditingController();
  // final TextEditingController _passwordConfirmation = TextEditingController();

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

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ $message")));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    // _newPassword.dispose();
    // _passwordConfirmation.dispose();
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
                  "Sécurisation",
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
                        "Veuillez entrer email pour modifier votre mot de passe en fin de proteger votre compte. ",
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez email';
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
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 16.r,
                      //     vertical: 8.r,
                      //   ),
                      //   child: TextFormField(
                      //     keyboardType: TextInputType.visiblePassword,
                      //     obscureText: true,
                      //     controller: _newPassword,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Veuillez entrer votre nouveau mot de passe';
                      //       }
                      //       return null;
                      //     },
                      //     decoration: InputDecoration(
                      //       hintText: "Nouveau mot de passe",
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
                      //       suffixIcon: Icon(Mdi.eyeOffOutline, size: 22.sp),
                      //     ),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(
                      //     horizontal: 16.r,
                      //     vertical: 8.r,
                      //   ),
                      //   child: TextFormField(
                      //     keyboardType: TextInputType.visiblePassword,
                      //     obscureText: true,
                      //     controller: _passwordConfirmation,
                      //     validator: (value) {
                      //       if (value!.isEmpty) {
                      //         return 'Veuillez retaper votre nouveau mot de passe';
                      //       }
                      //       return null;
                      //     },
                      //     decoration: InputDecoration(
                      //       hintText: "Rétaper le nouveau mot de passe",
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
                      //       suffixIcon: Icon(Mdi.eyeOffOutline, size: 22.sp),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            // SliverPadding(
            //   padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 5.r),
            //   sliver: SliverToBoxAdapter(
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.end,
            //       children: [
            //         TextButton(
            //           onPressed: () {
            //             Navigator.push(
            //               context,
            //               MaterialPageRoute(
            //                 builder: (context) => const ForgetPassWordView(),
            //               ),
            //             );
            //           },
            //           child: Text(
            //             "Mot de passe oublié ?",
            //             style: GoogleFonts.roboto(
            //               fontSize: 12.sp,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.blueAccent,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 20.r),
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
                      "Valider",
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
