import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/config/router/route_paths.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/lists/domain/entities/list_item.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/indicators/animated_streak_ring.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

class ListsScreen extends ConsumerStatefulWidget {
  const ListsScreen({super.key});

  @override
  ConsumerState<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends ConsumerState<ListsScreen> {
  Future<void> _createList() async {
    final titleController = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New List'),
        content: TextField(
          controller: titleController,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pop(titleController.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (title == null || title.isEmpty) return;

    await ref
        .read(listsRepositoryProvider)
        .createList(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          title: title,
          kind: 'checklist',
        );
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(listsRepositoryProvider);
    return PushedScreenLayout(
      header: Row(
        children: [
          const Expanded(child: PushedScreenHeader(title: 'My Lists')),
          IconButton(icon: const Icon(Icons.add), onPressed: _createList),
        ],
      ),
      content: StreamBuilder<List<TodoList>>(
        stream: repository.watchAll(),
        builder: (context, snapshot) {
          final lists = snapshot.data;
          if (lists == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (lists.isEmpty) {
            return const EmptyState(
              icon: Icons.checklist_outlined,
              message: 'No lists yet',
            );
          }
          return StaggeredEntrance(
            children: [for (final list in lists) _ListTile(list: list)],
          );
        },
      ),
    );
  }
}

class _ListTile extends StatelessWidget {
  const _ListTile({required this.list});

  final TodoList list;

  @override
  Widget build(BuildContext context) {
    final done = list.items.where((i) => i.isDone).length;
    final total = list.items.length;
    final progress = total == 0 ? 0.0 : done / total;
    final accent = context.colorScheme.primary;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
        horizontal: 0,
      ),
      leading: Icon(Icons.checklist_outlined, color: accent),
      title: Text(list.title),
      subtitle: Text(total == 0 ? 'No items yet' : '$done/$total done'),
      trailing: AnimatedStreakRing(
        progress: progress,
        label: '${(progress * 100).round()}%',
        color: accent,
      ),
      onTap: () => context.pushNamed(
        RouteNames.listDetail,
        pathParameters: {'listId': list.id},
      ),
    );
  }
}
