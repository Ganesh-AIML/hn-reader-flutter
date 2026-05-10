import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'injection_container.dart' as di;
import 'injection_container.dart';
import 'presentation/cubits/stories/stories_cubit.dart';
import 'presentation/screens/home/home_screen.dart';

void main() {
  timeago.setLocaleMessages('en_short', timeago.EnShortMessages());
  di.init();
  runApp(const HNReaderApp());
}

class HNReaderApp extends StatelessWidget {
  const HNReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HN Reader',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Verdana',
        scaffoldBackgroundColor: const Color(0xFFF6F6EF),
      ),
      home: BlocProvider(
        create: (_) => sl<StoriesCubit>(),
        child: const HomeScreen(),
      ),
    );
  }
}