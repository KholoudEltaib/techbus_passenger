import 'package:busapp/navbarscreens/home_screen.dart';
import 'package:busapp/navbarscreens/main_scr.dart';
import 'package:busapp/shared/constants/constants.dart';
import 'package:busapp/shared/network/local_network.dart';
import 'package:busapp/signin_signup_screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CashNetwork.cashInitialization();
  token = CashNetwork.getCacheData(key: 'token');
  cons_points = int.tryParse(CashNetwork.getCacheData(key: 'points'));
  print("token is:  $token");
  print("points is:  $cons_points");
  runApp(const TechBusApp());
}

class TechBusApp extends StatelessWidget {
  const TechBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: HomeScreenMap());
        home: token != null && token != "" ? MainScreen() : LoginScreen());
  }
}























// {
//   data: [
//     { id: 1,
//       name: Route 26,
//       number: 26,
//       estimated_time: 112-117 min,
//       stations: [
//         {name: بيجام,lat: 30.14044,long: 31.24464},
//         {name: شبرا الخيمه, lat: 30.12679, long: 31.2599},
//         {name: الشارع الجديد, lat: 30.13152, long: 31.28723},
//         {name: مسطرد, lat: 30.14464, long: 31.28608},
//         {name: المطرية, lat: 30.1291, long: 31.31864},
//         {name: الحلمية, lat: 30.03746, long: 31.25213},
//         {name: التجنيد, lat: 30.11027, long: 31.32496},
//         {name: المحكمة, lat: 30.10413, long: 31.33037},
//         {name: سفير, lat: 30.0991, long: 31.33976},
//         {name: نادي الجلاء, lat: 30.09755, long: 31.34878},
//         {name: السبع عمارات, lat: 30.08973, long: 31.34218},
//         {name: اول عباس, lat: 30.06728, long: 31.33914},
//         {name: اول مكرم, lat: 30.06959, long: 31.34401},
//         {name: معهد الخدمة الاجتماعية, lat: 30.06818, long: 31.35268},
//         {name: النادي الاهلي, lat: 30.07066, long: 31.35578},
//         {name: مساكن الشروق, lat: 30.06901, long: 31.36004}
//       ]
//     }
//   ]
// }