import 'package:flutter/material.dart';

/// A section's builder closure. Kept entirely separate from
/// [HomeSectionMeta] (see `home_section_registry.dart`) — builders need a
/// live `WidgetRef` to watch each section's `AsyncNotifier`, which only
/// exists inside `HomeScreen`'s own `build(context, ref)`, whereas
/// [HomeSectionMeta] is plain, serializable-shaped data owned by a
/// `Notifier` (which only has a `Ref`, not a `WidgetRef` — the two aren't
/// interchangeable in Riverpod). Splitting them this way means
/// `homeSectionsProvider`'s state never holds a widget-construction
/// closure, keeping it trivial to test and, later, to persist.
typedef HomeSectionBuilder = Widget Function(BuildContext context);

/// Describes one Home dashboard section's position, visibility, and
/// display metadata — everything a future Settings screen needs to render
/// its entire section-toggle checklist directly from this registry with
/// zero duplicated metadata.
///
/// Deliberately richer than today's rendering needs (`order`/`visible` are
/// the only fields actually consumed by layout today) — `analyticsName`
/// and `supportsCustomization` exist now so adding analytics or Settings
/// support later never requires touching every section's config.
@immutable
class HomeSectionMeta {
  const HomeSectionMeta({
    required this.id,
    required this.order,
    required this.visible,
    required this.displayName,
    required this.icon,
    this.supportsCustomization = true,
    this.analyticsName,
  });

  /// Stable key — used to look up this section's builder (see
  /// `home_section_registry.dart`) and by any future analytics/deep-link
  /// targeting.
  final String id;

  /// Render position. Sections are sorted by this value before rendering.
  final int order;

  /// Per-section on/off — folded directly into this object instead of a
  /// separate `Map<String, bool>`, so one object is the complete answer to
  /// "what is this section, is it on, where does it sit."
  final bool visible;

  /// Whether a future Settings screen should render a visibility/order
  /// toggle for this section at all. `false` for sections that should
  /// never be hideable/reorderable even once Settings exists.
  final bool supportsCustomization;

  /// Reserved for a future analytics/telemetry event name distinct from
  /// [id] (e.g. `id: 'upNextAndHabits'` but
  /// `analyticsName: 'home_up_next_habits_section'`). `null` everywhere in
  /// this pass since no analytics pipeline exists yet.
  final String? analyticsName;

  /// What a future Settings screen's checklist row would show.
  final String displayName;
  final IconData icon;

  HomeSectionMeta copyWith({int? order, bool? visible}) => HomeSectionMeta(
    id: id,
    order: order ?? this.order,
    visible: visible ?? this.visible,
    displayName: displayName,
    icon: icon,
    supportsCustomization: supportsCustomization,
    analyticsName: analyticsName,
  );
}
