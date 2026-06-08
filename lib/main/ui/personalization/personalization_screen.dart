import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:majadigi_mobile_rebuild/main/core/providers/category/category_providers.dart';
import 'package:majadigi_mobile_rebuild/main/domain/entities/category/category_entity.dart';

class PersonalizationScreen extends HookConsumerWidget {
  const PersonalizationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // State to hold the IDs of selected categories
    final selectedItems = useState<Set<String>>({});
    final isSaving = useState(false);

    // Load categories from Isar (real data via SWR stream)
    final categoriesAsync = ref.watch(categoryListProvider);

    // Load existing preferences to pre-select already-chosen items
    useEffect(() {
      Future<void> loadExistingPreferences() async {
        try {
          final prefs = await ref.read(getUserCategoryPreferencesProvider.future);
          if (prefs.isNotEmpty) {
            selectedItems.value = prefs.map((c) => c.id!).toSet();
          }
        } catch (_) { /* No existing prefs — fine */ }
      }

      loadExistingPreferences();
      return () {};
    }, const []);

    // Toggle function for multi-selection
    void toggleSelection(String id) {
      final currentSelection = Set<String>.from(selectedItems.value);
      if (currentSelection.contains(id)) {
        currentSelection.remove(id);
      } else {
        currentSelection.add(id);
      }
      selectedItems.value = currentSelection;
    }

    // Minimum of 2 selected items required
    final isSubmitEnabled = selectedItems.value.length >= 2 && !isSaving.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FC),
        elevation: 0,
        title: const Text(
          'Personalisasi',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: categoriesAsync.when(
                data: (categories) {
                  // Split categories by isPopular
                  final popular = categories
                      .where((c) => c.isPopular == true)
                      .toList();
                  final others = categories
                      .where((c) => c.isPopular != true)
                      .toList();

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Header Section
                        const Text(
                          'Pilih Layanan Favorit\nAnda',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Pilih kategori dan layanan yang ingin\nAnda akses dengan cepat.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Popular Categories Section
                        if (popular.isNotEmpty)
                          _CategorySection(
                            title: 'Populer',
                            categories: popular,
                            selectedIds: selectedItems.value,
                            onToggle: toggleSelection,
                          ),

                        // Divider between popular and others
                        if (popular.isNotEmpty && others.isNotEmpty)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 24.0),
                            child: Divider(
                              color: Color(0xFFE2E8F0),
                              thickness: 1,
                            ),
                          ),

                        // Other Categories Section
                        if (others.isNotEmpty)
                          _CategorySection(
                            title: 'Kategori Lainnya',
                            categories: others,
                            selectedIds: selectedItems.value,
                            onToggle: toggleSelection,
                          ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF025ED6),
                  ),
                ),
                error: (error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gagal memuat kategori',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          error.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => ref.invalidate(categoryListProvider),
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Sticky Bottom Bar
            _SubmitBottomBar(
              isEnabled: isSubmitEnabled,
              isSaving: isSaving.value,
              onPressed: () async {
                isSaving.value = true;

                try {
                  final ids = selectedItems.value.toList();
                  await ref.read(
                    saveUserCategoryPreferencesProvider(ids).future,
                  );

                  if (context.mounted) {
                    context.go('/homepage');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Gagal menyimpan: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } finally {
                  isSaving.value = false;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String title;
  final List<CategoryEntity> categories;
  final Set<String> selectedIds;
  final Function(String) onToggle;

  const _CategorySection({
    required this.title,
    required this.categories,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: categories.map((category) {
              final isSelected = selectedIds.contains(category.id);
              return _CategoryChip(
                category: category,
                isSelected: isSelected,
                onTap: () => onToggle(category.id!),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final CategoryEntity category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF025ED6) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF025ED6)
                  : const Color(0xFFCBD5E1),
              width: 1,
            ),
          ),
          child: Text(
            category.name ?? '',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? Colors.white : const Color(0xFF0F172A),
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitBottomBar extends StatelessWidget {
  final bool isEnabled;
  final bool isSaving;
  final VoidCallback onPressed;

  const _SubmitBottomBar({
    required this.isEnabled,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isEnabled ? onPressed : null,
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFFE2E8F0);
              }
              return const Color(0xFF025ED6);
            }),
            foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.disabled)) {
                return const Color(0xFF94A3B8);
              }
              return Colors.white;
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            elevation: WidgetStateProperty.all(0),
          ),
          child: isSaving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Simpan & Lanjutkan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
                ),
        ),
      ),
    );
  }
}