import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:traewelcross/components/profile_link.dart';
import 'package:traewelcross/enums/http_request_types.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';

class AddTrustedUser extends StatefulWidget {
  const AddTrustedUser({super.key, required this.addCallback});
  final void Function(int user, DateTime? expires) addCallback;

  @override
  State<AddTrustedUser> createState() => _AddTrustedUserState();
}

class _AddTrustedUserState extends State<AddTrustedUser> {
  final _userSearchController = TextEditingController();
  Timer? _debounce;
  List<dynamic> _results = [];
  bool _isLoading = false;
  dynamic _selectedUser;
  bool _trustExpire = false;
  DateTime? _trustExpireDate;

  @override
  void initState() {
    super.initState();
    _userSearchController.addListener(_searchUser);
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _searchUser() {
    if (_selectedUser != null &&
        _userSearchController.text != _selectedUser['username']) {
      setState(() {
        _selectedUser = null;
      });
    }

    _debounce?.cancel();
    final searchTerm = _userSearchController.text.trim();

    if (searchTerm.isEmpty) {
      setState(() {
        _results = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (!mounted || searchTerm != _userSearchController.text.trim()) {
        return;
      }

      final apiService = getIt<ApiService>();
      final response = await apiService.request(
        "/user/search/${Uri.encodeComponent(searchTerm)}",
        HttpRequestTypes.GET,
      );

      if (mounted && searchTerm == _userSearchController.text.trim()) {
        if (response.statusCode == 200) {
          setState(() {
            _results = jsonDecode(response.body)["data"];
            _isLoading = false;
          });
        } else {
          setState(() {
            _results = [];
            _isLoading = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width75 = size.width * 0.75;
    final localize = AppLocalizations.of(context)!;
    final showResults =
        _userSearchController.text.isNotEmpty && _selectedUser == null;

    return AlertDialog(
      icon: const Icon(Icons.person_add),
      title: Text(localize.addTrust),
      content: SizedBox(
        width: width75,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: _userSearchController,
              autofocus: true,
              decoration: InputDecoration(
                icon: const Icon(Icons.search),
                hint: Text(localize.searchUser),
              ),
            ),
            if (showResults)
              SizedBox(
                height: 200,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final user = _results[index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedUser = user;
                                _userSearchController.text = user['username'];
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
                            child: ProfileLink(
                              userData: user,
                              appendUsername: true,
                              enableNavigateToProfile: false,
                            ),
                          );
                        },
                      ),
              ),
            if (_selectedUser != null)
              ListTile(
                leading: const Icon(Icons.access_time),
                title: Text(localize.shouldTrustExpire),
                contentPadding: EdgeInsets.zero,
                onTap: () => setState(() {
                  _trustExpire = !_trustExpire;
                }),
                trailing: Switch(
                  value: _trustExpire,
                  onChanged: (val) => setState(() {
                    _trustExpire = val;
                  }),
                ),
              ),
          ],
        ),
      ),
      actions: [
        Column(
          spacing: 8,
          children: [
            if (_trustExpire)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        _trustExpireDate = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now().add(Duration(days: 1)),
                          lastDate: DateTime.now().add(
                            Duration(days: 365 * 70),
                          ),
                        );
                        setState(() {
                          _trustExpireDate = _trustExpireDate;
                        });
                      },
                      label: Text(
                        _trustExpireDate == null
                            ? localize.trustExpireWhen
                            : localize.expiresAt(
                                DateFormat.yMMMMEEEEd(
                                  Localizations.localeOf(context).languageCode,
                                ).format(_trustExpireDate!),
                              ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _selectedUser == null
                        ? null
                        : () {
                            widget.addCallback(
                              _selectedUser['id'],
                              _trustExpireDate,
                            );
                            Navigator.of(context).pop();
                          },
                    label: Text(localize.addTrust),
                    icon: const Icon(Icons.person_add),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
