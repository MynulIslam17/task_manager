import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/aseets_path.dart';

class ScreenBackground extends StatelessWidget {
  final Widget child;

  const ScreenBackground({
    super.key,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
      
        children: [
      
          SvgPicture.asset(AssetsPath.backgroundImage,
          width: double.maxFinite,
            height: double.maxFinite,
            fit: BoxFit.cover,
          ),
      
          child
      
      
      
      
        ],
      
      ),
    );
  }
}