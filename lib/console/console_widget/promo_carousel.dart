import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../consoleConstants.dart';

/// Data model for an item in the Promo Carousel.
class PromoEvent {
  final String title;
  final String subtitle;
  final String img;
  PromoEvent({required this.title, required this.subtitle, required this.img});
}

/// Renders either an image or a video within the carousel card.
/// Automatically detects video files by extension (.mp4, .mov, .webm).
class CarouselMedia extends StatefulWidget {
  final PromoEvent event;
  final bool isActive;
  const CarouselMedia({required this.event, required this.isActive, super.key});

  @override
  State<CarouselMedia> createState() => _CarouselMediaState();
}

class _CarouselMediaState extends State<CarouselMedia> {
  VideoPlayerController? _controller;
  bool get _isVideo {
    final lower = widget.event.img.toLowerCase();
    return lower.endsWith('.mp4') || lower.endsWith('.mov') || lower.endsWith('.webm');
  }

  @override
  void initState() {
    super.initState();
    if (_isVideo) _initVideo();
  }

  void _initVideo() {
    final controller = VideoPlayerController.asset(widget.event.img);
    _controller = controller;
    controller.setLooping(true);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
      if (widget.isActive) controller.play();
    });
  }

  @override
  void didUpdateWidget(covariant CarouselMedia oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controller = _controller;
    if (controller != null && controller.value.isInitialized) {
      if (widget.isActive) {
        controller.play();
      } else {
        controller.pause();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVideo) {
      return Image.asset(widget.event.img, fit: BoxFit.cover, gaplessPlayback: true);
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const ColoredBox(color: Colors.black26);
    }
    return Center(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: controller.value.size.width,
          height: controller.value.size.height,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}

/// A high-energy promotional carousel with automatic sliding and a 
/// "heartbeat" pulse badge. Supports both image and video content.
class StoryPromoCarousel extends StatefulWidget {
  final List<PromoEvent> events;
  const StoryPromoCarousel({required this.events, super.key});

  @override
  State<StoryPromoCarousel> createState() => _StoryPromoCarouselState();
}

class _StoryPromoCarouselState extends State<StoryPromoCarousel>
    with TickerProviderStateMixin {
  late final PageController _pageController = PageController(viewportFraction: 0.68);
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 4),
  )..addStatusListener(_onStatus);
  late final AnimationController _heartbeat = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat(reverse: true);

  int _current = 0;

  @override
  void initState() {
    super.initState();
    _progress.forward();
  }

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      final next = (_current + 1) % widget.events.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _pause() => _progress.stop();
  void _resume() => _progress.forward();

  @override
  void dispose() {
    _progress.dispose();
    _heartbeat.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => _pause(),
      onPanCancel: _resume,
      onPanEnd: (_) => _resume(),
      child: Column(
        children: [
          SizedBox(
            height: 460,
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              padEnds: false,
              itemCount: widget.events.length,
              onPageChanged: (i) {
                setState(() => _current = i);
                _progress
                  ..reset()
                  ..forward();
              },
              itemBuilder: (context, index) {
                final event = widget.events[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: DarkColors.sunsetFireGradient,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CarouselMedia(event: event, isActive: index == _current),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.10),
                              Colors.black.withOpacity(0.55),
                              Colors.black.withOpacity(0.85),
                            ],
                            stops: const [0.0, 0.35, 0.7, 1.0],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 18,
                        right: 18,
                        child: AnimatedBuilder(
                          animation: _heartbeat,
                          builder: (context, child) {
                            final s = 1.0 + (_heartbeat.value * 0.15);
                            return Transform.scale(scale: s, child: child);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text('!',
                                style: TextStyle(
                                  color: DarkColors.gold,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(26),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.4,
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 2)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              event.subtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13.5,
                                shadows: [
                                  Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 1)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AnimatedBuilder(
              animation: _progress,
              builder: (context, _) {
                return Row(
                  children: List.generate(widget.events.length, (index) {
                    double fill;
                    if (index < _current) {
                      fill = 1;
                    } else if (index == _current) {
                      fill = _progress.value;
                    } else {
                      fill = 0;
                    }
                    return Expanded(
                      child: Container(
                        height: 3,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: fill,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: DarkColors.coralGoldGradient,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
