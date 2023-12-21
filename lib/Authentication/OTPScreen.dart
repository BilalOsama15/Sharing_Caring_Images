import 'package:flutter/material.dart';

class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _code = TextEditingController();
  String _errorMessage = '';
  var _formkey=GlobalKey<FormState>();
  
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
                 validator: (value) {
                     if(value==null || value.isEmpty) {
                       return "Field Cannot be empty";
                      }
                      else if(value.length!=4)
                      {
                        return "Enter Accurate Code";
                      }
                      return null;
                  },
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
                onTap: (){
                   FocusScope.of(context).unfocus();
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
}