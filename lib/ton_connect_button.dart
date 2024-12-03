import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class TonConnectButton extends StatelessWidget {
  TextStyle? textStyle;
  final String label;
  double? iconSize;

  TonConnectButton(
      {this.textStyle, this.label = 'Connect TON', this.iconSize, super.key});

  @override
  Widget build(BuildContext context) {
    textStyle ??= Theme.of(context).textTheme.bodyMedium?.apply(color: Colors.white);
    iconSize ??= 16;

    final Widget svg = SvgPicture.asset(
      'assets/images/ton_icon.svg',
      height: iconSize,
      width: iconSize,
      package: 'flutter_ton_buttons'
    );
    return Container(
        decoration: const BoxDecoration(
            color: Color.fromRGBO(36, 139, 218, 1),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        padding: const EdgeInsets.all(8),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          svg,
          Container(
              margin: const EdgeInsets.only(left: 4),
              child: Text(
                label,
                style: textStyle,
              ))
        ]));
  }
}
