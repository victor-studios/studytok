import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/constants/spacing.dart';
import '../../providers/app_providers.dart';
import '../../models/subject.dart';
import '../../core/theme/level_theme.dart';
import 'package:video_player/video_player.dart';
import '../../core/utils/ui_utils.dart';
/// The core immersive fullscreen vertical learning feed.
class LearnFeedScreen extends ConsumerStatefulWidget {
  const LearnFeedScreen({super.key});

  @override
  ConsumerState<LearnFeedScreen> createState() => _LearnFeedScreenState();
}

class _LearnFeedScreenState extends ConsumerState<LearnFeedScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final subject = ref.watch(currentSubjectProvider);
    final subjects = ref.watch(enrolledSubjectsProvider);
    final lessons = ref.watch(currentLessonsProvider);
    final chapterIndex = ref.watch(currentChapterIndexProvider);
    final currentChapter = ref.watch(currentChapterProvider);
    final palette = ref.watch(effectiveLevelProvider).palette;
    final showOverlays = ref.watch(showOverlaysProvider);

    // Set status bar to light for dark video feed
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    if (subject == null || lessons.isEmpty) {
      return _EmptyFeedState(
        onSelectSubject: subjects.isNotEmpty
            ? () {
                ref.read(currentSubjectProvider.notifier).state =
                    subjects.first;
              }
            : null,
      );
    }

    return Stack(
      children: [
        // ─── Fullscreen Lesson Feed ────────────────────────────
        PageView.builder(
          controller: _pageController,
          scrollDirection: Axis.vertical,
          itemCount: lessons.length,
          onPageChanged: (index) {
            ref.read(currentLessonIndexProvider.notifier).state = index;
            // Update chapter index based on lesson
            final lesson = lessons[index];
            final newChapterIdx = subject.chapters.indexWhere(
              (ch) => ch.id == lesson.chapterId,
            );
            if (newChapterIdx >= 0 && newChapterIdx != chapterIndex) {
              ref.read(currentChapterIndexProvider.notifier).state =
                  newChapterIdx;
            }
          },
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            final isActive = ref.watch(currentLessonIndexProvider) == index;
            return _LessonVideoCard(
              lesson: lesson,
              subject: subject,
              isActive: isActive,
              palette: palette,
              onDetailsTap: () => context.push('/lesson/${lesson.id}'),
              onBookmarkTap: () {
                final bookmarks = ref.read(bookmarkedLessonIdsProvider);
                if (bookmarks.contains(lesson.id)) {
                  ref.read(bookmarkedLessonIdsProvider.notifier).state =
                      bookmarks.where((id) => id != lesson.id).toSet();
                } else {
                  ref.read(bookmarkedLessonIdsProvider.notifier).state = {
                    ...bookmarks,
                    lesson.id,
                  };
                }
              },
              isBookmarked: ref
                  .watch(bookmarkedLessonIdsProvider)
                  .contains(lesson.id),
            );
          },
        ),

        // ─── Top Overlay ───────────────────────────────────────
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xCC000000), Color(0x00000000)],
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.md,
                  ),
                  child: Column(
                    children: [
                      // Header row
                      Row(
                        children: [
                          // Subject selector
                          GestureDetector(
                            onTap: () =>
                                _showSubjectPicker(context, ref, subjects),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.35,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    subject.icon,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Flexible(
                                    child: Text(
                                      subject.name,
                                      style: AppTypography.labelLarge.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.white70,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Chapter selector
                          if (currentChapter != null)
                            GestureDetector(
                              onTap: () => _showChapterPicker(context, ref, subject, palette),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.35,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.25),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            currentChapter.title,
                                            style: AppTypography.labelLarge.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 2),
                                        const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: Colors.white70,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          const Spacer(),
                          // Add Subject
                          IconButton(
                            onPressed: () {
                              ref.read(selectedTierProvider.notifier).state = ref.read(activeProfileProvider)?.academicTier != null ? AcademicLevel.values.byName(ref.read(activeProfileProvider)!.academicTier) : AcademicLevel.grades1to8;
                              ref.read(selectedGradeProvider.notifier).state = ref.read(activeProfileProvider)?.currentGrade;
                              context.push('/setup/subjects');
                            },
                            icon: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: palette.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          // Search
                          IconButton(
                            onPressed: () => context.push('/search'),
                            icon: ClipOval(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.search_rounded,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      // Lesson chips
                      if (currentChapter != null)
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentChapter.lessons.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final lesson = currentChapter.lessons[i];
                              final isCurrent = ref.watch(currentLessonIndexProvider) ==
                                  lessons.indexWhere((l) => l.id == lesson.id);
                              final isCompleted = lesson.isCompleted;

                              return GestureDetector(
                                onTap: () {
                                  final targetIndex = lessons.indexWhere((l) => l.id == lesson.id);
                                  if (targetIndex >= 0) {
                                    _pageController.animateToPage(
                                      targetIndex,
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isCurrent
                                        ? Colors.white
                                        : isCompleted
                                        ? palette.primary.withValues(alpha: 0.3)
                                        : Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: isCurrent
                                        ? null
                                        : Border.all(
                                            color: Colors.white.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isCompleted)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 4),
                                          child: Icon(
                                            Icons.check_circle_rounded,
                                            size: 14,
                                            color: isCurrent
                                                ? palette.primary
                                                : Colors.white,
                                          ),
                                        ),
                                      Text(
                                        'L${lesson.lessonNumber}',
                                        style: AppTypography.labelLarge.copyWith(
                                          color: isCurrent
                                              ? AppColors.primaryText
                                              : Colors.white,
                                          fontWeight: isCurrent
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showSubjectPicker(
    BuildContext context,
    WidgetRef ref,
    List<Subject> subjects,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Subject',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              ...subjects.map((s) {
                final isCurrent = ref.read(currentSubjectProvider)?.id == s.id;
                return ListTile(
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: s.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(s.icon, color: s.color, size: 20),
                  ),
                  title: Text(s.name, style: AppTypography.bodyLarge),
                  trailing: isCurrent
                      ? Icon(
                          Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    ref.read(currentSubjectProvider.notifier).state = s;
                    ref.read(currentChapterIndexProvider.notifier).state = 0;
                    ref.read(currentLessonIndexProvider.notifier).state = 0;
                    _pageController.jumpToPage(0);
                    Navigator.pop(ctx);
                  },
                );
              }),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showChapterPicker(
    BuildContext context,
    WidgetRef ref,
    Subject subject,
    LevelPalette palette,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Switch Chapter',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.primaryText,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: subject.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = subject.chapters[index];
                    final isCurrent = ref.watch(currentChapterProvider)?.id == chapter.id;
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        chapter.title,
                        style: AppTypography.bodyLarge.copyWith(
                          fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500,
                          color: isCurrent ? palette.primary : AppColors.primaryText,
                        ),
                      ),
                      trailing: isCurrent
                          ? Icon(
                              Icons.check_rounded,
                              color: palette.primary,
                            )
                          : null,
                      onTap: () {
                        ref.read(currentChapterIndexProvider.notifier).state = index;
                        // Calculate where this chapter's first lesson starts globally
                        int lessonOffset = 0;
                        for (int i = 0; i < index; i++) {
                          lessonOffset += subject.chapters[i].lessons.length;
                        }
                        ref.read(currentLessonIndexProvider.notifier).state = lessonOffset;
                        _pageController.jumpToPage(lessonOffset);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}

/// Single fullscreen lesson card in the video feed.
class _LessonVideoCard extends ConsumerStatefulWidget {
  final Lesson lesson;
  final LevelPalette palette;
  final VoidCallback onDetailsTap;
  final VoidCallback onBookmarkTap;
  final bool isBookmarked;

  final Subject subject;
  final bool isActive;

  const _LessonVideoCard({
    required this.lesson,
    required this.subject,
    required this.isActive,
    required this.palette,
    required this.onDetailsTap,
    required this.onBookmarkTap,
    required this.isBookmarked,
  });

  @override
  ConsumerState<_LessonVideoCard> createState() => _LessonVideoCardState();
}

class _LessonVideoCardState extends ConsumerState<_LessonVideoCard> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;
  Timer? _overlayTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    if (widget.lesson.videoUrl != null && _controller == null) {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.lesson.videoUrl!))
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {});
          _controller!.setLooping(true);
          if (widget.isActive) {
            _controller!.play();
            _isPlaying = true;
            _startOverlayTimer();
          }
        }).catchError((error) {
          debugPrint("Video initialization error: $error");
        });
    }
  }

  @override
  void didUpdateWidget(covariant _LessonVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive) {
        if (_controller == null) {
          _initializeVideo();
        } else if (_controller!.value.isInitialized) {
          _controller!.play();
          setState(() => _isPlaying = true);
          _startOverlayTimer();
          // Update global state
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(isVideoPlayingProvider.notifier).state = true;
          });
        }
      } else {
        if (_controller != null && _controller!.value.isPlaying) {
          _controller!.pause();
          setState(() => _isPlaying = false);
        }
      }
    }
  }

  void _startOverlayTimer() {
    _overlayTimer?.cancel();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(showOverlaysProvider.notifier).state = true;
    });
    _overlayTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && _isPlaying) {
        ref.read(showOverlaysProvider.notifier).state = false;
      }
    });
  }

  @override
  void dispose() {
    _overlayTimer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() {
      if (_controller!.value.isPlaying) {
        _controller!.pause();
        _isPlaying = false;
        ref.read(isVideoPlayingProvider.notifier).state = false;
        _overlayTimer?.cancel();
        ref.read(showOverlaysProvider.notifier).state = true;
      } else {
        _controller!.play();
        _isPlaying = true;
        ref.read(isVideoPlayingProvider.notifier).state = true;
        _startOverlayTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showOverlays = ref.watch(showOverlaysProvider);
    // Generate a gradient based on lesson index for visual variety
    final gradientColors = [
      widget.palette.primary.withValues(alpha: 0.8),
      widget.palette.secondary.withValues(alpha: 0.6),
      Colors.black87,
    ];

    return GestureDetector(
      onTap: _togglePlay,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
        child: Stack(
          children: [
            // Video Player Background
            if (_controller != null && _controller!.value.isInitialized)
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller!.value.size.width,
                    height: _controller!.value.size.height,
                    child: VideoPlayer(_controller!),
                  ),
                ),
              ),

            // Play Icon overlay if paused
            if (_controller != null && !_isPlaying)
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                ),
              ),

            if (_controller == null)
              // Center play icon (placeholder for no video)
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${widget.lesson.duration.inMinutes}:${(widget.lesson.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

            // ─── Bottom Gradient Overlay ────────────────────────
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 350,
              child: AnimatedOpacity(
                opacity: showOverlays ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ─── Bottom-left lesson info ────────────────────────
            Positioned(
              left: AppSpacing.md,
              right: 72,
              bottom: 100,
              child: AnimatedOpacity(
                opacity: showOverlays ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !showOverlays,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Chapter title
                        Text(
                          widget.lesson.chapterTitle,
                          style: AppTypography.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                            height: 1.2,
                          ),
                            ),
                            const SizedBox(height: 6),
                            
                            // Lesson and Subtitle
                            Text(
                              '${widget.lesson.title} - ${widget.lesson.subtitle}',
                              style: AppTypography.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.85),
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 12),
                            
                            // Progress text and teacher
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.play_circle_outline_rounded,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Part ${widget.lesson.lessonNumber}/${widget.lesson.totalLessonsInChapter}',
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: widget.palette.primary.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        widget.subject.icon,
                                        color: Colors.white,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.subject.name,
                                        style: AppTypography.labelSmall.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Right-side Action Rail ─────────────────────────
          Positioned(
            right: AppSpacing.sm,
            bottom: 110,
            child: AnimatedOpacity(
              opacity: 1.0,
              duration: const Duration(milliseconds: 300),
              child: IgnorePointer(
                ignoring: false,
                child: Column(
                  children: [
                  // Favourite
                _ActionRailButton(
                  icon: widget.isBookmarked
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: 'Save',
                  isActive: widget.isBookmarked,
                  activeColor: widget.palette.primary,
                  onTap: widget.onBookmarkTap,
                ),
                const SizedBox(height: 20),
                // Details
                _ActionRailButton(
                  icon: Icons.article_rounded,
                  label: 'Details',
                  onTap: widget.onDetailsTap,
                ),
                const SizedBox(height: 20),
                // Quick Practice
                _ActionRailButton(
                  icon: Icons.quiz_rounded,
                  label: 'Quiz',
                  onTap: () => context.push('/test/create'),
                ),
                const SizedBox(height: 20),
                // Share
                _ActionRailButton(
                  icon: Icons.share_rounded,
                  label: 'Share',
                  onTap: () => UiUtils.showComingSoonSnackBar(context),
                ),
              ],
            ),
            ),
          ),
        ),

          // ─── Chapter progress bar ───────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 84,
            child: AnimatedOpacity(
              opacity: !_isPlaying ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: LinearProgressIndicator(
                value: widget.lesson.lessonNumber / widget.lesson.totalLessonsInChapter,
                minHeight: 2.5,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(widget.palette.primary),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
}

/// TikTok-style right-side action button.
class _ActionRailButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onTap;

  const _ActionRailButton({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isActive
                      ? (activeColor ?? Colors.white).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isActive
                        ? (activeColor ?? Colors.white).withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (isActive)
                      BoxShadow(
                        color: (activeColor ?? Colors.white).withValues(alpha: 0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                  ],
                ),
                child: Icon(
                  icon,
                  color: isActive ? (activeColor ?? Colors.white) : Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontWeight: FontWeight.w600,
              fontSize: 11,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when no subject is selected.
class _EmptyFeedState extends StatelessWidget {
  final VoidCallback? onSelectSubject;

  const _EmptyFeedState({this.onSelectSubject});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.play_circle_outline_rounded,
              size: 64,
              color: AppColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              'No lessons yet',
              style: AppTypography.titleLarge.copyWith(
                color: AppColors.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Select a subject to start learning',
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
            if (onSelectSubject != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSelectSubject,
                child: const Text('Start Learning'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
