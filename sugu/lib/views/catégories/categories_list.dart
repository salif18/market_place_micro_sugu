import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/categorie_model.dart';
import 'package:sugu/views/cat%C3%A9gories/categories_view.dart';

class CategorieListView extends StatefulWidget {
  const CategorieListView({super.key});

  @override
  State<CategorieListView> createState() => _CategorieViewState();
}

class _CategorieViewState extends State<CategorieListView> {
   List <CategorieModel> categories = CategorieModel.getCategory();
  
  @override
  Widget build(BuildContext context) {
    // Triez les catégories par nom avant de les utiliser
    final sortedCategories = [...categories]
      ..sort((a, b) => a.name.compareTo(b.name));
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
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                 background: Container(color: Colors.white,),
                centerTitle: true,
                title: Text(
                  "Catégories",
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item =
                      sortedCategories[index]; // Utilisez la liste triée ici
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // Action on product tap
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      CategoriesView(categoryName: item.name),
                            ),
                          );
                        },
                        label: Text(
                          item.name,
                          style: GoogleFonts.roboto(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        icon: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(
                            item.icon,
                            size: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                itemCount: categories.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
