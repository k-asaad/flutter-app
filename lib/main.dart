import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

// Add this import for platformViewRegistry
import 'dart:ui_web' as ui_web;

void main() {
  runApp(
    DevicePreview(
        builder: (context) =>
            MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Website App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PlatformAwareWebView(),
    );
  }
}

class PlatformAwareWebView extends StatelessWidget {
  const PlatformAwareWebView({super.key});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // For web browsers - show iframe inside the app
      return const WebBrowserView();
    } else {
      // For Android/iOS - show WebView
      return const WebViewScreen();
    }
  }
}

class WebBrowserView extends StatefulWidget {
  const WebBrowserView({super.key});

  @override
  State<WebBrowserView> createState() => _WebBrowserViewState();
}

class _WebBrowserViewState extends State<WebBrowserView> {
  @override
  void initState() {
    super.initState();
    // Register the iframe view - use ui_web instead of ui
    ui_web.platformViewRegistry.registerViewFactory(
      'iframe-view',
          (int viewId) => html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = 'https://app.edulevel.ai'
        ..style.border = 'none'
        ..allow = 'camera; microphone; geolocation'
        ..allowFullscreen = true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduLevel App')),
      body: const HtmlElementView(viewType: 'iframe-view'),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse('https://app.edulevel.ai'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduLevel App')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
