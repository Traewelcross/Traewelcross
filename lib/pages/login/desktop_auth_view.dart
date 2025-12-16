import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:traewelcross/utils/authentication.dart';

class DesktopAuthCallbackView extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const DesktopAuthCallbackView({super.key, required this.onLoginSuccess});

  @override
  State<DesktopAuthCallbackView> createState() =>
      _DesktopAuthCallbackViewState();
}

class _DesktopAuthCallbackViewState extends State<DesktopAuthCallbackView> {
  final AuthService _authService = AuthService();
  String? _errorMessage;
  bool _isLoading = false;

  Future<void> _handleSubmittedUrl() async {
    if (_isLoading) return;

    ClipboardData? url = await Clipboard.getData("text/plain");
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    if (url == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Empty Clipboard!")));
      return;
    }

    try {
      final uri = Uri.parse(url.text!);
      if (!uri.hasQuery || !uri.queryParameters.containsKey('code')) {
        throw const FormatException(
          "This does not look like a valid callback URL. It should contain a 'code=...' part.",
        );
      }

      final client = await _authService.handleAuthorizationResponse(
        uri.queryParameters,
      );

      if (client != null) {
        widget.onLoginSuccess();
        // Pop the view if login is successful and the widget is still mounted.
        if (mounted) {
          Navigator.of(context).pop();
        }
      } else {
        _errorMessage = "Login failed. Please check the URL and try again.";
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
      }
    } on FormatException catch (e) {
      _errorMessage = e.message;
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
    } catch (e) {
      _errorMessage = "An unexpected error occurred: ${e.toString()}";
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(_errorMessage!)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Complete Login")),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "A browser window should have opened. Once you log in and authorize the app, your browser will be redirected. If you are on mobile (and selected this method), you already did this",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Please paste the URL you got from the webpage that opened here",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _isLoading ? null : _handleSubmittedUrl,
                    icon: _isLoading
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text("Paste & Continue"),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
