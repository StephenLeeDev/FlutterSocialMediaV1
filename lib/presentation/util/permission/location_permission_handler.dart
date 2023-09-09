import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A utility class for handling location permission requests and checks.
// NOTE: I don't currently require location permission for this project
// NOTE: I have implemented this as a reference for future development acceleration using this module
class LocationPermissionHandler {
  final String _permissionRequestedKey = 'locationPermissionRequested';

  /// Checks if the location permission has been previously denied.
  /// Returns `true` if permission has been denied, `false` otherwise.
  Future<bool> _hasPermissionDenied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_permissionRequestedKey) ?? false;
  }

  /// Sets a flag to indicate that the location permission has been denied.
  Future<void> _setPermissionDenied() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_permissionRequestedKey, true);
  }

  /// Requests the location permission and handles the permission flow.
  /// Executes [positiveListener] if permission is granted; otherwise, does nothing.
  ///
  /// [context]: The current [BuildContext] for displaying dialogs.
  Future<void> requestLocationPermission({required BuildContext context, required Function positiveListener}) async {
    final LocationPermission permissionStatus = await Geolocator.checkPermission();

    /// Everything has been ready
    /// Just execute [positiveListener]
    if (permissionStatus == LocationPermission.always || permissionStatus == LocationPermission.whileInUse) {
      positiveListener();
    }
    /// Permission is denied, so can't execute [positiveListener]
    /// Proceed requesting permission process first
    else {
      final bool hasPermissionDenied = await _hasPermissionDenied();

      /// If the user denied the permission before, request to the user to go to the setting screen and allow the permission himself or herself
      if (hasPermissionDenied) {
        if (context.mounted) {
          await openSettingDialog(context);
        }
      }
      /// if it's the first running, just request the permission normally
      else {
        final LocationPermission permission = await Geolocator.requestPermission();

        /// Everything has been ready
        /// Just execute [positiveListener]
        if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
          positiveListener();
        }
        /// If the user denied the permission before, request to the user to go to the setting screen and allow the permission himself or herself
        else {
          _setPermissionDenied();
          if (context.mounted) {
            await openSettingDialog(context);
          }
        }
      }
    }
  }

  Future<void> openSettingDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Location Permission Required'),
          content: const Text(
              'Please enable location access in settings to use this feature.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Open Settings'),
              onPressed: () {
                /// Open app settings
                Geolocator.openAppSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
