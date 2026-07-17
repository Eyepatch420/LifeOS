import 'package:freezed_annotation/freezed_annotation.dart';

part 'lists_summary.freezed.dart';

/// One entry in the Lists feature's dashboard summary — deliberately
/// narrower than [TodoList] (no item detail, just aggregate progress)
/// since Home only ever renders a progress-ring tile. Home imports this
/// only; it never imports [TodoList] or `ListsRepository` — see
/// `docs/architecture_principles.md`'s Architecture Constraint 1.
@freezed
abstract class ListEntrySummary with _$ListEntrySummary {
  const factory ListEntrySummary({
    required String id,
    required String title,
    required String subtitle,
    required double progress,
  }) = _ListEntrySummary;
}

/// The Lists feature's full dashboard contribution — Home watches
/// `listsDashboardProvider` (which resolves to this) instead of the
/// feature's repository or entity.
@freezed
abstract class ListsSummary with _$ListsSummary {
  const factory ListsSummary({required List<ListEntrySummary> lists}) =
      _ListsSummary;
}
