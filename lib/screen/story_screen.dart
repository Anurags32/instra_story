import 'package:flutter/material.dart';
import 'package:story_app/model/user_model.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class StoryScreen extends StatefulWidget {
  final UserModel user;

  const StoryScreen({super.key, required this.user});

  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;
  int currentIndex = 0;
  late PageController _pageController;
  Timer? _timer;
  double _storyProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: currentIndex);
    _initializeStory(widget.user.stories[currentIndex]);
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _initializeStory(StoryModel story) {
    _timer?.cancel();
    setState(() {
      _storyProgress = 0.0;
    });

    if (story.mediaType == 'video') {
      _controller?.dispose();
      _controller = VideoPlayerController.network(story.mediaUrl);
      _initializeVideoPlayerFuture = _controller!.initialize().then((_) {
        setState(() {
          _controller!.play();
        });
        _startVideoProgressIndicator();
      });
    } else {
      _controller = null;
      _startImageProgressIndicator();
    }
  }

  void _startVideoProgressIndicator() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_controller != null && _controller!.value.isInitialized) {
        setState(() {
          _storyProgress = _controller!.value.position.inMilliseconds /
              _controller!.value.duration.inMilliseconds;
          if (_controller!.value.position >= _controller!.value.duration) {
            _onTap();
          }
        });
      }
    });
  }

  void _startImageProgressIndicator() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _storyProgress += 0.01;
        if (_storyProgress >= 1.0) {
          _onTap();
        }
      });
    });
  }

  void _onTap() {
    if (currentIndex < widget.user.stories.length - 1) {
      setState(() {
        currentIndex++;
        _pageController.animateToPage(
          currentIndex,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        _initializeStory(widget.user.stories[currentIndex]);
      });
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.user.profilePicture),
            ),
            const SizedBox(width: 10),
            Text(
              widget.user.userName,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      body: widget.user.stories.isNotEmpty
          ? Stack(
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.user.stories.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                      _initializeStory(widget.user.stories[currentIndex]);
                    });
                  },
                  itemBuilder: (context, index) {
                    final story = widget.user.stories[index];
                    return GestureDetector(
                      onTap: _onTap,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (story.mediaType == 'image')
                            Image.network(
                              story.mediaUrl,
                              fit: BoxFit.cover,
                            )
                          else if (story.mediaType == 'video' &&
                              _controller != null)
                            FutureBuilder(
                              future: _initializeVideoPlayerFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return AspectRatio(
                                    aspectRatio: _controller!.value.aspectRatio,
                                    child: VideoPlayer(_controller!),
                                  );
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black54, Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 30,
                            left: 15,
                            right: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  story.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 8.0,
                                        color: Colors.black45,
                                        offset: Offset(2.0, 2.0),
                                      ),
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
                Positioned(
                  top: 30,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: widget.user.stories
                        .asMap()
                        .map((i, story) => MapEntry(
                              i,
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 2.0),
                                  child: LinearProgressIndicator(
                                    value: i == currentIndex
                                        ? _storyProgress
                                        : (i < currentIndex ? 1.0 : 0.0),
                                    backgroundColor: Colors.white30,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.lightGreenAccent),
                                    minHeight: 5,
                                  ),
                                ),
                              ),
                            ))
                        .values
                        .toList(),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                "No stories available",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
    );
  }
}
