import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sugu/api/mobile_money_service.dart';
import 'package:sugu/routes.dart';

class PayementView extends StatefulWidget {
  final int amount;
  const PayementView({super.key, required this.amount});

  @override
  State<PayementView> createState() => _PayementViewState();
}

class _PayementViewState extends State<PayementView> {
  // Instances des services de paiement
  OrangeMoneyService _orangeApi = OrangeMoneyService();
  MobiCashService _mobicashApi = MobiCashService();

  bool isLoading = false; // Pour afficher un loader pendant un paiement
  final TextEditingController _amountController =
      TextEditingController(); // Champ montant
  String selectedMethod = 'Orange Money'; // Méthode de paiement par défaut

  // Initialisation
  @override
  void initState() {
    super.initState();
    _amountController.text =
        widget.amount.toString(); // Remplit le montant automatiquement
  }

  // Fonction principale de paiement
  void _pay() async {
    String amount = _amountController.text.trim();
    final user = FirebaseAuth.instance.currentUser;
    Fluttertoast.showToast(
      msg: "Paiement de $amount FCFA via $selectedMethod en cours...",
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_LONG,
    );

    // Paiement selon la méthode choisie
    if (selectedMethod == 'Orange Money') {
      await _orangeApi.payer(amount: widget.amount, orderId: user!.uid);
      activerAbonnement(); // Active l’abonnement
    } else if (selectedMethod == "MobiCash") {
      await _mobicashApi.payer(amount: widget.amount, orderId: user!.uid);
      activerAbonnement();
    }
  }

  // Fonction pour activer un abonnement premium pendant 90 jours
  Future<void> activerAbonnement() async {
    setState(() => isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      final finAbonnement = DateTime.now().add(Duration(days: 90));

      // ⚠️ À décommenter si tu veux enregistrer dans Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
            'isPremium': true,
            'subscriptionUntil': finAbonnement.toIso8601String(),
            'startTrial': DateTime.now().toIso8601String(),
          });
      // enregistrer la trace de la trasanction
      await FirebaseFirestore.instance.collection('transactions').add({
        'type': 'abonnement', // ou 'boost'
        'montant': widget.amount, // ou 100
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Abonnement activé jusqu’au ${finAbonnement.day}/${finAbonnement.month}/${finAbonnement.year}",
          ),
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyRoots()),
        (route) => false,
      );
    } catch (e) {
      print("Erreur abonnement : $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erreur : $e")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          color: Colors.white,
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
                    "Payement",
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 16.r),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Activer votre abonnement",
                        style: GoogleFonts.poppins(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "✅ Créez un nombre illimité d'annonces sur 3mois\n"
                        "✅ Accès à des statistiques : nombres de vues\n",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Text(
                        "Choisissez une méthode de paiement",
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      DropdownButtonFormField<String>(
                        isDense: false,
                        dropdownColor: Colors.white,
                        value: selectedMethod,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items:
                            ['Orange Money', 'MobiCash'].map((method) {
                              return DropdownMenuItem(
                                value: method,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      method == "Orange Money"
                                          ? "assets/logos/orange.jpg"
                                          : "assets/logos/moov.webp",
                                      width: 30.w,
                                      height: 30.h,
                                      fit: BoxFit.contain,
                                    ),
                                    SizedBox(width: 20.w),
                                    Text(
                                      method,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedMethod = val!;
                          });
                        },
                      ),
                      SizedBox(height: 12.h),
                      TextField(
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: "Montant (FCFA)",
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(
                            Icons.money,
                            size: 20.sp,
                            color: Colors.black,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20.h),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                            onPressed: _pay,
                            icon: Icon(Icons.payment, color: Colors.white),
                            label: Text(
                              "Payer",
                              style: GoogleFonts.poppins(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(50),
                              ),
                              minimumSize: Size(400.w, 40.h),
                              backgroundColor: Colors.deepOrange,
                              padding: EdgeInsets.symmetric(
                                horizontal: 30.r,
                                vertical: 12.r,
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
      ),
    );
  }
}
