import 'package:flutter/material.dart';

/// Shared presentation widgets; no extra third-party dependencies.
class HealthPalette {
  static const ink = Color(0xFF203449);
  static const muted = Color(0xFF73818C);
  static const blue = Color(0xFF5C86AF);
  static const softBlue = Color(0xFFE9F3FE);
  static const pink = Color(0xFFC67793);
  static const softPink = Color(0xFFFBE1EB);
}

class HealthPageScaffold extends StatelessWidget {
  const HealthPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.pinkHeader = false,
  });

  final String title;
  final String? subtitle;
  final List<Widget> children;
  final bool pinkHeader;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
        children: [
          Text(
            title,
            style: TextStyle(
              color: pinkHeader ? HealthPalette.pink : HealthPalette.ink,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              style: const TextStyle(
                color: HealthPalette.muted,
                fontSize: 15,
              ),
            ),
          ],
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }
}

class HealthInfoCard extends StatelessWidget {
  const HealthInfoCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.pink = false,
  });

  final String title;
  final String description;
  final IconData icon;
  final bool pink;

  @override
  Widget build(BuildContext context) {
    final accent = pink ? HealthPalette.pink : HealthPalette.blue;
    final soft = pink ? HealthPalette.softPink : HealthPalette.softBlue;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100D3555),
            blurRadius: 13,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: soft,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: accent, size: 25),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: HealthPalette.ink,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: const TextStyle(
                    color: HealthPalette.muted,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealthSectionTitle extends StatelessWidget {
  const HealthSectionTitle(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Text(
        text,
        style: const TextStyle(
          color: HealthPalette.ink,
          fontSize: 21,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
