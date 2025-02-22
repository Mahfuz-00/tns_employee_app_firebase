import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../../../Core/Config/Theme/app_colors.dart'; // Import local_auth package
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast

class FingerScanOverlay extends StatefulWidget {
  const FingerScanOverlay({Key? key}) : super(key: key);

  @override
  State<FingerScanOverlay> createState() => _FingerScanOverlayState();
}

class _FingerScanOverlayState extends State<FingerScanOverlay> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isAuthenticated = false;
  String _errorMessage = '';

  // Function to handle biometric authentication
  Future<void> _authenticate() async {
    bool authenticated = false;

    try {
      // Check if biometric authentication is available
      final isAvailable = await _localAuth.canCheckBiometrics;
      if (!isAvailable) {
        setState(() {
          _errorMessage = "Biometric authentication is not available.";
        });
        Fluttertoast.showToast(
          msg: "Biometric authentication is not available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      if (isAvailable) {
        setState(() {
          _errorMessage = "Biometric authentication is available.";
        });
        Fluttertoast.showToast(
          msg: "Biometric authentication is available.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }

      // Attempt to authenticate with biometrics (fingerprint or face)
      authenticated = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        // Reason for authentication
        options: const AuthenticationOptions(
          useErrorDialogs: true, // Show error dialogs if authentication fails
          stickyAuth: true, // Keep authentication session alive
        ),
      );

      setState(() {
        _isAuthenticated = authenticated;
        if (!authenticated) {
          _errorMessage = "Authentication failed!";
        } else {
          _errorMessage = '';
        }
      });

      if (authenticated) {
        // Successfully authenticated
        Fluttertoast.showToast(
          msg: "Authentication Successful!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: AppColors.primary,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        // Authentication failed
        Fluttertoast.showToast(
          msg: "Authentication failed!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          // Show at the top
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Error during authentication: $e";
      });
      Fluttertoast.showToast(
        msg: "Error during authentication: $e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        // Show at the top
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Semi-transparent overlay
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          // Centered content with fingerprint scan option (icon)
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Verify it\'s You',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                        fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'This App requires your fingerprint confirmation',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16.0,
                        color: AppColors.textGrey,
                        fontFamily: 'Roboto'),
                  ),
                  const SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: () {
                      // Do nothing when the icon is tapped
                    },
                    child: const Icon(
                      Icons.fingerprint,
                      size: 45.0,
                      color: AppColors.textNavyBlue,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the overlay
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Fingerprint scan UI at the bottom of the screen
          Positioned(
            bottom: 30,
            left: MediaQuery.of(context).size.width * 0.4,
            child: GestureDetector(
              onTap: _authenticate, // Trigger the fingerprint scan when tapped
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(50.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.fingerprint,
                  size: 40.0,
                  color: AppColors.textNavyBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
