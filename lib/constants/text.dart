import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class ModifiedText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? size;
  final int? maxLine;
  final dynamic fontWeight;

  const ModifiedText(
      {Key? key, required this.text, this.color, this.size, this.maxLine, this.fontWeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLine,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
      ),
    );
  }
}
