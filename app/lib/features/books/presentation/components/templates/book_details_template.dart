import 'package:flutter/material.dart';
import 'package:gatuno/core/theme/theme.dart';

class BookDetailsTemplate extends StatelessWidget {
  final Widget? appBar;
  final Widget cover;
  final Widget header;
  final Widget actionButtons;
  final Widget tags;
  final Widget description;
  final Widget chapterList;

  const BookDetailsTemplate({
    super.key,
    this.appBar,
    required this.cover,
    required this.header,
    required this.actionButtons,
    required this.tags,
    required this.description,
    required this.chapterList,
  });

  @override
  Widget build(BuildContext context) {
    final gatunoColors = Theme.of(context).extension<GatunoColors>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar != null
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: appBar!,
            )
          : null,
      body: Container(
        decoration: BoxDecoration(gradient: gatunoColors?.degrader),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Column(
                    children: [
                      Center(child: cover),
                      const SizedBox(height: 32),
                      header,
                      const SizedBox(height: 24),
                      actionButtons,
                      const SizedBox(height: 24),
                      tags,
                      const SizedBox(height: 24),
                      description,
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
            chapterList,
          ],
        ),
      ),
    );
  }
}
