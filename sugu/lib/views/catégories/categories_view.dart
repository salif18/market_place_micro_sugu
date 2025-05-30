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
  List<ProductModel> fakeVehiculeData = ProductModel.getProducts();

  @override
  Widget build(BuildContext context) {
    final filteredData =
        fakeVehiculeData.where((item) {
          return item.categorie == widget.categoryName;
        }).toList();
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
            SliverPadding(
              padding: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 4,
                  childAspectRatio: 0.85,
                ),
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  ProductModel item = filteredData[index];
                  return GestureDetector(
                    onTap: () {
                      // Action on product tap
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SingleView(item: item),
                        ),
                      );
                    },
                    child: Container(
                      width: 200.w,
                      height: 200.h,
                     // margin: EdgeInsets.all(8.r),
                      color: Colors.white,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.network(
                              item.images[0],
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          SizedBox(height: 10.r),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.r),
                            child: Text(
                              item.titre,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ),
                             SizedBox(height: 5.h),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5.r),
                              child: Text(
                                item.prix + " " + "FCFA",
                                style: GoogleFonts.roboto(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }, childCount: filteredData.length),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
