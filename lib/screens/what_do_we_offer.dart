import 'package:flutter/material.dart';

import '../widgets/dropdown_widget.dart';

class NelerSunuyoruzPage extends StatelessWidget {
  const NelerSunuyoruzPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neler Sunuyoruz?'),
      ),
      endDrawer:  DropDownMenu(),
      body: const Center(
        child: Text(
          'Neler Sunuyoruz? Sayfası',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
