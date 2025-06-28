import 'dart:convert';
import 'dart:math' as math;

import 'package:busapp/models/user_model.dart';
import 'package:busapp/services_screens/complaint.dart';
import 'package:busapp/services_screens/payment_screens/payment_ammount.dart';
import 'package:busapp/services_screens/tickets_screen.dart';
import 'package:busapp/shared/network/local_network.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userModel;
  int points = 0;
  int tickets = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  
  Future<void> _loadUserData() async {
    try {
      // 1. Load from SharedPreferences first
      final prefs = await SharedPreferences.getInstance();
      final sharedBalance = prefs.getDouble('balance')?.toInt() ?? 0;
      
      // 2. Load from cached user data
      final userData = CashNetwork.getCacheData(key: 'user_data');
      UserModel? cachedUser;
      int cachedPoints = 0;
      
      if (userData.isNotEmpty) {
        try {
          cachedUser = UserModel.fromJson(json.decode(userData));
          cachedPoints = cachedUser.balance.points;
        } catch (e) {
          print('Error parsing user data: $e');
        }
      }
      
      // 3. Use the highest available value
      final newPoints = math.max(sharedBalance, cachedPoints);
      
      setState(() {
        points = newPoints;
        userModel = cachedUser;
        
        if (userModel != null) {
          userModel = userModel!.copyWith(
            balance: userModel!.balance.copyWith(points: newPoints)
          );
        }
      });
      
      // Sync all data sources
      if (sharedBalance < newPoints) {
        await prefs.setDouble('balance', newPoints.toDouble());
      }
      if (cachedUser?.balance.points != newPoints) {
        await CashNetwork.saveCacheData(
          key: 'user_data',
          value: json.encode(userModel?.toJson()),
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor:  Color.fromARGB(255, 15, 90, 95),
        surfaceTintColor:  Color.fromARGB(255, 15, 90, 95),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logoWhite.png',
              width: 192,
              height: 50,
              fit: BoxFit.contain,
            ),
          ],
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.8),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        toolbarHeight: 80,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                Padding(
                padding: const EdgeInsets.all(16),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://th.bing.com/th/id/OIP.lvzPu-WOW4Iv7QyjP-IkrgHaHa?rs=1&pid=ImgDetMain',
                      ),
                    ),
                    Positioned(
                      width: 40,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:  Color.fromARGB(255, 15, 90, 95),
                            width: 4,
                          ),
                        ),
                        child: IconButton(onPressed: (){}, icon: Icon(
                          Icons.edit,
                          color:  Color.fromARGB(255, 15, 90, 95),
                          size: 16,
                        ),)
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                SizedBox(height: 50,),
              Text(
                'kholoud',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'user@user.com',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 26,),
                SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF0A6A6A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Edit Profile',style: TextStyle(color: Colors.white)),
                ),
              ),          
                ],
              ),
                ],
              ),
                SizedBox(height: 26),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildStatCard(points.toString(), 'Points'),
                    SizedBox(height: 20),
                    _buildMenuOption(
                      icon: Icons.monetization_on,
                      iconColor: Colors.amber,
                      iconBgColor: Color(0xFFFFF8E1),
                      title: 'Charge My points',
                      onPressed: () async {
                        final result = await Navigator.push<double>(
                          context,
                          MaterialPageRoute(builder: (context) => PaymentAmount()),
                        );
                        
                        if (result != null) {
                          await _loadUserData(); // Refresh data after returning
                        }
                      },
                    ),
                    _buildMenuOption(
                      icon: Icons.confirmation_number_outlined,
                      iconColor: Colors.blue,
                      iconBgColor: Color(0xFFE3F2FD),
                      title: 'View Tickets',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TicketsScreen()),
                        );
                    },
                    ),
                    _buildMenuOption(
                      icon: Icons.error_outline,
                      iconColor: Colors.red,
                      iconBgColor: Color(0xFFFFEBEE),
                      title: 'Make a complaint',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ComplaintSrc()),
                        );
                      },
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {}, 
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, 
                          foregroundColor: Colors.black,
                          elevation: 0, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                              color: Colors.red, 
                              width: 2.0, 
                            ),
                          ),
                          padding: EdgeInsets.all(0), 
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout, color: Colors.red),
                              SizedBox(width: 10),
                              Text(
                                'Log out',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            points.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required VoidCallback onPressed, 
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, 
          foregroundColor: Colors.black,
          elevation: 0, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(0), 
        ),
        onPressed: onPressed, 
        child: ListTile(
          leading: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          title: Text(title),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
        ),
      ),
    );
  }
}