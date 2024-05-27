import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/widgets/dropdown_widget.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final Widget svg = SvgPicture.asset(
    'img/icons/tobeto_icon.svg',
    semanticsLabel: 'Acme Logo',
  );

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: SizedBox(width: 150, child: svg),
      ),
      endDrawer: DropDownMenu(),
      body: const Center(
        child: Text('Takvim'),
      ),
    );
  }
}
