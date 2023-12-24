import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sharing_image/Authentication/OTPScreen.dart';

class phoneAuthentication extends StatefulWidget {
  const phoneAuthentication({super.key});

  @override
  State<phoneAuthentication> createState() => _phoneAuthenticationState();
}

class _phoneAuthenticationState extends State<phoneAuthentication> {
  final TextEditingController _phoneNumber = TextEditingController();
  String _errorMessage = '';
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 100,),
              const Text("Verification", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const Text("I will send you a One Time Password\non your Phone Number", textAlign: TextAlign.center, style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
              const SizedBox(height: 80),
              TextFormField(
                onChanged: (value) {
                  _validatePhoneNumber(value);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please Enter Mobile Number";
                  } else if (value.length != 10) {
                    return "Enter Accurate Number";
                  }
                  return null;
                },
                onTapOutside: (event) {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.phone,
                controller: _phoneNumber,
                maxLength: 10,
                decoration: InputDecoration(
                    prefixText: "+92 ",
                    labelText: "Enter Phone Number",
                    prefixIcon: const Icon(Icons.phone_android),
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
              const SizedBox(height: 10,),
              GestureDetector(
                onTap: () async{
                  FocusScope.of(context).unfocus();
                  await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: '+92 ${_phoneNumber.text}',
                  verificationCompleted: (PhoneAuthCredential credential) {
                    print("Verification Completed");
                    print(credential.smsCode);
                  },
                  verificationFailed: (FirebaseAuthException e) {
                    print("Verification Failed");
                    print(e.message);
                  },
                  codeSent: (String verificationId, int? resendToken) {
                   Future.delayed(Duration(milliseconds: 0), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTPScreen(verificationId: verificationId)),
                    );
                  });
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {},
                );
                 
                },
                child: Container(
                  height: 50, width: 330,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: Text("GET OTP", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validatePhoneNumber(String value) {
    RegExp regex = RegExp(r'^3[0-4]\d{0,8}$');
    if (value.isEmpty) {
      setState(() {
        _errorMessage = 'Please Enter Mobile Number';
      });
    } else if (regex.hasMatch(value.substring(0, 3))) {
      // Check if the first two digits are in the valid range (30, 31, 32, 33, 34)
      if (value.length == 10) {
        // Check if the length is 13 (including the "+92" prefix)
        setState(() {
          _errorMessage = ''; // No error
        });
      } else {
        setState(() {
          _errorMessage = 'Phone number must be 10 digits';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter a valid Pakistani phone number';
      });
    }
  }
}