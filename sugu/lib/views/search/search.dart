import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sugu/models/product_model.dart';
import 'package:sugu/views/detail/detail.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  List<ProductModel> fakeVehiculeData = ProductModel.getProducts();
  TextEditingController searchValue = TextEditingController();
  List resultOfSearch = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();

    _loadRecentSearches();

    // Ajouter un écouteur pour le champ de recherche
    searchValue.addListener(() {
      setState(() {
        if (searchValue.text.isEmpty) {
          resultOfSearch = [];
        } else {
          resultOfSearch =
              fakeVehiculeData
                  .where(
                    (item) => item.titre.toLowerCase().contains(
                      searchValue.text.toLowerCase(),
                    ),
                  )
                  .toList();
        }
      });
    });
  }

  @override
  void dispose() {
    searchValue.dispose();
    super.dispose();
  }

  void _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  void _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('recentSearches', recentSearches);
  }

  void addRecentSearch(String search) {
    if (!recentSearches.contains(search)) {
      setState(() {
        recentSearches.add(search);
        if (recentSearches.length > 30) {
          recentSearches.removeAt(
            0,
          ); // Garder seulement les 5 recherches les plus récentes
        }
        _saveRecentSearches();
      });
    }
  }

  void _handleSearch(String value) {
    if (value.isNotEmpty) {
      addRecentSearch(value);
    }
    setState(() {
      resultOfSearch =
          fakeVehiculeData
              .where(
                (item) =>
                    item.titre.toLowerCase().contains(value.toLowerCase()),
              )
              .toList();
    });
  }

  void _removeRecenteSearch(String search) {
    setState(() {
      recentSearches.remove(search);
      _saveRecentSearches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              pinned: true,
              floating: true,
              toolbarHeight: 65.h,
              flexibleSpace: FlexibleSpaceBar(
                 background: Container(color: Colors.white,),
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
                  child: TextFormField(
                    controller: searchValue,
                    decoration: InputDecoration(
                      isDense: true,
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.black,
                        size: 30.sp,
                      ),
                      hintText: "Que voulez-vous acheter ?",
                      hintStyle: GoogleFonts.roboto(fontSize: 15.sp),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.r),
                        borderSide: BorderSide.none
                      ),
                    ),
                    onFieldSubmitted: _handleSearch,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (searchValue.text.isEmpty) {
                    // Afficher les recherches récentes
                    if (recentSearches.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    final search = recentSearches.reversed.toList()[index];
                    return Container(
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.history, size: 16.sp),
                        title: Text(
                          search,
                          style: GoogleFonts.roboto(fontSize: 16.sp),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.close, size: 16.sp),
                          onPressed: () => _removeRecenteSearch(search),
                        ),
                        onTap: () {
                          searchValue.text = search;
                          _handleSearch(search);
                        },
                      ),
                    );
                  } else if (resultOfSearch.isEmpty) {
                    // Aucun résultat
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Aucun résultat trouvé',
                          style: GoogleFonts.roboto(fontSize: 14.sp),
                        ),
                      ),
                    );
                  } else {
                    // Afficher les résultats
                    ProductModel item = resultOfSearch[index];
                    return Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!, width: 1),
                        ),
                      ),
                      child: ListTile(
                        leading:
                            item.images.isNotEmpty
                                ? Image.network(
                                  item.images[0] ?? "",
                                  width: 50.w,
                                  height: 50.h,
                                  fit: BoxFit.cover,
                                )
                                : null,
                        title: Text(
                          item.titre,
                          style: GoogleFonts.roboto(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          "${item.prix} FCFA",
                          style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        onTap: () {
                          // Naviguer vers la page de détails
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SingleView(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
                childCount:
                    searchValue.text.isEmpty
                        ? recentSearches.length
                        : resultOfSearch.isEmpty
                        ? 1
                        : resultOfSearch.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
