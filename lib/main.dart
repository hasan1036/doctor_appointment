import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/doctors_page.dart';
import 'pages/pregnancy_page.dart';

void main() => runApp(const HealthApp());

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF2F8FF),
      ),
      home: const HealthShell(),
    );
  }
}

class HealthShell extends StatefulWidget {
  const HealthShell({super.key});

  @override
  State<HealthShell> createState() => _HealthShellState();
}

class _HealthShellState extends State<HealthShell> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    LibraryPage(),
    DoctorsPage(),
    PregnancyPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: HealthBottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}

class HealthBottomNavBar extends StatelessWidget {
  const HealthBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  static const Color _indicatorBlue = Color(0xFF8FB7DE);
  static const Color _selectedBlueText = Color(0xFF5C86AF);
  static const Color _inactiveText = Color(0xFF7F8993);
  static const Color _pinkBackground = Color(0xFFFBE1EB);
  static const Color _pinkText = Color(0xFFD785A1);

  static const List<String> _labels = <String>[
    'Home',
    'Library',
    'Doctors',
    'Pregnancy',
  ];

  static const List<String> _icons = <String>[
    'assets/icons/home.png',
    'assets/icons/library.png',
    'assets/icons/doctors.png',
    'assets/icons/pregnancy.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        top: false,
        child: Container(
          height: 92,
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 16,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final tabWidth = constraints.maxWidth / 4;
              const indicatorWidth = 62.0;
              final indicatorLeft =
                  (selectedIndex * tabWidth) + ((tabWidth - indicatorWidth) / 2);

              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: List.generate(4, _buildTab),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    top: 0,
                    left: indicatorLeft,
                    child: Container(
                      width: indicatorWidth,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: _indicatorBlue,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final isSelected = selectedIndex == index;
    final isPregnancy = index == 3;
    final labelColor = isPregnancy
        ? _pinkText
        : (isSelected ? _selectedBlueText : _inactiveText);

    return Expanded(
      child: Semantics(
        button: true,
        selected: isSelected,
        label: _labels[index],
        child: Material(
          color: isPregnancy ? _pinkBackground : Colors.white,
          child: InkWell(
            onTap: () => onTap(index),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 43,
                    child: Center(
                      child: Image.asset(
                        _icons[index],
                        width: index == 3 ? 40 : 44,
                        height: 43,
                        fit: BoxFit.contain,
                        // Tint Home, Library and Doctors blue only when active.
                        // Pregnancy keeps its original pink icon in every state.
                        color: isPregnancy
                            ? null
                            : (isSelected ? _selectedBlueText : _inactiveText),
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          const [
                            Icons.home_outlined,
                            Icons.menu_book_outlined,
                            Icons.medical_services_outlined,
                            Icons.pregnant_woman_outlined,
                          ][index],
                          size: 33,
                          color: labelColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _labels[index],
                        maxLines: 1,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 14,
                          fontWeight:
                          isSelected ? FontWeight.w500 : FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
