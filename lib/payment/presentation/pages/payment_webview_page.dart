import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebViewPage extends StatefulWidget {
  final String url;
  const PaymentWebViewPage({super.key, required this.url});

  @override
  State<PaymentWebViewPage> createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _done = false;
  bool _firstPageLoaded = false;

  @override
  void initState() {
    super.initState();

    final parsedUri = Uri.tryParse(widget.url);
    if (parsedUri == null || !parsedUri.hasScheme) {
      debugPrint("INVALID_URL: ${widget.url}");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) Navigator.of(context).pop(false);
      });
      _controller = WebViewController();
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (url) {
            if (!mounted) return;
            setState(() {
              _loading = false;
              _firstPageLoaded = true;
            });
            _checkResult(url);
          },
          onUrlChange: (change) {
            if (!_firstPageLoaded || change.url == null) return;
            _checkResult(change.url!);
          },
          onNavigationRequest: (request) {
            if (request.url.startsWith('mock://') ||
                request.url.startsWith('yourapp://') ||
                request.url.startsWith('ride-way://')) {
              _checkResult(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            debugPrint("WEBVIEW_ERROR: ${error.description}");
          },
        ),
      )
      ..loadRequest(parsedUri);
  }

  void _checkResult(String url) {
    if (_done) return;
    if (url.isEmpty || url == 'about:blank') return;

    debugPrint("CURRENT_WEBVIEW_URL: $url");

    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return;

    final params = uri.queryParameters;
    final path = uri.path.toLowerCase();
    final host = uri.host.toLowerCase();

    if (host.contains('paymob.com')) {
      debugPrint("PAYMOB_PAGE: skipping check");
      return;
    }

    final isSuccess =
        params['success'] == 'true' ||
        params['status'] == 'success' ||
        path.contains('/payment/success') ||
        path.contains('/callback/success');

    final isFailure =
        params['success'] == 'false' ||
        params['status'] == 'failed' ||
        params['status'] == 'cancelled' ||
        params['status'] == 'declined' ||
        path.contains('/payment/failed') ||
        path.contains('/payment/cancel');

    if (isSuccess) {
      _finish(true);
    } else if (isFailure) {
      _finish(false);
    }
  }

  void _finish(bool success) {
    if (_done || !mounted) return;
    _done = true;

    Navigator.of(context).pop(success);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_done,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_done) _finish(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment WebView'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _finish(false),
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              Container(
                color: Colors.white.withValues(alpha: 0.8),
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
