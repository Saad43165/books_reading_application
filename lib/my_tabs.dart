import 'package:flutter/material.dart';

class AppTabs extends StatelessWidget {
  final Color color;
  final String text;
  const AppTabs({super.key,required this.color,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      width: 120,
      decoration: BoxDecoration(
          color: this.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.2),
              blurRadius: 7,
              offset: const Offset(0,0),
            )
          ]
      ),
      child: Text(this.text,style: TextStyle(color: Colors.white,fontSize: 18),),
    );
  }
}
