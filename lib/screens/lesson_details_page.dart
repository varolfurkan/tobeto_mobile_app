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
  bool _isMuted = false;
  double _currentSliderValue = 0.0;
  double _playbackSpeed = 1.0;
  bool _controlsVisible = true;

  @override
  void initState() {
    super.initState();

    _controllers = widget.lesson.videos.values.expand((videoList) {
      return videoList.map((video) {
        String videoUrl = video['videoUrl'] ?? '';
        return VideoPlayerController.networkUrl(Uri.parse(videoUrl));
      });
    }).toList();

    if (_controllers.isNotEmpty) {
      _initializeVideoPlayerFuture = Future.wait(_controllers.map((controller) => controller.initialize()));
    } else {
      _initializeVideoPlayerFuture = Future.value();
    }

    for (var controller in _controllers) {
      controller.addListener(() {
        setState(() {
          _currentSliderValue = controller.value.position.inMilliseconds.toDouble() /
              controller.value.duration.inMilliseconds.toDouble();
        });
      });
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

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _controllers[_selectedVideoIndex].setVolume(_isMuted ? 0.0 : 1.0);
    });
  }

  void _onSliderChanged(double value) {
    setState(() {
      _currentSliderValue = value;
      final Duration duration = _controllers[_selectedVideoIndex].value.duration!;
      _controllers[_selectedVideoIndex].seekTo(duration * value);
    });
  }

  void _changePlaybackSpeed(double speed) {
    setState(() {
      _playbackSpeed = speed;
      _controllers[_selectedVideoIndex].setPlaybackSpeed(_playbackSpeed);
    });
  }

  void _enterFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenVideoPlayer(controller: _controllers[_selectedVideoIndex]),
      ),
    );

    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controlsVisible = !_controlsVisible;
                                  });
                                },
                                child: VideoPlayer(_controllers[_selectedVideoIndex]),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _controlsVisible = !_controlsVisible;
                                  });
                                },
                                child: AnimatedOpacity(
                                  opacity: _controlsVisible ? 1.0 : 0.0,
                                  duration: const Duration(milliseconds: 300),
                                  child: _ControlsOverlay(
                                    controller: _controllers[_selectedVideoIndex],
                                    toggleMute: _toggleMute,
                                    isMuted: _isMuted,
                                    currentSliderValue: _currentSliderValue,
                                    onSliderChanged: _onSliderChanged,
                                    enterFullScreen: _enterFullScreen,
                                    playbackSpeed: _playbackSpeed,
                                    changePlaybackSpeed: _changePlaybackSpeed,
                                  ),
                                ),
                              ),
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
                            title: Text(lessonTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  const _ControlsOverlay({
    required this.controller,
    required this.toggleMute,
    required this.isMuted,
    required this.currentSliderValue,
    required this.onSliderChanged,
    required this.enterFullScreen,
    required this.playbackSpeed,
    required this.changePlaybackSpeed,
  });

  final VideoPlayerController controller;
  final VoidCallback toggleMute;
  final bool isMuted;
  final double currentSliderValue;
  final ValueChanged<double> onSliderChanged;
  final VoidCallback enterFullScreen;
  final double playbackSpeed;
  final Function(double) changePlaybackSpeed;

  @override
  __ControlsOverlayState createState() => __ControlsOverlayState();
}

class __ControlsOverlayState extends State<_ControlsOverlay> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          color: Colors.black87,
          child: Column(
            children: [
              VideoProgressIndicator(
                widget.controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.red,
                  bufferedColor: Colors.grey,
                ),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        widget.controller.value.isPlaying ? widget.controller.pause() : widget.controller.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white),
                    onPressed: () {
                      final currentPosition = widget.controller.value.position;
                      widget.controller.seekTo(currentPosition - const Duration(seconds: 10));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white),
                    onPressed: () {
                      final currentPosition = widget.controller.value.position;
                      widget.controller.seekTo(currentPosition + const Duration(seconds: 10));
                    },
                  ),
                  IconButton(
                    icon: Icon(widget.isMuted ? Icons.volume_off : Icons.volume_up, color: Colors.white),
                    onPressed: widget.toggleMute,
                  ),
                  PopupMenuButton<double>(
                    initialValue: widget.playbackSpeed,
                    onSelected: widget.changePlaybackSpeed,
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<double>>[
                      const PopupMenuItem<double>(
                        value: 0.5,
                        child: Text('0.5x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 0.75,
                        child: Text('0.75x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 1.0,
                        child: Text('1x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 1.25,
                        child: Text('1.25x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 1.5,
                        child: Text('1.5x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 1.75,
                        child: Text('1.75x'),
                      ),
                      const PopupMenuItem<double>(
                        value: 2.0,
                        child: Text('2x'),
                      ),
                    ],
                    child: Text('${widget.playbackSpeed}x', style: const TextStyle(color: Colors.white)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.fullscreen, color: Colors.white),
                    onPressed: widget.enterFullScreen,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideoPlayer({Key? key, required this.controller}) : super(key: key);

  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  bool _controlsVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: widget.controller.value.aspectRatio,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controlsVisible = !_controlsVisible;
                  });
                },
                child: VideoPlayer(widget.controller),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controlsVisible = !_controlsVisible;
                  });
                },
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: _ControlsOverlay(
                    controller: widget.controller,
                    toggleMute: () {},
                    isMuted: false,
                    currentSliderValue: 0.0,
                    onSliderChanged: (double value) {},
                    enterFullScreen: () {
                      Navigator.pop(context);
                    },
                    playbackSpeed: 1.0,
                    changePlaybackSpeed: (double speed) {},
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
