import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sugu/routes.dart';
import 'package:sugu/views/abonnement/abonement_view.dart';
import 'package:sugu/views/auth/forget_pass.dart';
import 'package:sugu/views/auth/inscription.dart';

class ConnexionView extends StatefulWidget {
  const ConnexionView({super.key});

  @override
  State<ConnexionView> createState() => _ConnexionViewState();
}

class _ConnexionViewState extends State<ConnexionView> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Contrôleurs pour les champs de formulaire
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool view_password = true;

  void _signInWithEmailAndPassword() async {
    if (_globalKey.currentState!.validate()) {
      try {
        showDialog(
          context: context,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          },
        );
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _contactController.text.trim(),
          password: _passwordController.text.trim(),
        );

        final user = userCredential.user;
        if (user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MyRoots()),
            (Route) => false,
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = '';
        if (e.code == 'invalid-email') {
          message = 'Adresse email invalide.';
        } else if (e.code == 'invalid-credential') {
          message = 'Vérifiez votre email ou mot de passe.';
        } else {
          message = 'Erreur inconnue (${e.code}) : ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepOrangeAccent,
            content: Text(
              message,
              style: GoogleFonts.roboto(fontSize: 14.sp, color: Colors.white),
            ),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
      );
      // Déclencher la fenêtre de connexion Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print('Connexion annulée par l’utilisateur.');
        return;
      }

      // Récupérer les infos d'authentification
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Connexion Firebase avec l'identifiant Google
      UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      // Récupérer l'utilisateur
      final user = userCredential.user;

      // Vérifier si c'est un nouvel utilisateur
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _firestore.collection('users').doc(user!.uid).set({
          "userId": user.uid,
          'name': user.displayName,
          'email': user.email,
          'numero': user.phoneNumber ?? "",
          'photo': user.photoURL ?? "",
          'role': 'vendeur',
          'isPremium': false,
          'boostActive':false,
          'subscriptionUntil': '',
          'createdAt': Timestamp.now(),
          'provider': 'google',
        });
      }

      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyRoots()),
          (route) => false,
        );
      }

      print('Connexion réussie avec Google : ${user?.email}');
    } catch (e) {
      print('Erreur Google Sign-In : $e');
    }
  }

  @override
  void dispose() {
    // Nettoyage des contrôleurs
    _contactController.dispose();
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
                  "Connexion",
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
                        height: 100.h,
                        child: Image.asset(
                          "assets/logos/logo.png",
                          fit: BoxFit.cover,
                          width: 200.w,
                          height: 150.h,
                        ),
                      ),
                      Text(
                        "Bienvenue parmi nous, nous sommes ravis de vous retrouver! ",
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
                          controller: _contactController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un numéro ou un e-mail';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Numéro ou email",
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: view_password,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre mot de passe';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Mot de passe",
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
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  view_password = !view_password;
                                });
                              },
                              icon: Icon(
                                view_password
                                    ? Mdi.eyeOffOutline
                                    : Mdi.eyeOutline,
                                size: 22.sp,
                              ),
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
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 5.r),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassWordView(),
                          ),
                        );
                      },
                      child: Text(
                        "Mot de passe oublié ?",
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 10.r),
              sliver: SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.r),
                  child: ElevatedButton(
                    onPressed: () {
                      _signInWithEmailAndPassword();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,

                      minimumSize: Size(400.w, 40.h),
                    ),
                    child: Text(
                      "Se connecter",
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
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.black, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        "Ou continuer avec",
                        style: GoogleFonts.roboto(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.black, thickness: 1)),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 0.r),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(width: 2.2.sp, color: Colors.white),
                      ),
                      child: IconButton(
                        onPressed: () {
                          signInWithGoogle();
                        },
                        icon: Image.asset(
                          "assets/images/google.jpg",
                          width: 40.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Vous n'avez pas de compte?",
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InscriptionView(),
                            ),
                          );
                        },
                        child: Text(
                          "Créer",
                          style: GoogleFonts.roboto(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
