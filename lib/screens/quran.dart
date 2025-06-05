import 'package:flutter/material.dart';
import 'package:quran_library/quran_library.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {
  @override
  void initState() {
    QuranLibrary().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return QuranLibraryScreen(
      isDark: Theme.of(context).brightness == Brightness.dark,
      showAyahBookmarkedIcon: true,);
  }
}
