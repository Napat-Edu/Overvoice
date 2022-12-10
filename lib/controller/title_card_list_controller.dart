import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overvoice_project/screen/moreInfo_page.dart';

class TitleCardList extends StatelessWidget {
  TitleCardList({
    super.key,
    required this.imgURL,
    required this.titleName,
    required this.episode,
    required this.docID,
  });

  String imgURL;
  String titleName;
  String episode;
  String docID;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
          width: 53,
          height: 53,
          child: Container(
            decoration: const BoxDecoration(boxShadow: [
              BoxShadow(color: Color(0xFFFFAA66), blurRadius: 5)
            ]),
            child: Image.network(
              imgURL,
              fit: BoxFit.cover,
            ),
          )),
      title: Text(
        titleName,
        style: GoogleFonts.prompt(
            color: Colors.black, fontWeight: FontWeight.w600, fontSize: 17),
      ),
      subtitle: Text(
        episode,
        style: GoogleFonts.prompt(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      trailing: TextButton(
        style: TextButton.styleFrom(
            fixedSize: const Size(10, 10),
            backgroundColor: const Color(0xFFFF7200),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 15,
            )),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MoreInfo(docID),
                fullscreenDialog: true,
              ));
        },
        child: Text('เข้าชม', style: GoogleFonts.prompt()),
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
