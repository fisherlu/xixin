import "package:flutter/material.dart";
import "../../shared/models/meditation.dart";
import "../../shared/widgets/meditation_card.dart";
import "../../core/router/app_router.dart";

class MeditationListPage extends StatelessWidget {
  final String category;
  const MeditationListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final filtered = category.isEmpty
        ? MeditationLibrary.meditations
        : MeditationLibrary.meditations.where((m) => m.category.name == category).toList();

    return Scaffold(
      appBar: AppBar(title: Text(_categoryTitle(category))),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        itemCount: filtered.length,
        itemBuilder: (_, i) => MeditationCard(
          meditation: filtered[i],
          onTap: () => Navigator.pushNamed(context, AppRouter.meditationPlayer, arguments: filtered[i]),
        ),
      ),
    );
  }

  String _categoryTitle(String cat) {
    switch (cat) {
      case "morning": return "晨间冥想";
      case "stress": return "减压冥想";
      case "focus": return "专注冥想";
      case "sleep": return "睡眠冥想";
      case "compassion": return "慈悲冥想";
      case "body": return "身体扫描";
      default: return "全部冥想";
    }
  }
}
