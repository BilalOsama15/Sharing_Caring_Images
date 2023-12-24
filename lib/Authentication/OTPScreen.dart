import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharing_image/AddGroup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OTPScreen extends StatefulWidget {
    String verificationId = "";
   OTPScreen({required this.verificationId, super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _code = TextEditingController();
  String _errorMessage = '';
  var _formkey=GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png',height: 100,),
            const  Text("Verification", style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            const  Text("You will get a OTP via SMS",textAlign: TextAlign.center, style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),
            const  SizedBox(height: 80,),
              TextFormField(
                
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.number,
                controller: _code,
                decoration: InputDecoration(
                  labelText: "Enter Verification Code",
                  prefixIcon: const Icon(Icons.domain_verification),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  )
                ),
              ),
               SizedBox(height: 5),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
              const  SizedBox(height: 10,),
              GestureDetector(
                onTap: ()async{
                   FocusScope.of(context).unfocus();
                   try{
                    print(widget.verificationId);
                     PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: widget.verificationId, smsCode: _code.text.toString());

                    // Sign the user in (or link) with the credential
                    await auth.signInWithCredential(credential).then((value) => {
                      saveUserData(value.user!),
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()))
                    });

                   }catch(e)
                   {
                    print("Exception");
                    print(e);
                   }
                  
                },
                child: Container(
                  height: 50,width: 330,
                  alignment: Alignment.center,
                 decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text("VERIFY", style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.bold),),
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
  void saveUserData(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save user data to SharedPreferences
    prefs.setString('userUid', user.uid);
    prefs.setString('userPhoneNumber', user.phoneNumber ?? '');
    // Add more user data as needed

    print('User data saved to SharedPreferences');
  }
}