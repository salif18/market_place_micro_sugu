import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/detail/detail.dart';

class CategoriesView extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final categoryName;
  const CategoriesView({super.key, required this.categoryName});

  @override
  State<CategoriesView> createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {

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
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.arrow_back_ios_rounded, size: 18.sp),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                background: Container(color: Colors.white,),
                title: Text(
                  widget.categoryName,
                  style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
             StreamBuilder(
              stream:
                  FirebaseFirestore.instance
                      .collection('articles')
                      .where('categorie', isEqualTo: widget.categoryName)          
                      .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverFillRemaining(
                    child: const Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: const Center(
                      child: Text("Une erreur s'est produite"),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return SliverFillRemaining(
                    child: const Center(
                      child: Text("Aucun donnés disponibles"),
                    ),
                  );
                } else {
                  List<ProductModel> articles =
                      snapshot.data!.docs.map((doc) {
                        return ProductModel.fromJson(doc.data(), doc.id);
                      }).toList();
                  return SliverPadding(
                      padding: EdgeInsets.symmetric(
                        vertical: 8.r,
                        horizontal: 10.r,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 1,
                              mainAxisSpacing: 1,
                              childAspectRatio:
                                  0.78, // Ajuste pour obtenir une belle carte
                            ),
                        delegate: SliverChildBuilderDelegate((
                          BuildContext context,
                          int index,
                        ) {
                          ProductModel item = articles[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SingleView(item: item),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 0,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.r),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image produit
                                  AspectRatio(
                                    aspectRatio: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                            border: Border.all(
                                              color:
                                                  Colors.grey[200]!, // couleur de la bordure
                                              width:
                                                  1.r, // épaisseur de la bordure
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10.r,
                                            ),
                                          ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                        10.r,
                                        ),
                                        child: item.images.isNotEmpty ? Image.network(
                                              item.images.isNotEmpty
                                                  ? item.images[0]
                                                  : '',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ) : Image.asset("assets/images/default.png", 
                                            fit: BoxFit.cover,
                                            width: double.infinity,),
                                      ),
                                    ),
                                  ),
                                  // Espace
                                  SizedBox(height: 8.h),
                                  // Titre
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.r,
                                      ),
                                      child: Text(
                                        item.titre,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1.h),
                                  // Prix
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.r,
                                      ),
                                      child: Text(
                                        "${item.prix} FCFA",
                                        style: GoogleFonts.roboto(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }, childCount: articles.length),
                      ),
                    );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
