// import 'package:flutter/material.dart';
// import 'package:sth/pages/fancy_settings.dart';
// import 'package:sth/pages/feedback.dart';
// import 'package:sth/utils/consts.dart';

// class DrawerWidget extends StatelessWidget{
//   @override
//   Widget build(BuildContext context) {
    
//     return Container(
//       width: MediaQuery.of(context).size.width - 80,
//       color: Colors.red,
//       child: SafeArea(
//         child: Container(
//           color: Consts.DRAWER_COLOR,
//           child: Column(
//             children: <Widget>[
//               SizedBox(
//                 height: 200,
//                 child: Container(
//                   decoration: BoxDecoration(
//                       //color: Colors.grey[100],
//                       borderRadius: BorderRadius.only(
//                           bottomLeft: Radius.circular(10),
//                           bottomRight: Radius.circular(10))),
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minWidth: double.infinity,
//                       minHeight: double.infinity,
//                     ),
//                     child: Image.asset(
//                       "assets/images/logo.jpg",
//                     ),
//                   ),
//                   // child: Center(
//                   //   child: Text(
//                   //     Consts.APP_NAME,
//                   //     style: TextStyle(
//                   //         fontSize: 24,
//                   //         fontWeight: FontWeight.bold,
//                   //         color: Colors.redAccent),
//                   //   ),
//                   // ),
//                 ),
//               ),
//               Divider(),
//               drawerTile(
//                 icon: Icons.vpn_lock,
//                 title: Consts.LOGIN,
//               ),
//               drawerTile(icon: Icons.create, title: Consts.CREATE_ACCOUNT),
//               drawerTile(
//                   icon: Icons.feedback,
//                   title: Consts.FEEDBACK,
//                   page: FeedbackPage()),
//               drawerTile(
//                   icon: Icons.settings,
//                   title: Consts.SETTINGS,
//                   page: FancySettingsPage(
//                     totalSports: _allSports,
//                     callbackRemoveTabs: _addRemoveTabs,
//                     callbackClearTabs: _removeAllTabs,
//                   )),
//               drawerTile(icon: Icons.info, title: Consts.ABOUT),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }