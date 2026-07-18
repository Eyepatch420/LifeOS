import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/durations.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/search/domain/models/searchable_entity.dart';
import 'package:lifeos/features/search/domain/search_hero_tags.dart';
import 'package:lifeos/features/search/presentation/providers/search_providers.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

/// Real search screen (replaces the Phase 1 stub): a `Hero`-tagged,
/// auto-focused search bar morphing from the Home hero's search icon (see
/// `HomeHeroSection`), and a filtered result list backed by
/// `searchResultsProvider`.
class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  void _onResultTap(BuildContext context, WidgetRef ref, SearchableEntity e) {
    switch (e.category) {
      case SearchableEntityCategory.home:
      case SearchableEntityCategory.remindersTab:
      case SearchableEntityCategory.health:
      case SearchableEntityCategory.finance:
      case SearchableEntityCategory.documents:
      case SearchableEntityCategory.settings:
        context.goNamed(e.routeName);
      case SearchableEntityCategory.note:
      case SearchableEntityCategory.list:
      case SearchableEntityCategory.upNext:
      case SearchableEntityCategory.reminder:
        // No detail screen exists yet for these categories — pop back to
        // Home, where the matching section is already visible.
        context.pop();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final results = ref.watch(searchResultsProvider);

    return PushedScreenLayout(
      header: Hero(
        tag: searchMorphHeroTag,
        child: Material(
          color: Colors.transparent,
          child: Row(
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: TextField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onChanged: (value) =>
                      ref.read(searchQueryProvider.notifier).setQuery(value),
                ),
              ),
            ],
          ),
        ),
      ),
      content: AnimatedSwitcher(
        duration: AppDurations.medium,
        child: results.isEmpty
            ? const EmptyState(
                key: ValueKey('empty'),
                icon: Icons.search_off,
                message: 'No results',
              )
            : ListView.separated(
                key: const ValueKey('results'),
                itemCount: results.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final entity = results[index];
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      entity.icon,
                      color: context.colorScheme.primary,
                    ),
                    title: Text(entity.title),
                    subtitle: Text(entity.subtitle),
                    onTap: () => _onResultTap(context, ref, entity),
                  );
                },
              ),
      ),
    );
  }
}
