import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:traewelcross/dialogs/checkin_conflict.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class CheckinApiProvider {
  final ApiService _api;
  CheckinApiProvider(this._api);
  BuildContext? get _context =>
      getIt<GlobalKey<NavigatorState>>().currentState?.context;
  GlobalKey<ScaffoldMessengerState> get _sM =>
      getIt<GlobalKey<ScaffoldMessengerState>>();
  Future<GenericStatusResponseWithObject> checkIn(CheckInRequest cir, {bool? force}) async {
    if (force == true) {
      cir.force = true;
    }
    final response = await _api.request(
      "/trains/checkin",
      .POST,
      body: jsonEncode(cir.toJson()),
    );
    if (response.statusCode == 201) {
      return GenericStatusResponseWithObject(wasSuccess: true, object: CheckinResponse.fromJson(jsonDecode(response.body)["data"]));
    }
    if (response.statusCode == 409) {
      final errorInfo = jsonDecode(response.body)?["message"];
      if (_context?.mounted != true) {
        return GenericStatusResponseWithObject(wasSuccess: false, object: null);
      }
      showDialog(
        context: _context!,
        builder: (ctx) => CheckinConflict(
          forceCallback: () => checkIn(cir, force: true),
          lineName: errorInfo?["lineName"],
          statusID: errorInfo?["status_id"]?.toString(),
        ),
      );
      return GenericStatusResponseWithObject(wasSuccess: false, object: null);
    }
    _sM.currentState?.showMaterialBanner(
      MaterialBanner(
        content: Text(
          "${AppLocalizations.of(_context!)!.genericErrorSnackBar} ${response.statusCode}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (_context?.mounted != true) {
                return;
              }
              ScaffoldMessenger.of(_context!).clearMaterialBanners();
            },

            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
    return GenericStatusResponseWithObject(wasSuccess: false, object: null);
  }
}
