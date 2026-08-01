import "dart:async";

import "package:flutter/material.dart";
import "package:lucide_icons_flutter/lucide_icons.dart";
import "package:movify/core/extensions/index.dart";
import "package:movify/core/extensions/int_extensions.dart";
import "package:movify/core/theme/app_colors.dart";
import "package:movify/core/theme/app_spacing.dart";
import "package:movify/domain/entities/index.dart" show User, Movie;
import "package:movify/presentation/widgets/app_step_indicator.dart";
import "package:movify/presentation/widgets/index.dart"
    show AppScaffold, AppTopbar;

import "../providers/app_dependencies.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final PageController _pageController;
  final List<Movie> recommandations = [];
  Timer? _autoScrollTimer;
  var _current = 0;
  User user = User(username: "...", email: "", phone: "");

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.88)
      ..addListener(_onPageScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final _ = await Future.wait([_loadUser(), _loadRecommandations()]);
      if (!mounted) return;
      _startAutoScroll();
      setState(() {});
    });
  }

  void _onPageScroll() {
    if (!mounted || !_pageController.hasClients || recommandations.isEmpty) {
      return;
    }
    final page = _pageController.page?.round() ?? 0;
    if (_current != page) {
      setState(() => _current = page);
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    if (recommandations.isEmpty) return;
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 3500), (_) {
      if (!mounted || !_pageController.hasClients || recommandations.isEmpty) {
        return;
      }
      final nextPage = (_current + 1) % recommandations.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.removeListener(_onPageScroll);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isMobile = context.isMobile;
    final recommandationsLength = recommandations.length;

    return AppScaffold(
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTopbar(
            title: "Bienvenue",
            subtitle: user.username.capitalize,
            titleTextStyle: textTheme.titleSmall,
            subTitleTextStyle: textTheme.headlineMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
            showLeading: false,
            titleSubtitleSpacing: 0,
            actions: [
              IconButton(
                style: IconButton.styleFrom(
                  padding: AppSpacing.insetMd,
                  backgroundColor: colorScheme.onPrimary,
                ),
                color: colorScheme.secondary,
                onPressed: () => context.pushToWatchlist(),
                icon: const Icon(LucideIcons.history, size: AppSpacing.iconLg),
                tooltip: "A voir",
              ),
              IconButton(
                style: IconButton.styleFrom(
                  padding: AppSpacing.insetMd,
                  backgroundColor: colorScheme.onPrimary,
                ),
                color: colorScheme.secondary,
                onPressed: () async {
                  final deps = AppDependencies.of(context);
                  final newMode = context.isDarkMode
                      ? ThemeMode.light
                      : ThemeMode.dark;
                  await deps.themeRepository.saveThemeMode(newMode);
                  deps.themeModeNotifier.value = newMode;
                },
                icon: Icon(
                  context.isDarkMode ? LucideIcons.moon : LucideIcons.sun,
                  size: AppSpacing.iconLg,
                ),
                tooltip: "Thème",
              ),
            ],
          ),
          AppSpacing.gapVLg,
          if (recommandationsLength > 0) ...[
            SizedBox(
              height: AppSpacing.yotta * 1.5,
              child: PageView.builder(
                controller: _pageController,
                itemCount: recommandationsLength,
                itemBuilder: (context, index) {
                  final Movie(:title, :poster, :imdbRating) =
                      recommandations[index];
                  final isSelected = _current == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.sm),
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: AppSpacing.roundedLg,
                      ),
                      margin: EdgeInsets.zero,
                      child: SizedBox(
                        height: AppSpacing.yotta * 2,
                        child: Stack(
                          fit: .expand,
                          children: [
                            ClipRRect(
                              borderRadius: AppSpacing.roundedLg,
                              child: Image.network(
                                poster,
                                fit: .cover,
                                // alignment: .topCenter,
                                color: AppColors.black.withValues(alpha: 0.5),
                                colorBlendMode: .darken,
                                errorBuilder: (context, error, stackTrace) {
                                  return ColoredBox(
                                    color: colorScheme.surfaceContainerHighest,
                                    child: const Icon(
                                      LucideIcons.film,
                                      size: AppSpacing.iconXxl,
                                    ),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: isMobile ? AppSpacing.lg : AppSpacing.xl,
                              left: isMobile ? AppSpacing.lg : AppSpacing.xl,
                              child: Column(
                                crossAxisAlignment: .start,
                                mainAxisSize: .min,
                                children: [
                                  SmoothShow(
                                    isSelected: isSelected,
                                    title: title,
                                  ),
                                  SmoothShow(
                                    isSelected: isSelected,
                                    child: Row(
                                      spacing: AppSpacing.xs,
                                      children: [
                                        Icon(
                                          LucideIcons.star,
                                          color: colorScheme.tertiary,
                                        ),
                                        Text(
                                          "$imdbRating/10 IMDB",
                                          style: textTheme.bodySmall!.copyWith(
                                            color: AppColors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            AppSpacing.gapVMd,
            AppStepIndicator(
              currentStep: _current,
              totalSteps: recommandationsLength,
              selectedScale: 1,
              dotSize: AppSpacing.xs,
            ),
          ] else ...[
            const SizedBox(
              height: AppSpacing.yotta * 1.8,
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          AppSpacing.gapVMd,
          Row(
            children: [
              Text(
                "Populaire",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.gapVSm,
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recommandationsLength,
            itemBuilder: (context, index) {
              final Movie(:id, :title, :poster, :imdbRating, :genre, :runtime) =
                  recommandations[index];
              return MovieItem(
                id: id,
                poster: poster,
                title: title,
                imdbRating: imdbRating,
                genre: genre,
                runtime: runtime,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _loadRecommandations() async {
    try {
      final movies = await AppDependencies.of(context).movieRepository
          .getMovieRecommandation(length: 6);
      recommandations
        ..clear()
        ..addAll(movies);
    } catch (e) {
      debugPrint("Erreur chargement recommandations: $e");
    }
  }

  Future<void> _loadUser() async {
    try {
      final myUser = await AppDependencies.of(context).userRepository.getUser();
      user = myUser;
    } catch (e) {
      debugPrint("Erreur chargement user: $e");
    }
  }
}

class MovieItem extends StatelessWidget {
  const new({
    super.key,
    required this.id,
    required this.poster,
    required this.title,
    required this.imdbRating,
    required this.genre,
    required this.runtime,
  });

  final String id;
  final String poster;
  final String title;
  final double imdbRating;
  final List<String> genre;
  final int runtime;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;
    final textTheme = context.textTheme;
    final isMobile = context.isMobile;
    return InkWell(
      onTap: () => context.goToMovieDetail(id),
      borderRadius: AppSpacing.roundedSm,
      child: Padding(
        padding: AppSpacing.insetSm,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSpacing.md,
            children: [
              Container(
                width: AppSpacing.tera * (isMobile ? 1.25 : 1.5),
                height: AppSpacing.yotta * (isMobile ? 1 : 1.125),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(alpha: 0.6),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.6),
                  ),
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Image.network(
                  poster,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return ColoredBox(
                      color: colorScheme.surfaceContainerHighest,
                      child: const Icon(
                        LucideIcons.film,
                        size: AppSpacing.iconXxl,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisAlignment: .spaceBetween,
                  spacing: AppSpacing.xs,
                  children: [
                    Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        Icon(
                          LucideIcons.star,
                          color: colorScheme.tertiary,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          "$imdbRating/10 IMDB",
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: genre
                          .take(2)
                          .map(
                            (item) => Chip(
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              padding: AppSpacing.insetXs,
                              shape: const RoundedRectangleBorder(
                                borderRadius: AppSpacing.roundedXxl,
                              ),
                              label: Text(item, style: textTheme.labelMedium),
                            ),
                          )
                          .toList(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: AppSpacing.xs,
                      children: [
                        const Icon(
                          LucideIcons.history,
                          size: AppSpacing.iconSm,
                        ),
                        Text(
                          runtime.toFormattedDuration(),
                          style: textTheme.labelMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SmoothShow extends StatelessWidget {
  const SmoothShow({
    super.key,
    required this.isSelected,
    this.title = "",
    this.child,
  });

  final bool isSelected;
  final String title;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
      opacity: isSelected ? 1.0 : 0.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
        offset: isSelected ? Offset.zero : const Offset(0, 0.2),
        child:
            child ??
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
      ),
    );
  }
}
