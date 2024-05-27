import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tobeto_mobile_app/widgets/dropdown_widget.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
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
        child: Text('Değerlendirmeler'),
      ),
    );
  }
}
