// import 'package:flutter/Material.dart';

// class LoginScreen extends StatelessWidget {
//   final _phoneController = TextEditingController();
//   final _passController = TextEditingController();
//   //Place A
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//           padding: EdgeInsets.all(32),
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

//                 SizedBox(height: 16,),

//                 TextFormField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[200])
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[300])
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       hintText: "Phone Number"

//                   ),
//                   controller: _phoneController,
//                 ),

//                 SizedBox(height: 16,),

//                 TextFormField(
//                   decoration: InputDecoration(
//                       enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[200])
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(8)),
//                           borderSide: BorderSide(color: Colors.grey[300])
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey[100],
//                       hintText: "Password"

//                   ),

//                   controller: _passController,
//                 ),

//                 SizedBox(height: 16,),

//                 Container(
//                   width: double.infinity,
//                   child: FlatButton(
//                     child: Text("Login"),
//                     textColor: Colors.white,
//                     padding: EdgeInsets.all(16),
//                     onPressed: (){
//                         //code for sign in
//                         Place B
//                     },
//                     color: Colors.blue,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//     );
//   }
// }