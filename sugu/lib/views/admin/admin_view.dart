import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AdminStatsPage extends StatefulWidget {
  const AdminStatsPage({super.key});

  @override
  State<AdminStatsPage> createState() => _AdminStatsPageState();
}

class _AdminStatsPageState extends State<AdminStatsPage> {
  int userCount = 0;
  int premiumCount = 0;
  int productCount = 0;
  int transactionCount = 0;
  int totalRevenue = 0;
  int boostedCount = 0;

  List<Map<String, dynamic>> recentTransactions = [];

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    final users = await FirebaseFirestore.instance.collection('users').get();
    final articles =
        await FirebaseFirestore.instance.collection('articles').get();
    final transactions =
        await FirebaseFirestore.instance
            .collection('transactions')
            .orderBy('createdAt', descending: true)
            .limit(10)
            .get();

    int total = 0;
    for (var doc in transactions.docs) {
      final montant = doc.data()['montant'];
      if (montant is int) total += montant;
      if (montant is double) total += montant.toInt();
    }

    setState(() {
      userCount = users.docs.length;
      premiumCount =
          users.docs.where((u) => u.data()['isPremium'] == true).length;
      boostedCount =
          articles.docs.where((a) => a.data()['boost'] == true).length;
      productCount = articles.docs.length;
      transactionCount = transactions.docs.length;
      totalRevenue = total;
      recentTransactions = transactions.docs.map((e) => e.data()).toList();
    });
  }

  Widget buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8.r, horizontal: 16.r),
      color: color, // Couleur pleine en fond
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 30.sp), // Icône blanche
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            color: Colors.white, // Texte en blanc
          ),
        ),
        trailing: Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Texte en blanc
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.grey.shade200,Colors.grey.shade100,],
            ),
          ),
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
                    "Statistiques",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(height: 10.h),
                  buildStatCard(
                    "Utilisateurs",
                    "$userCount",
                    Icons.people,
                    Colors.blue,
                  ),
                  buildStatCard(
                    "Utilisateurs Premium",
                    "$premiumCount",
                    Icons.star,
                    Colors.amber,
                  ),
                  buildStatCard(
                    "Produits publiés",
                    "$productCount",
                    Icons.store,
                    Colors.green,
                  ),
                  buildStatCard(
                    "Produits boostés",
                    "$boostedCount",
                    Icons.rocket_launch,
                    Colors.redAccent,
                  ),
                  buildStatCard(
                    "Transactions",
                    "$transactionCount",
                    Icons.receipt,
                    Colors.purple,
                  ),
                  buildStatCard(
                    "Revenu total",
                    "$totalRevenue FCFA",
                    Icons.monetization_on,
                    Colors.orange,
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Text(
                      "Transactions récentes",
                      style: GoogleFonts.poppins(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...recentTransactions.map((txn) {
                    final type = txn['type'] ?? '';
                    final montant = txn['montant'] ?? 0;
                    final createdAt =
                        (txn['createdAt'] as Timestamp?)?.toDate();
                    final formattedDate =
                        createdAt != null
                            ? DateFormat('dd/MM/yyyy').format(createdAt)
                            : 'Date inconnue';
                    return ListTile(
                      leading: Icon(Icons.payment, color: Colors.deepOrange),
                      title: Text(
                        '$type - $montant FCFA',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(formattedDate),
                    );
                  }).toList(),
                  SizedBox(height: 10.h),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
