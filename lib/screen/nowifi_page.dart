import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NoWifi extends StatefulWidget {
  const NoWifi({super.key});

  @override
  State<NoWifi> createState() => _NoWifiState();
}

class _NoWifiState extends State<NoWifi> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Material(
      child: Container(
        height: screenHeight,
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Icon(
                  Icons.wifi_off,
                  size: screenWidth / 2.5,
                  color: Colors.black38,
                ),
              ),
              Container(
                child: Text(
                  "โอ้ไม่นะ",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black45),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: screenWidth / 7, right: screenWidth / 7, top: 15),
                child: Text(
                  "คุณไม่ได้เชื่อมต่ออินเทอร์เน็ต\nโปรดเชื่อมต่อแล้วกลับมาใหม่นะ",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black38),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    width: screenWidth / 2,
                    height: screenHeight / 20,
                    child: Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: const Color(0xFFFF7200),
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NoWifi()));
                        },
                        child: Text("ลองอีกครั้ง"),
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
