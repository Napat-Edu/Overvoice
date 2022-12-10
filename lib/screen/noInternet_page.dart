import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/constant_value.dart';

class NoInternet extends StatefulWidget {
  const NoInternet({super.key});

  @override
  State<NoInternet> createState() => _NoInternetState();
}

class _NoInternetState extends State<NoInternet> {
  ConstantValue constantValue = ConstantValue();
  @override
  Widget build(BuildContext context) {

    // core UI
    return Material(
      child: Container(
        height: constantValue.getScreenHeight(context),
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.wifi_off,
                  size: constantValue.getScreenWidth(context) / 2.5,
                  color: Colors.black38,
                ),
              ),
              Container(
                child: Text(
                  "โอ้ไม่นะ",
                  style: GoogleFonts.prompt(
                      fontSize: 29,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: constantValue.getScreenWidth(context) / 7, right: constantValue.getScreenWidth(context) / 7, top: 15),
                child: Text(
                  "คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต\nโปรดเชื่อมต่อแล้วกลับมาใหม่นะ",
                  style: GoogleFonts.prompt(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                child: SizedBox(
                  width: constantValue.getScreenWidth(context) / 2,
                  height: constantValue.getScreenHeight(context) / 20,
                  child: Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: const Color(0xFFFF7200),
                          foregroundColor: Colors.white,
                          textStyle: GoogleFonts.prompt(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const NoInternet()));
                      },
                      child: const Text("ลองอีกครั้ง"),
                    ),
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
