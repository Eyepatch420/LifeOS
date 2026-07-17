import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lifeos/core/animations/presets.dart';
import 'package:lifeos/core/animations/shared_motion.dart';
import 'package:lifeos/core/constants/app_spacing.dart';
import 'package:lifeos/core/extensions/context_extensions.dart';
import 'package:lifeos/features/lists/domain/entities/list_item.dart';
import 'package:lifeos/features/lists/presentation/providers/lists_dashboard_provider.dart';
import 'package:lifeos/shared/widgets/buttons/primary_button.dart';
import 'package:lifeos/shared/widgets/feedback/empty_state.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_header.dart';
import 'package:lifeos/shared/widgets/layouts/pushed_screen_layout.dart';

class ListDetailScreen extends ConsumerStatefulWidget {
  const ListDetailScreen({required this.listId, super.key});

  final String listId;

  @override
  ConsumerState<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends ConsumerState<ListDetailScreen> {
  final _newItemController = TextEditingController();

  @override
  void dispose() {
    _newItemController.dispose();
    super.dispose();
  }

  Future<void> _addItem(TodoList list) async {
    final label = _newItemController.text.trim();
    if (label.isEmpty) return;
    _newItemController.clear();
    await ref
        .read(listsRepositoryProvider)
        .addItem(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          listId: list.id,
          label: label,
          sortOrder: list.items.length,
        );
  }

  Future<void> _archiveAndPop(String listId) async {
    await ref.read(listsRepositoryProvider).archiveList(listId, true);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(listsRepositoryProvider);

    return StreamBuilder<TodoList?>(
      stream: repository.watchById(widget.listId),
      builder: (context, snapshot) {
        final hasEmitted = snapshot.connectionState != ConnectionState.waiting;
        final list = snapshot.data;

        return PushedScreenLayout(
          header: PushedScreenHeader(title: list?.title ?? 'List'),
          content: list == null
              ? (!hasEmitted
                    ? const Center(child: CircularProgressIndicator())
                    : const EmptyState(
                        icon: Icons.checklist_outlined,
                        message: 'This list no longer exists',
                      ))
              : FadeSlideIn(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _newItemController,
                              decoration: const InputDecoration(
                                labelText: 'Add item',
                              ),
                              onSubmitted: (_) => _addItem(list),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => _addItem(list),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Expanded(
                        child: list.items.isEmpty
                            ? const EmptyState(
                                icon: Icons.checklist_outlined,
                                message: 'No items yet',
                              )
                            : ReorderableListView(
                                onReorderItem: (fromIndex, toIndex) {
                                  final items = [...list.items];
                                  final moved = items.removeAt(fromIndex);
                                  items.insert(toIndex, moved);
                                  ref
                                      .read(listsRepositoryProvider)
                                      .reorderItems([
                                        for (final item in items) item.id,
                                      ]);
                                },
                                children: [
                                  for (final item in list.items)
                                    _ListItemTile(
                                      key: ValueKey(item.id),
                                      item: item,
                                    ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
          ctaButton: list == null
              ? null
              : PrimaryButton(
                  label: 'Archive List',
                  onPressed: () => _archiveAndPop(list.id),
                ),
        );
      },
    );
  }
}

class _ListItemTile extends ConsumerWidget {
  const _ListItemTile({required this.item, super.key});

  final ListItemEntity item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey('dismiss-${item.id}'),
      direction: DismissDirection.endToStart,
      resizeDuration: AppMotionPresets.cardExit.duration,
      movementDuration: AppMotionPresets.cardExit.duration,
      onDismissed: (_) => ref.read(listsRepositoryProvider).deleteItem(item.id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Icon(
          Icons.delete_outline,
          color: context.colorScheme.onErrorContainer,
        ),
      ),
      child: CheckboxListTile(
        value: item.isDone,
        onChanged: (checked) => ref
            .read(listsRepositoryProvider)
            .setItemDone(item.id, checked ?? false),
        title: Text(
          item.label,
          style: item.isDone
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }
}
