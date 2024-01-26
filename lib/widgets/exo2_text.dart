import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Exo2Text extends StatelessWidget {
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextOverflow? overflow;

  const Exo2Text({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.textAlign = TextAlign.center,
    this.fontWeight = FontWeight.w400,
    this.fontSize = 18,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.exo2(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}
