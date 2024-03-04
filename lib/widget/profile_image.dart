import 'package:flutter/material.dart';

String getInitials(String name) => name.isNotEmpty
    ? name.trim().split(RegExp(' +')).map((s) => s[0].toUpperCase()).take(2).join()
    : '';

class AnimatedProfileImage extends StatelessWidget{
  final String? name;

  const AnimatedProfileImage({super.key, required this.name});

  

  @override
  Widget build(BuildContext context) {
    final animation = NavigationRail.extendedAnimation(context);
    return AnimatedBuilder(animation: animation,  builder: (context, child)=> Container(height: 32, child: FloatingActionButton.extended(
      elevation: 0,

      label: Text(name ?? "Регистрация"),
      icon: name != null ? Text(getInitials(name!)) : Icon(Icons.login),
isExtended: animation.status != AnimationStatus.dismissed,
onPressed: (){},
    )));
  }
}