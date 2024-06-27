import 'package:flutter/material.dart';
import 'package:tobeto_mobile_app/models/lesson_model.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class LessonDetailsPage extends StatefulWidget {
  final LessonModel lesson;

  const LessonDetailsPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonDetailsPage> createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  late List<VideoPlayerController> _controllers;
  late Future<void> _initializeVideoPlayerFuture;
  int _selectedVideoIndex = 0;

  @override
  void initState() {
    super.initState();

    _controllers = widget.lesson.videos.values.expand((videoList) {
      return videoList.map((video) {
        String videoUrl = video['videoUrl'] ?? '';
        return VideoPlayerController.network(videoUrl);
      });
    }).toList();

    if (_controllers.isNotEmpty) {
      _initializeVideoPlayerFuture = Future.wait(_controllers.map((controller) => controller.initialize()));
    } else {
      _initializeVideoPlayerFuture = Future.value();
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onVideoSelected(int index) {
    setState(() {
      _selectedVideoIndex = index;
      _controllers[_selectedVideoIndex].play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (_controllers.isEmpty) {
                      return const Center(child: Text('Video bulunamadı.'));
                    }
                    return Column(
                      children: [
                        AspectRatio(
                          aspectRatio: _controllers[_selectedVideoIndex].value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(_controllers[_selectedVideoIndex]),
                              _ControlsOverlay(controller: _controllers[_selectedVideoIndex], isFullScreen: false),
                              VideoProgressIndicator(_controllers[_selectedVideoIndex], allowScrubbing: true),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.lesson.formattedDate(),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        ...widget.lesson.videos.entries.map((entry) {
                          String lessonTitle = entry.key;
                          List<Map<String, String>> videoList = entry.value;

                          return ExpansionTile(
                            title: Text(lessonTitle, style: const TextStyle(fontWeight: FontWeight.bold),),
                            children: videoList.map((video) {
                              String videoName = video['videoName'] ?? '';
                              String videoUrl = video['videoUrl'] ?? '';

                              return ListTile(
                                title: Text(videoName),
                                onTap: () => _onVideoSelected(_controllers.indexWhere((element) => element.dataSource == videoUrl)),
                              );
                            }).toList(),
                          );
                        }),
                      ],
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _ControlsOverlay extends StatefulWidget {
  const _ControlsOverlay({required this.controller, required this.isFullScreen});

  final VideoPlayerController controller;
  final bool isFullScreen;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: widget.controller.value.isPlaying && !_visible
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: Center(
              child: Icon(
                widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 50.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _visible = !_visible;
            });
          },
          onDoubleTap: () {
            setState(() {
              widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
            });
          },
        ),
        if (_visible)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(widget.isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen, color: Colors.white),
              onPressed: () async {
                if (widget.isFullScreen) {
                  Navigator.pop(context);
                } else {
                  await _enterFullScreen(context);
                }
                setState(() {});
              },
            ),
          ),
        if (_visible)
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: const Icon(Icons.replay_10, color: Colors.white),
              onPressed: () {
                final currentPosition = widget.controller.value.position;
                widget.controller.seekTo(currentPosition - const Duration(seconds: 10));
              },
            ),
          ),
        if (_visible)
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: const Icon(Icons.forward_10, color: Colors.white),
              onPressed: () {
                final currentPosition = widget.controller.value.position;
                widget.controller.seekTo(currentPosition + const Duration(seconds: 10));
              },
            ),
          ),
      ],
    );
  }

  Future<void> _enterFullScreen(BuildContext context) async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: widget.controller),
      ),
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

class FullScreenVideoPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              VideoPlayer(controller),
              _ControlsOverlay(controller: controller, isFullScreen: true),
              VideoProgressIndicator(controller, allowScrubbing: true),
            ],
          ),
        ),
      ),
    );
  }
}
