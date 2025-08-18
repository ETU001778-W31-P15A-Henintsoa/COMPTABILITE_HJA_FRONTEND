import 'package:flutter/material.dart';

class Images {

  static Widget getLogo({double size = 200}) {
    return Image.asset(
      './lib/pages/assets/img/logo.png',
      width: size,
      height: size,
        fit: BoxFit.contain,
    );
  }

}

