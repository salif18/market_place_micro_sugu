import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AideView extends StatefulWidget {
  const AideView({super.key});

  @override
  State<AideView> createState() => _AideViewState();
}

class _AideViewState extends State<AideView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
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
                  "Aide",
                  style: GoogleFonts.montserrat(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 20.r),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Text(
                    '🛍️ Bienvenue sur MicroSugu !',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 10.r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'MicroSugu est une plateforme dédiée aux petits commerçants, artisans, vendeurs de quartier et auto-entrepreneurs du Mali. '
                      'L’application vous permet de publier vos produits, gérer vos ventes et atteindre une clientèle plus large, en toute simplicité, depuis votre téléphone.\n\n'
                      'Que vous vendiez du tissu, de la nourriture, des accessoires ou des services, MicroSugu vous aide à rendre votre commerce plus visible et plus accessible.',
                      style: GoogleFonts.lato(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '🎯 Objectif de MicroSugu',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 10.r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Text(
                      'Nous voulons digitaliser les petits marchés du Mali et donner aux commerçants locaux les outils pour évoluer dans un monde connecté. '
                      'MicroSugu valorise l’économie locale, l’inclusion numérique et l’entrepreneuriat de proximité.',
                      style: GoogleFonts.lato(fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    '🧭 Comment ça marche ?',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BulletList([
                    'Créez un compte gratuitement',
                    'Ajoutez vos produits avec photo, prix et description',
                    'Recevez les commandes ou messages des clients dépuis sur votre WhatsApp',
                    'Organisez vos ventes et livraisons simplement',
                  ]),
                  SizedBox(height: 16.h),
                  Text(
                    '🤝 Pour qui ?',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BulletList([
                    'Vendeurs de marché',
                    'Boutiques de quartier',
                    'Livreurs à domicile',
                    'Créateurs, artisans et couturiers',
                    'Toute personne souhaitant vendre facilement sans boutique physique',
                  ]),
                  SizedBox(height: 16.h),
                  Text(
                    '📲 Pourquoi MicroSugu ?',
                    style: GoogleFonts.roboto(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  BulletList([
                    'Facile à utiliser',
                    'Conçu pour les réalités locales',
                    'Peu de données consommées',
                    'Interface en français et bambara bientôt disponible',
                    'Support local et conseils pour améliorer vos ventes',
                  ]),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletList extends StatelessWidget {
  final List<String> items;
  const BulletList(this.items, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          items
              .map(
                (item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8.r,
                      horizontal: 10.r,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("• ", style: TextStyle(fontSize: 16.sp)),
                        Expanded(
                          child: Text(
                            item,
                            style: GoogleFonts.lato(fontSize: 14.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
