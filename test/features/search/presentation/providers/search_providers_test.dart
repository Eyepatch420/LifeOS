import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifeos/features/search/presentation/providers/search_providers.dart';

void main() {
  ProviderContainer makeContainer() {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    return container;
  }

  test('empty query returns the full index (browse mode)', () {
    final container = makeContainer();
    final entities = container.read(searchableEntitiesProvider);
    final results = container.read(searchResultsProvider);

    expect(results, entities);
    expect(results, isNotEmpty);
  });

  test('the index includes a placeholder entry for each of the 4 tabs with '
      'no real searchable content yet', () {
    final container = makeContainer();
    final titles = container
        .read(searchableEntitiesProvider)
        .map((e) => e.title)
        .toSet();

    expect(titles, containsAll(['Health', 'Finance', 'Documents', 'Settings']));
  });

  test('a query filters case-insensitively by title/subtitle', () {
    final container = makeContainer();
    container.read(searchQueryProvider.notifier).setQuery('health');

    final results = container.read(searchResultsProvider);

    expect(results, isNotEmpty);
    expect(
      results.every(
        (e) =>
            e.title.toLowerCase().contains('health') ||
            e.subtitle.toLowerCase().contains('health'),
      ),
      isTrue,
    );
  });

  test('a query matching nothing returns an empty list', () {
    final container = makeContainer();
    container
        .read(searchQueryProvider.notifier)
        .setQuery('zzz_no_such_thing_zzz');

    expect(container.read(searchResultsProvider), isEmpty);
  });
}
