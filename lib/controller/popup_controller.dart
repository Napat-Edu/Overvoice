import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupControl {
  void finishAlertDialog(context, int popCount) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/image/CorrectIcon.png"),
                const SizedBox(height: 12),
                Text(
                  'เสร็จสิ้น',
                  style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 12),
                Text(
                  'ขอบคุณสำหรับการพากย์เสียงของคุณ',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.prompt(fontSize: 15),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFFF7200),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    int count = 0;
                    Navigator.popUntil(context, ((route) {
                      return count++ == popCount;
                    }));
                  },
                  child: const Text('ตกลง'),
                ),
              ],
            ),
          ),
        ),
      );
}
