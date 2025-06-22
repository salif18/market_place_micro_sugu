import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sugu/routes.dart';
import 'package:sugu/views/abonnement/abonement_view.dart';
import 'package:sugu/views/auth/connexion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sugu/views/profil/profil.dart';

class InscriptionView extends StatefulWidget {
  const InscriptionView({super.key});

  @override
  State<InscriptionView> createState() => _InscriptionViewState();
}

class _InscriptionViewState extends State<InscriptionView> {
  // CLE KEY POUR LE FORMULAIRE
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Contrôleurs pour les champs de formulaire
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _view_password = true;

  Future<void> _singInWithEmailAndPassword() async {
    // Vérification des champs obligatoires
    try {
      if (_globalKey.currentState!.validate()) {
         showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
        // Étape 1 : créer l'utilisateur
        UserCredential userCred = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        final uid = userCred.user!.uid;

        // Étape 2 : enregistrer les infos dans Firestore
        await _firestore.collection('users').doc(uid).set({
          'userId': uid,
          'name': _nameController.text,
          'numero': _numeroController.text,
          'email': _emailController.text,
          "photo": '',
          'role':'vendeur',
          'isPremium': false,
          'boostActive':false,
          'subscriptionUntil':'',
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Inscription réussie')));
        
         if (userCred.user != null) {
        print("Connecté : ${userCred.user!.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyRoots()),
        );
      }
      } else {
        return;
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Erreur inconnue';
      if (e.code == 'weak-password') message = 'Mot de passe trop faible';
      if (e.code == 'email-already-in-use') message = 'Email déjà utilisé';
      if (e.code == 'invalid-email') message = 'Email invalide';

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      Navigator.pop(context);
    } catch (e) {
      print('Erreur: $e');
    } finally {
      // setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
       showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
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
          'role':'vendeur',
          'isPremium': false,
          'boostActive':false,
          'subscriptionUntil':'',
          'createdAt': Timestamp.now(),
          'provider': 'google',
        });
      }
        if (user != null) {
        print("Connecté : ${user.email}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MyRoots()),
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
    _nameController.dispose();
    _numeroController.dispose();
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
                  "Inscription",
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
                          height: 200.h,
                        ),
                      ),
                      Text(
                        "Bienvenue parmi nous, nous seront ravis de votre inscription! ",
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
                          controller: _nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un nom';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Nom",
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
                          keyboardType: TextInputType.phone,
                          controller: _numeroController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre numéro';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: "Numéro",
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
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre e-mail';
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.r,
                          vertical: 8.r,
                        ),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: _view_password,
                          controller: _passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
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
                              onPressed: (){
                                setState(() {
                                  _view_password = !_view_password;
                                });
                              },
                              icon: Icon( _view_password ? Mdi.eyeOffOutline :Mdi.eyeOutline, size: 22.sp)),
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
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14.r),
                  child: ElevatedButton(
                    onPressed: () {
                      _singInWithEmailAndPassword();
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrangeAccent,

                      minimumSize: Size(400.w, 40.h),
                    ),
                    child: Text(
                      "Créer compte",
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
                        icon: Image.asset("assets/images/google.jpg",width: 40.w , height: 40.h,fit:  BoxFit.cover,),
                      ),
                    ),
                    // SizedBox(width: 20.w),
                    // Container(
                    //   width: 80.w,
                    //   height: 40.h,
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(10),
                    //     border: Border.all(width: 1.sp, color: Colors.black54),
                    //   ),
                    //   child: IconButton(
                    //     onPressed: () {},
                    //     icon: Icon(Icons.apple_outlined, size: 28.sp),
                    //   ),
                    // ),
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
                      "Vous avez déjà un compte?",
                      style: GoogleFonts.roboto(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnexionView(),
                          ),
                        );
                      },
                      child: Text(
                        "Connexion",
                        style: GoogleFonts.roboto(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
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
