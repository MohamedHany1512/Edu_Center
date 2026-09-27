import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final IconData icon;

  const CustomListTile({
    super.key,
    required this.text,
    this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, size: 20, color: Colors.blueAccent),
      title: Text(text, style: TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 20,
        color: Colors.amberAccent,
      ),
    );
  }
}
