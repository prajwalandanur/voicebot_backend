import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart'; // For using basename
import 'audio_recorder_ui.dart';

void main() => runApp(MaterialApp(home: AudioRecorder()));

class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  String _filePath = '/storage/emulated/0/Download/audio_recording.wav';
  final String _uploadUrl = 'https://8vfz7zxh-8000.inc1.devtunnels.ms/upload-audio';
  final String _getResponseUrl = 'https://8vfz7zxh-8000.inc1.devtunnels.ms/get-response';
  String? _conversation;
  String? _requestId;
  Timer? _responseTimer;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
  }

  Future<void> _initializeRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await _recorder.openRecorder();
  }

  Future<void> startRecording() async {
    await _recorder.startRecorder(
      toFile: _filePath,
      codec: Codec.pcm16WAV,
    );

    setState(() => isRecording = true);
  }

  Future<void> stopRecording() async {
    await _recorder.stopRecorder();
    setState(() => isRecording = false);

    if (await _requestStoragePermission()) {
      final file = File(_filePath);
      if (await file.exists()) {
        uploadAudioFile(file);
      } else {
        setState(() => _conversation = 'Recording file not found.');
      }
    } else {
      setState(() => _conversation = 'Storage permission denied. Cannot send recording.');
    }
  }

  Future<void> uploadAudioFile(File file) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      request.files.add(await http.MultipartFile.fromPath(
        'audio',
        file.path,
        filename: basename(file.path), // Keep the original filename
      ));
      setState(() => _conversation = 'Uploading recording...');
      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);

        // Display "You: " transcription
        String userTranscription = jsonResponse['You'];
        _requestId = jsonResponse['request_id'];
        setState(() => _conversation = "You: $userTranscription");

        // Start fetching the bot's response
        if (_requestId != null) {
          _startFetchingResponse(_requestId!);
        }
      } else {
        setState(() => _conversation = 'Failed to upload recording. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _conversation = 'Error uploading recording: $e');
    }
  }

void _startFetchingResponse(String requestId) {
  _responseTimer?.cancel(); // Cancel any previous timer
  final player = AudioPlayer(); // Keep a single instance of AudioPlayer
  
  _responseTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
    try {
      final response = await http.get(Uri.parse('$_getResponseUrl/$requestId'));

      if (response.statusCode == 200) {
        // Stop any ongoing audio playback before starting a new one
        if (player.playing) {
          await player.stop();
        }

        // Handle MP3 file playback
        await player.setUrl('$_getResponseUrl/$requestId');
        await player.play();
        
        setState(() => _conversation = "$_conversation\nBot: Audio response played.");
        _responseTimer?.cancel(); // Stop the timer once the response is received
      } else if (response.statusCode == 202) {
        setState(() => _conversation = "$_conversation\nBot: Processing...");
      } else {
        setState(() => _conversation = "$_conversation\nFailed to fetch response.");
        _responseTimer?.cancel();
      }
    } catch (e) {
      setState(() => _conversation = "$_conversation\nError fetching response: $e");
      _responseTimer?.cancel();
    }
  });
}


  Future<bool> _requestStoragePermission() async {
    return await Permission.storage.isGranted && await Permission.manageExternalStorage.isGranted;
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _responseTimer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AudioRecorderUI(
      isRecording: isRecording,
      serverResponse: _conversation,
      onStartRecording: startRecording,
      onStopRecording: stopRecording,
    );
  }
}