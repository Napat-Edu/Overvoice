import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupControl {
  Future<dynamic> finishAlertDialog(context, int popCount) {
    return showDialog(
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
                  Navigator.popUntil(
                    context,
                    ((route) {
                      return count++ == popCount;
                    }),
                  );
                },
                child: const Text('ตกลง'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> howToDubDialog(context) {
    return showDialog(
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
              const SizedBox(height: 12),
              Text(
                'วิธีการพากย์เสียง',
                style: GoogleFonts.prompt(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
               Text(
                'สามารถอ่านประโยคทั้งหมด ก่อนที่คุณจะเริ่มพากย์ได้\n\n'
                '1.คุณจะได้พากย์ทีละประโยค\n'
                '2.แต่ละประโยคจะมีเวลาจำกัด\n'
                '3.เมื่อคุณกดปุ่มเริ่มพากย์ ถือว่าเริ่มประโยคแรกทันที\n'
                '4.เมื่อมีสัญญาณดังขึ้นมาหนึ่งครั้ง ถือว่าเริ่มพากย์ได้\n'
                '5.เมื่อได้ยินสัญญาณอีกหนึ่งครั้ง ถือว่าหมดเวลา\n'
                '6.จากนั้นวนรอบไปเรื่อยๆ จนครบทุกประโยค\n'
                '7.เมื่อครบทุกประโยค และกดปุ่มเสร็จสิ้น เสียงของคุณจะถูกอัพโหลด\n\n'
                'คุณไม่สามารถย้อนกลับไปพากย์ประโยคที่ผ่านมาได้ หากต้องการ ต้องเริ่มต้นพากย์ใหม่เท่านั้น\n'
                'คุณไม่จำเป็นต้องพากย์บทของคู่คุณ แต่เราอนุญาติให้คุณพากย์เสริมระหว่างนั้นได้\n',
                textAlign: TextAlign.left,
                style: GoogleFonts.prompt(fontSize: 14),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7200),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('เข้าใจแล้ว'),
              ),
            ],
          ),
        ),
      ),
    ); 
  }
}
