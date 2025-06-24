import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/views/annonces/widgets/no_boost_view.dart';
import 'package:sugu/views/annonces/widgets/prod_boost_view.dart';

class VosAnnonceView extends StatefulWidget {
  const VosAnnonceView({super.key});

  @override
  State<VosAnnonceView> createState() => _VosAnnonceViewState();
}

class _VosAnnonceViewState extends State<VosAnnonceView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: DefaultTabController(
          length: 2,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                elevation: 0.2,
                toolbarHeight: 40.h,
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
                    "Mes annonces",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 8.r, vertical: 5.r),
                sliver: SliverPersistentHeader(
                  pinned: true,
                  floating: true,
                  delegate: _SliverAppBarDelegate(
                    child: _buildContainer(context),
                  ),
                ),
              ),
              // _buildTitleSection(context, "Vos marchandises"),
              SliverFillRemaining(
                child: TabBarView(children: [NoBoosting(), ProdBoosting()]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        ),
      child: Padding(
        padding: EdgeInsets.only(left: 8.r, right: 8.r),
        child: TabBar(
          isScrollable: false,
          indicatorColor:Colors.orange.shade700,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorWeight: 3,
          dividerColor:Colors.transparent, // 👈 empêche le petit trait du bas
          labelColor: Colors.black,
          labelStyle: GoogleFonts.roboto(fontSize:14.sp , fontWeight: FontWeight.w500),
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(
              child: Text(
                "Produits",
              ),
            ),
            Tab(
              child: Text(
                "Produits boostés",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => kToolbarHeight;
  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
