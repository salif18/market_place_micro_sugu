
import 'package:flutter/material.dart';
import 'package:flutter_mdi_icons/flutter_mdi_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sugu/provider/favorite_provider.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_list.dart';


import 'package:sugu/views/favorites/favorite.dart';
import 'package:sugu/views/home/home.dart';
import 'package:sugu/views/profil/profil.dart';
import 'package:sugu/views/vendre/vendre.dart';

class MyRoots extends StatefulWidget {
  const MyRoots({super.key});

  @override
  State<MyRoots> createState() => _MyRootsState();
}

class _MyRootsState extends State<MyRoots> {
  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:
          <Widget>[
            HomeView(),
            FavoriteView(),
            CategorieListView(),
            AnnonceView(),
            ProfilView()
          ][_currentIndex],
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Colors.grey[100]!)),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 20,
        selectedItemColor: Colors.orange.shade700,
        unselectedItemColor: Colors.grey[400],
        iconSize: 25.sp,
        selectedLabelStyle: GoogleFonts.roboto(fontSize: 12.sp),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_sharp),
            label: "Sugu",
          ),
          BottomNavigationBarItem(
            icon: Consumer<FavoriteProvider>(
              builder: (context, provider, child) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(Icons.star_border),
                    if (provider.getFavorites.isNotEmpty)
                      Positioned(
                        right: -4,
                        top: 0,
                        child: Badge.count(
                          count: provider.getFavorites.length,
                          // largeSize: 40.sp / 2,
                          backgroundColor: Colors.orange.shade700,
                          textColor: Colors.white,
                          textStyle: GoogleFonts.roboto(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            label: "Mes favoris",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Mdi.googleAssistant),
            label: "Catégories",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_business_outlined),
            label: "Vendre",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            label: "Vendeur",
          ),
        ],
      ),
    );
  }
}
