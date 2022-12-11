import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/screen/moreInfo_page.dart';

class TitleCardList extends StatelessWidget {
  TitleCardList({
    super.key,
    required this.imgURL,
    required this.titleName,
    required this.voiceoverAmount,
    required this.episode,
    required this.docID,
  });

  String imgURL;
  String titleName;
  String voiceoverAmount;
  String episode;
  String docID;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 52,
          height: 52,
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
            ]),
            child: Image.network(
              imgURL,
              fit: BoxFit.cover,
            ),
          )),
      title: 
          Text(
            voiceoverAmount == '1' ? "$titleName (เดี่ยว)":"$titleName (คู่)",
            style: GoogleFonts.prompt(
                color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17),
          ),
      subtitle: Text(
        episode,
        style: GoogleFonts.prompt(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: TextButton(
        style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFF7200),
            foregroundColor: Colors.white,
            textStyle: GoogleFonts.prompt(
              fontSize: 14,
            )),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreInfo(docID),
                fullscreenDialog: true,
              ));
        },
        child: const Text('เข้าชม'),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MoreInfo(docID),
              fullscreenDialog: true,
            ));
      },
    );
  }
}
