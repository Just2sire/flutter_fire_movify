import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/build_context_extensions.dart";
import "package:movify/core/routing/app_routes.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/presentation/widgets/app_icon_switcher.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold;

class AppShell extends StatefulWidget {
  const AppShell({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  List<NavItemData> get _navItems => <NavItemData>[
    (index: 0, icon: LucideIcons.home, label: "Accueil", route: AppRoutes.home),
    (
      index: 1,
      icon: LucideIcons.film,
      label: "Films",
      route: AppRoutes.movies,
    ),
    (
      index: 2,
      icon: LucideIcons.bookMarked,
      label: "Favoris",
      route: AppRoutes.favourites,
    ),
    (
      index: 3,
      icon: LucideIcons.circleUserRound,
      label: "Profile",
      route: AppRoutes.profile,
    ),
  ];

  void _onTap(int index) {
    final navigationShell = widget.navigationShell;
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    final currentIndex = navigationShell.currentIndex;
    final itemsLength = _navItems.length;
    final theme = Theme.of(context);
    return AppScaffold(
      padding: EdgeInsets.zero,
      body: Builder(
        builder: (context) {
          if (context.isMobile) return navigationShell;
          return Row(
            children: [
              NavigationRail(
                selectedIndex: currentIndex,
                onDestinationSelected: _onTap,
                labelType: NavigationRailLabelType.selected,
                destinations: List.generate(_navItems.length, (index) {
                  final item = _navItems[index];
                  return NavigationRailDestination(
                    icon: Icon(item.icon),
                    label: Text(item.label),
                  );
                }),
              ),
              VerticalDivider(
                thickness: 1,
                width: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
              Expanded(child: navigationShell),
            ],
          );
        },
      ),
      floatingActionButton: itemsLength == 5 && context.isMobile
          ? FloatingActionButton(
              onPressed: () => _onTap(2),
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.primaryContainer,
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primaryContainer.withValues(
                        alpha: 0.4,
                      ),
                      blurRadius: AppSpacing.sm,
                      spreadRadius: 2,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppIconSwitcher(
                  child: Icon(
                    _navItems[2].icon,
                    color: theme.colorScheme.onPrimaryContainer,
                    size: widget.navigationShell.currentIndex == 2
                        ? AppSpacing.iconMxl
                        : AppSpacing.iconLg,
                    key: ValueKey(
                      "app_shell_${widget.navigationShell.currentIndex == 2}",
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: context.isMobile
          ? .centerDocked
          : null,
      bottomNavigationBar: context.isMobile
          ? AppBottomBar(
              items: _navItems,
              selectedIndex: widget.navigationShell.currentIndex,
              onTap: _onTap,
              selectedColor: context.accentColor,
            )
          : null,
    );
  }
}

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.items,
    required this.selectedIndex,
    required this.onTap,
    required this.selectedColor,
    this.unselectedColor,
    super.key,
  });
  final List<NavItemData> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final Color selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemsLength = items.length;

    return BottomAppBar(
      color: theme.bottomAppBarTheme.color,
      shape: const CircularNotchedRectangle(),
      notchMargin: AppSpacing.sm,
      elevation: AppSpacing.elevationLg,
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: SizedBox(
        height: AppSpacing.bottomNavHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(items.length, (index) {
            if (index == 2 && itemsLength == 5) {
              return const Expanded(child: SizedBox.shrink());
            }
            return _BottomBarItem(
              icon: items[index].icon,
              label: items[index].label,
              isSelected: selectedIndex == index,
              onTap: () => onTap(index),
              selectedColor: selectedColor,
              unselectedColor: unselectedColor,
            );
          }),
        ),
      ),
    );
  }
}

typedef NavItemData = ({int index, IconData icon, String label, String route});

class _BottomBarItem extends StatelessWidget {
  const _BottomBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedColor,
    // ignore: unused_element_parameter
    this.selectedIcon,
    this.unselectedColor,
  });

  final IconData icon;
  final IconData? selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedColor;
  final Color? unselectedColor;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? selectedColor : unselectedColor;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              curve: AppSpacing.curveEnter,
              duration: AppSpacing.durationFast,
              opacity: isSelected ? 1 : 0,
              child: Container(
                height: 3,
                width: AppSpacing.xxl,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: AppSpacing.roundedXs,
                ),
              ),
            ),
            const Spacer(),
            AppIconSwitcher(
              child: Icon(
                isSelected ? selectedIcon ?? icon : icon,
                color: color,
                size: isSelected ? AppSpacing.iconMxl : AppSpacing.iconLg,
                key: ValueKey("$label&$isSelected"),
              ),
            ),
            AppSpacing.gapVXs,
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            AppSpacing.gapVSm,
          ],
        ),
      ),
    );
  }
}
