// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navOTM => 'On the move';

  @override
  String get navNotify => 'Notifications';

  @override
  String get navProfile => 'Profile';

  @override
  String get welcome => 'Welcome!';

  @override
  String get introText =>
      'Great that you\'re here! To use this app, you need to link it with your Träwelling account. Use the Button below to do just that. If you don\'t have a Träwelling account yet, you can register one there as well.';

  @override
  String get titleInfo => 'Information';

  @override
  String get viewLicensesBtn => 'View Open-Source Licensens';

  @override
  String licenses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Licenses',
      one: 'License',
      zero: 'Licenses',
    );
    return '$_temp0';
  }

  @override
  String get noLicense => 'No License is available. Sorry.';

  @override
  String get addNotices => 'Additional notices';

  @override
  String get fonts => 'Fonts';

  @override
  String get close => 'Close';

  @override
  String get viewProjectBtn => 'View Project on GitHub';

  @override
  String get viewImprintBtn => 'View Imprint & Privacy Policy';

  @override
  String get addAccountBtn => 'Link Träwelling account';

  @override
  String time_summary(int days, int hours, int minutes) {
    return '${days}d ${hours}h ${minutes}min';
  }

  @override
  String points(String points, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'points',
      one: 'point',
      zero: 'points',
    );
    return '$points $_temp0';
  }

  @override
  String get morePointsNotice =>
      'To collect more points next time, make sure to check in earlier/later. To get the full amount of points, check in while you are träwelling or shortly before you board (up to 60 minutes before).';

  @override
  String get logOut => 'Log out';

  @override
  String get logOutNotice =>
      'You will be logged out, all data will be reset including preferences. Your account (settings) will not be affected';

  @override
  String get abrvHour => 'h';

  @override
  String get abrvDay => 'd';

  @override
  String get abrvMinute => 'min';

  @override
  String get offerAlt =>
      'If, after the authorization, this app didn\'t automatically open again, please press the button below. If it did, please wait up to 3 seconds to let it process your request. Depending on your network speed, this might take a bit longer';

  @override
  String get altLoginBtn => 'Use alternative';

  @override
  String get noModifcationAllowed => 'You are not allowed to edit this!';

  @override
  String get noModifcationAllowedGeneric => 'You are not allowed to do this!';

  @override
  String get statusNotFound =>
      'This status does not exist, make sure it\'s not deleted!';

  @override
  String get rateLimit => 'You are too fast. Slow down';

  @override
  String get genericErrorSnackBar => 'Oops! That didn\'t work:';

  @override
  String get notLikeable => 'Sorry, you can\'t like this status!';

  @override
  String get share => 'Share';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get join_ride => 'Join Ride';

  @override
  String get report => 'Report';

  @override
  String likes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'likes',
      one: 'like',
      zero: 'likes',
    );
    return '$_temp0';
  }

  @override
  String privateOrBlocked(String username) {
    return 'Sorry, you can\'t view this profile. This is either because @$username blocked you (or you blocked them), or put their profile on private. If you want, you can send a follow request.';
  }

  @override
  String get followRequest => 'Send a follow request';

  @override
  String get alreadyFollowRequest => 'You already sent a follow request';

  @override
  String get followRequestSent => 'Follow request sent!';

  @override
  String followingSnack(String username) {
    return 'You are now following @$username!';
  }

  @override
  String get followFailBlocked =>
      'This user blocked you or you blocked them. You can\'t follow them.';

  @override
  String get acceptFollowTooltip => 'Accept follow request';

  @override
  String get denyFollowTooltip => 'Deny follow request';

  @override
  String get remove => 'Remove';

  @override
  String get requestNotFound => 'This follow request doesn\'t exist (anymore)';

  @override
  String get userNotFoundSnack => 'This user does not exist';

  @override
  String get muteOrBlockUser => 'Mute/Block';

  @override
  String get mutedUser => 'Muted';

  @override
  String get blockedUser => 'Blocked';

  @override
  String get unfollowUser => 'Unfollow';

  @override
  String get followUser => 'Follow';

  @override
  String get muteOrBlockHeader => 'Would you like to block or mute this user?';

  @override
  String get blockConfirm => 'Yes, block them';

  @override
  String get muteConfirm => 'Mute them instead';

  @override
  String get cancelMuteBlock => 'Don\'t do anything';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get blockFinalConfirm =>
      'Please note that as of now, unblocking isn\'t possible in Traewelcross.';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get unmuteUser => 'Unmute';

  @override
  String get loading => 'Loading...';

  @override
  String get rideNotFound => 'Ride not found';

  @override
  String get statusDeletedSuccessful => 'Status successfully deleted!';

  @override
  String get editStatus => 'Edit Status';

  @override
  String get checkIn => 'Check-In';

  @override
  String get statusText => 'Status';

  @override
  String get privateTrip => 'Personal';

  @override
  String get commuteTrip => 'Commute';

  @override
  String get businessTrip => 'Business';

  @override
  String get private => 'Private';

  @override
  String get notListed => 'Unlisted';

  @override
  String get followerOnly => 'Follower Only';

  @override
  String get public => 'Public';

  @override
  String get loggedInUsers => 'Verified Users';

  @override
  String get addEvent => 'Add Event';

  @override
  String get noEventsFound =>
      'No events have been found for the timeframe of the ride';

  @override
  String get deselectEvent => 'No event';

  @override
  String get deselectEventSubtitle =>
      'Do not associate an event with this ride';

  @override
  String get selectEventBoxTitle => 'Select an event';

  @override
  String get overrideDepartTime => 'Overridden departure time';

  @override
  String get overrideArriveTime => 'Overridden arrival time';

  @override
  String get now => 'Now';

  @override
  String get checkInOtherUsers => 'Add other users';

  @override
  String get noTrustedUsers => 'Nobody has allowed for you to check them in';

  @override
  String get checkInOtherUsersTitle => 'Select users to check-in';

  @override
  String operatedBy(String operator) {
    return 'Operated By:\n$operator';
  }

  @override
  String checkedInWith(String client) {
    return 'Checked in with:\n$client';
  }

  @override
  String get homeCheckInPlaceholder =>
      'Find Stop (via Name or RIL 100) or @user';

  @override
  String get stops => 'Stops';

  @override
  String get users => 'Users';

  @override
  String get locationDisabled =>
      'Location services are disabled on your device. You can\'t use this feature';

  @override
  String get locationNotAllowed =>
      'You didn\'t allow Träwelcross to access your position';

  @override
  String get locationDenyForever => 'Open Settings to allow GPS access?';

  @override
  String departuresFrom(String stop) {
    return 'Departures from: $stop';
  }

  @override
  String platformAbrv(String platform) {
    return 'Pl. $platform';
  }

  @override
  String startsAtDifferentStop(String stop) {
    return 'From: $stop';
  }

  @override
  String get suburban => 'Suburban';

  @override
  String get regional => 'Regional';

  @override
  String get national => 'Express';

  @override
  String get subway => 'Subway';

  @override
  String get tram => 'Tram';

  @override
  String get bus => 'Bus';

  @override
  String get ferry => 'Ferry';

  @override
  String get noRidesFound =>
      'No rides available at this time with this mode of transportation';

  @override
  String get earlier => 'Earlier';

  @override
  String get later => 'Later';

  @override
  String newHomeSuccessful(String station) {
    return 'Successfully set $station as home';
  }

  @override
  String get postOnFediverse => 'Share ride on Mastodon';

  @override
  String get attachToLastToot => 'Attach to last toot';

  @override
  String get save => 'Save';

  @override
  String get checkInSuccessful => 'You are Träwelling!';

  @override
  String get alsoOnThisConnection => 'Also in this connection';

  @override
  String get changeDestination => 'Change Destination';

  @override
  String get geoLocationTookTooLong =>
      'Hm, seems like we can\'t locate you right now, or there is no station near you!';

  @override
  String get reportBoxTitle => 'Report status';

  @override
  String get reportBoxReportReason => 'Reason:';

  @override
  String get reportBoxReportReasonInappropriate => 'Inappropriate';

  @override
  String get reportBoxReportReasonImplausible => 'Implausible';

  @override
  String get reportBoxReportReasonSpam => 'Spam';

  @override
  String get reportBoxReportReasonIllegal => 'Illegal';

  @override
  String get reportBoxReportReasonOther => 'Other';

  @override
  String get reportBoxDescriptionTitle => 'Description:';

  @override
  String get reportCancel => 'Cancel';

  @override
  String get reportConfirm => 'Report!';

  @override
  String get reportSending => 'Submitting your report...';

  @override
  String get reportSuccess => 'Your report has been submitted!';

  @override
  String get tagTipJourneyNumber => 'Journey Number';

  @override
  String get tagTipLocomotiveClass => 'Locomotive Class';

  @override
  String get tagTipPassengerRights => 'Passenger Rights';

  @override
  String get tagTipPrice => 'Price';

  @override
  String get tagTipRole => 'Staff role';

  @override
  String get tagTipSeat => 'Seat';

  @override
  String get tagTipTicket => 'Ticket';

  @override
  String get tagTipTravelClass => 'Travel class';

  @override
  String get tagTipVehicleNumber => 'Vehicle number';

  @override
  String get tagTipWagon => 'Coach';

  @override
  String get tagTipWagonClass => 'Coach class';

  @override
  String get tagTipJourneyNumberExample =>
      'RB 14439, ME 82848, ICE 1081, S 34747';

  @override
  String get tagTipLocomotiveClassExample => 'BR 412, 101, ...';

  @override
  String get tagTipPassengerRightsExample => 'Requested, paid out, ...';

  @override
  String get tagTipPriceExample => '69€';

  @override
  String get tagTipRoleExample => 'Conductor, train manager, ...';

  @override
  String get tagTipSeatExample => '42';

  @override
  String get tagTipTicketExample => 'Interrail, D-Ticket, ...';

  @override
  String get tagTipTravelClassExample => 'First, second, economy, ...';

  @override
  String get tagTipVehicleNumberExample => 'Tz 304, ...';

  @override
  String get tagTipWagonExample => '6';

  @override
  String get tagTipWagonClassExample => 'Avmz, Bimmdzf, ...';

  @override
  String get tagAddTag => 'Add Tag';

  @override
  String tagUnknownTip(String tagKey) {
    return 'Unknown Tag ($tagKey)';
  }

  @override
  String get tagNoTagsLeft =>
      'You already added all tags you can add. To edit or delete one, tap on the appropriate tag to do so.';

  @override
  String get settings => 'Settings';

  @override
  String get account => 'Account';

  @override
  String get appearance => 'Appearance';

  @override
  String get behavior => 'Behavior';

  @override
  String get misc => 'Miscellaneous';

  @override
  String get username => 'Username';

  @override
  String get displayName => 'Display name';

  @override
  String get fieldRequired => 'This field is required!';

  @override
  String get fieldNoSpecialChar =>
      'You may only include alphanumeric characters as well as _ and .';

  @override
  String get privateAccount => 'Private account';

  @override
  String get collectPoints => 'Collect points';

  @override
  String get allowLikes => 'Allow likes';

  @override
  String get hideCheckIns => 'Hide Check-Ins after time';

  @override
  String get noOfDaysValid => 'Number of days must be a positive integer.';

  @override
  String get noOfDays => 'Number of days to hide check-in after';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
      zero: 'days',
    );
    return '$_temp0';
  }

  @override
  String get moreSettings => 'More settings';

  @override
  String get moreSettingsSub =>
      'To change things like your profile picture, tap here';

  @override
  String get unsavedChangesTitle => 'Unsaved Changes';

  @override
  String get unsavedChanges =>
      'You might have unsaved changes. Are you sure you want to go back?';

  @override
  String get trustedUsers => 'Trusted Users';

  @override
  String get friends => 'Friends';

  @override
  String get friendsExplanation => 'Friends (Follow each other)';

  @override
  String get noTrustedCheckIn => 'No one';

  @override
  String get trustedUsersSelectTitle => 'Who may check you in?';

  @override
  String get defaultVisibilitySelectTitle =>
      'Who may see your check in by default?';

  @override
  String get mastodonVisibilitySelectTitle =>
      'Who may see your Mastodon posts?';

  @override
  String get setupTrustedUsers => 'Modify Trusted Users';

  @override
  String get bio => 'Bio';

  @override
  String expiresAt(String exp) {
    return 'Expires At: $exp';
  }

  @override
  String get stopTrust => 'Don\'t trust this user anymore';

  @override
  String get addTrust => 'Add User';

  @override
  String get searchUser => 'Search for username';

  @override
  String get shouldTrustExpire => 'Should trusting this user expire?';

  @override
  String get trustExpireWhen => 'When should trusting this user expire?';

  @override
  String get useSystemAccent => 'Use system accent color';

  @override
  String get selectAccent => 'Select accent color:';

  @override
  String get cancel => 'Cancel';

  @override
  String get lightMode => 'Light';

  @override
  String get darkMode => 'Dark';

  @override
  String get systemMode => 'System';

  @override
  String get selectMode => 'Select Design';

  @override
  String get useLineIcons => 'Use custom line icons where available';

  @override
  String get selectMapType => 'What Map overlay should be used?';

  @override
  String get selectMapStandard => 'Standard';

  @override
  String get selectMapSignals => 'Signals';

  @override
  String get selectMapMaxSpeed => 'Max speeds';

  @override
  String userMuted(String username) {
    return 'Sorry, you can\'t view this profile. This is because you muted @$username. If you want, you can unmute them.';
  }

  @override
  String get overrideOnTimeTap =>
      'Time can be directly be overwritten by timestamp';

  @override
  String get overrideOnTimeTapExplain =>
      'You can override departure/arrival times directly by tapping the time stamp.';

  @override
  String get delaySystemTimeOverride => 'Prefill Delay';

  @override
  String get delaySystemTimeOverrideExplain =>
      'The time that needs to pass, that the prefilled time when overriding isn\'t system time, but planned time instead. Leave empty to always use system time. Tap to change.';

  @override
  String get delaySystemTimeOverrideTextField =>
      'Enter a time in minutes. Empty to disable';

  @override
  String get confirmDelete => 'Confirm deletion?';

  @override
  String get confirmDeleteExplain =>
      'If enabled, you are prompted to confirm the deletion.';

  @override
  String get hideManualOnTimeOverride => 'Hide redundant overrides';

  @override
  String get hideManualOnTimeOverrideExplain =>
      'If the manual override is equal to the planned time, it will be displayed as if no override has happend.';

  @override
  String get activateNotifications => 'Enable push notifications?';

  @override
  String get notificationChannelLikes => 'Likes';

  @override
  String get notificationChannelCheckIns => 'Checked in by other user';

  @override
  String get notificationChannelTravelTogether => 'User shares your connection';

  @override
  String get notificationChannelAccount => 'Account related';

  @override
  String get notificationChannelMisc => 'Miscellaneous';

  @override
  String get notificationPreferences => 'Notifications';

  @override
  String get openNotificationSettingsTitle => 'What notifications to receive';

  @override
  String get openNotificationSettingsSub =>
      'Toggle the notifications channels you want active in the system settings';

  @override
  String get bahnExpert => 'Open in bahn.expert';

  @override
  String get defaultTextPreferenceTitle => 'Default Text';

  @override
  String get defaultTextPreferenceSubtitle =>
      'You can choose a text that should be inserted by default when checking in. Tap to change.';

  @override
  String get errorTitle => 'Oh No! :(';

  @override
  String errorText(String errorType, String errorMsg) {
    return 'Snap! While trying to do this: **$errorType**, this error occured: **$errorMsg**.';
  }

  @override
  String get errorDetail => 'Tap here to see the exact error returned';

  @override
  String get errorTroubleshoot =>
      'You may try any of these steps to resolve this problem:';

  @override
  String get errorTypeLogin => 'Logging you in';

  @override
  String get errorTypeHttp => 'HTTP Request';

  @override
  String get errorTypeLoginTroubleshoot =>
      '1. Check if you have internet access\n2. Check if the OAuth2 Token hasn\'t expired\n3. Clear data & login again';

  @override
  String get errorTroubleshootSuffix =>
      'If this error persists, do not hesitate to open an issue on GitHub';

  @override
  String get errorTypeUnknown => 'N/A';

  @override
  String get errorTroubleshootButtonRestart => 'Restart App';

  @override
  String get errorTroubleshootButtonLogout => 'Logout & Reset App';

  @override
  String get errorTroubleshootButtonGithub => 'Open GitHub';

  @override
  String get refreshTokenTitle => 'Refresh Token';

  @override
  String refreshTokenSubtitle(String date) {
    return 'The current token will expire on: $date. Tap here to renew.';
  }

  @override
  String get requestTimeoutMessage =>
      'The server took too long to respond. Therefore, the request has been cancelled.';

  @override
  String get retry => 'Retry';

  @override
  String get noNotificationsAvailable =>
      'You currently don\'t have any notifications';

  @override
  String get authTokenAboutToExpire =>
      'Your auth token is expiring in less than 31 days. Please renew now!';

  @override
  String get renew => 'Renew';

  @override
  String get openExternal => 'Open';

  @override
  String get experimentalPrefrences => 'Experimental';

  @override
  String get stats => 'Statistics';

  @override
  String get statisticsExperimentalNote =>
      'The statistics tab is by no means feature complete or polished. If you still want to look at it, enable this option.';

  @override
  String get volumeBtnCtrl => 'Volume Button Control';

  @override
  String get volumeBtnCtrlNote =>
      'Use basic features using your volume buttons. I.e. when using gloves';

  @override
  String get reloginRequired =>
      'You haven\'t used Träwelcross for 30 days or longer. Since the duration of the authentication tokens are limited, you now need to login again. To prevent that happening in the future, make sure to open Träwelcross at least once every 30 days.';

  @override
  String get fontFamilyChooser => 'Which font to use?';

  @override
  String get systemFont => 'System/Default';

  @override
  String get systemFontDesc =>
      'The font your System uses if available, else Flutter Default (Roboto)';

  @override
  String get outfitFontDesc => 'The default Träwelcross app font';

  @override
  String get nunitoFontDesc => 'Rounded letters ✨';

  @override
  String get iomFontDesc => 'Monospace';

  @override
  String get rubikFontDesc => 'Modern font, a bit more heavy from the start';

  @override
  String get suseFontDesc =>
      'A healthy mix of Sans Serif and Monospace, used for the titles and the Träwelcross icon';

  @override
  String get linefontFontDesc =>
      'It\'s like the doctor gave you a prescription';

  @override
  String get showAltDepStation =>
      'Show connections from other stops in close proximity to the selected one';

  @override
  String get openDysFontDesc => 'Aims to help with symptoms of dyslexia';

  @override
  String get enableOpenDysAtLogin => 'Enable a more dyslexia-friendly font';
}
