import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// Label for home page
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// Label for On-The-Move-Page
  ///
  /// In en, this message translates to:
  /// **'On the move'**
  String get navOTM;

  /// Label for notification page
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotify;

  /// Label for profile page
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// The word welcome
  ///
  /// In en, this message translates to:
  /// **'Welcome!'**
  String get welcome;

  /// Introduction text for on-boarding
  ///
  /// In en, this message translates to:
  /// **'Great that you\'re here! To use this app, you need to link it with your Träwelling account. Use the Button below to do just that. If you don\'t have a Träwelling account yet, you can register one there as well.'**
  String get introText;

  /// Title Bar Heading for app_info.dart
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get titleInfo;

  /// Text for the Button on the AppInfo page to view licenses of used libraries/projects
  ///
  /// In en, this message translates to:
  /// **'View Open-Source Licensens'**
  String get viewLicensesBtn;

  /// The word license (also available pluralized)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Licenses} =1{License} other{Licenses}}'**
  String licenses(int count);

  /// Text to show when License is, for some reason, missing.
  ///
  /// In en, this message translates to:
  /// **'No License is available. Sorry.'**
  String get noLicense;

  /// Additional notices text for license viewer
  ///
  /// In en, this message translates to:
  /// **'Additional notices'**
  String get addNotices;

  /// No description provided for @fonts.
  ///
  /// In en, this message translates to:
  /// **'Fonts'**
  String get fonts;

  /// The word close
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Text AppInfo Button, GitHub
  ///
  /// In en, this message translates to:
  /// **'View Project on GitHub'**
  String get viewProjectBtn;

  /// Text AppInfo Button, Legal
  ///
  /// In en, this message translates to:
  /// **'View Imprint & Privacy Policy'**
  String get viewImprintBtn;

  /// Login Button text
  ///
  /// In en, this message translates to:
  /// **'Link Träwelling account'**
  String get addAccountBtn;

  /// Zeigt eine zusammengefasste Zeit an
  ///
  /// In en, this message translates to:
  /// **'{days}d {hours}h {minutes}min'**
  String time_summary(int days, int hours, int minutes);

  /// The word point (also available pluralized)
  ///
  /// In en, this message translates to:
  /// **'{points} {count, plural, =0{points} =1{point} other{points}}'**
  String points(String points, int count);

  /// No description provided for @morePointsNotice.
  ///
  /// In en, this message translates to:
  /// **'To collect more points next time, make sure to check in earlier/later. To get the full amount of points, check in while you are träwelling or shortly before you board (up to 60 minutes before).'**
  String get morePointsNotice;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log out'**
  String get logOut;

  /// No description provided for @logOutNotice.
  ///
  /// In en, this message translates to:
  /// **'You will be logged out, all data will be reset including preferences. Your account (settings) will not be affected'**
  String get logOutNotice;

  /// The abbreviation for hour(s)
  ///
  /// In en, this message translates to:
  /// **'h'**
  String get abrvHour;

  /// The abbreviation for day(s)
  ///
  /// In en, this message translates to:
  /// **'d'**
  String get abrvDay;

  /// The abbreviation for minute(s)
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get abrvMinute;

  /// Offer desktop auth to mobile
  ///
  /// In en, this message translates to:
  /// **'If, after the authorization, this app didn\'t automatically open again, please press the button below. If it did, please wait up to 3 seconds to let it process your request. Depending on your network speed, this might take a bit longer'**
  String get offerAlt;

  /// Button for manually open alternative login
  ///
  /// In en, this message translates to:
  /// **'Use alternative'**
  String get altLoginBtn;

  /// Snackbar text to display when editing fails due to permissions
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to edit this!'**
  String get noModifcationAllowed;

  /// Snackbar text to display when something fails due to permissions
  ///
  /// In en, this message translates to:
  /// **'You are not allowed to do this!'**
  String get noModifcationAllowedGeneric;

  /// Snackbar text to display when editing fails due to wrong status id
  ///
  /// In en, this message translates to:
  /// **'This status does not exist, make sure it\'s not deleted!'**
  String get statusNotFound;

  /// Snackbar text to display when rate limit
  ///
  /// In en, this message translates to:
  /// **'You are too fast. Slow down'**
  String get rateLimit;

  /// Snackbar text to display when error is unkown
  ///
  /// In en, this message translates to:
  /// **'Oops! That didn\'t work:'**
  String get genericErrorSnackBar;

  /// Snackbar text to display when isLikable is false for whatever reason
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can\'t like this status!'**
  String get notLikeable;

  /// share
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// edit
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Text for when a user wants to copy another users checkin
  ///
  /// In en, this message translates to:
  /// **'Join Ride'**
  String get join_ride;

  /// report
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// The word likes (also available pluralized)
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{likes} =1{like} other{likes}}'**
  String likes(int count);

  /// error 403
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can\'t view this profile. This is either because @{username} blocked you (or you blocked them), or put their profile on private. If you want, you can send a follow request.'**
  String privateOrBlocked(String username);

  ///
  ///
  /// In en, this message translates to:
  /// **'Send a follow request'**
  String get followRequest;

  /// No description provided for @alreadyFollowRequest.
  ///
  /// In en, this message translates to:
  /// **'You already sent a follow request'**
  String get alreadyFollowRequest;

  ///
  ///
  /// In en, this message translates to:
  /// **'Follow request sent!'**
  String get followRequestSent;

  /// No description provided for @followingSnack.
  ///
  /// In en, this message translates to:
  /// **'You are now following @{username}!'**
  String followingSnack(String username);

  ///
  ///
  /// In en, this message translates to:
  /// **'This user blocked you or you blocked them. You can\'t follow them.'**
  String get followFailBlocked;

  /// No description provided for @acceptFollowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Accept follow request'**
  String get acceptFollowTooltip;

  /// No description provided for @denyFollowTooltip.
  ///
  /// In en, this message translates to:
  /// **'Deny follow request'**
  String get denyFollowTooltip;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @requestNotFound.
  ///
  /// In en, this message translates to:
  /// **'This follow request doesn\'t exist (anymore)'**
  String get requestNotFound;

  /// No description provided for @userNotFoundSnack.
  ///
  /// In en, this message translates to:
  /// **'This user does not exist'**
  String get userNotFoundSnack;

  /// No description provided for @muteOrBlockUser.
  ///
  /// In en, this message translates to:
  /// **'Mute/Block'**
  String get muteOrBlockUser;

  /// No description provided for @mutedUser.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get mutedUser;

  /// No description provided for @blockedUser.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blockedUser;

  /// No description provided for @unfollowUser.
  ///
  /// In en, this message translates to:
  /// **'Unfollow'**
  String get unfollowUser;

  /// No description provided for @followUser.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get followUser;

  /// No description provided for @muteOrBlockHeader.
  ///
  /// In en, this message translates to:
  /// **'Would you like to block or mute this user?'**
  String get muteOrBlockHeader;

  /// No description provided for @blockConfirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, block them'**
  String get blockConfirm;

  /// No description provided for @muteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mute them instead'**
  String get muteConfirm;

  /// No description provided for @cancelMuteBlock.
  ///
  /// In en, this message translates to:
  /// **'Don\'t do anything'**
  String get cancelMuteBlock;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @blockFinalConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please note that as of now, unblocking isn\'t possible in Traewelcross.'**
  String get blockFinalConfirm;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @unmuteUser.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmuteUser;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @rideNotFound.
  ///
  /// In en, this message translates to:
  /// **'Ride not found'**
  String get rideNotFound;

  /// No description provided for @statusDeletedSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Status successfully deleted!'**
  String get statusDeletedSuccessful;

  /// No description provided for @editStatus.
  ///
  /// In en, this message translates to:
  /// **'Edit Status'**
  String get editStatus;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check-In'**
  String get checkIn;

  /// No description provided for @statusText.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusText;

  /// No description provided for @privateTrip.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get privateTrip;

  /// No description provided for @commuteTrip.
  ///
  /// In en, this message translates to:
  /// **'Commute'**
  String get commuteTrip;

  /// No description provided for @businessTrip.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get businessTrip;

  /// Visibility = private, only for logged in user
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @notListed.
  ///
  /// In en, this message translates to:
  /// **'Unlisted'**
  String get notListed;

  /// No description provided for @followerOnly.
  ///
  /// In en, this message translates to:
  /// **'Follower Only'**
  String get followerOnly;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @loggedInUsers.
  ///
  /// In en, this message translates to:
  /// **'Verified Users'**
  String get loggedInUsers;

  /// No description provided for @addEvent.
  ///
  /// In en, this message translates to:
  /// **'Add Event'**
  String get addEvent;

  /// No description provided for @noEventsFound.
  ///
  /// In en, this message translates to:
  /// **'No events have been found for the timeframe of the ride'**
  String get noEventsFound;

  /// No description provided for @deselectEvent.
  ///
  /// In en, this message translates to:
  /// **'No event'**
  String get deselectEvent;

  /// No description provided for @deselectEventSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Do not associate an event with this ride'**
  String get deselectEventSubtitle;

  /// No description provided for @selectEventBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Select an event'**
  String get selectEventBoxTitle;

  /// No description provided for @overrideDepartTime.
  ///
  /// In en, this message translates to:
  /// **'Overridden departure time'**
  String get overrideDepartTime;

  /// No description provided for @overrideArriveTime.
  ///
  /// In en, this message translates to:
  /// **'Overridden arrival time'**
  String get overrideArriveTime;

  /// No description provided for @now.
  ///
  /// In en, this message translates to:
  /// **'Now'**
  String get now;

  /// No description provided for @checkInOtherUsers.
  ///
  /// In en, this message translates to:
  /// **'Add other users'**
  String get checkInOtherUsers;

  /// No description provided for @noTrustedUsers.
  ///
  /// In en, this message translates to:
  /// **'Nobody has allowed for you to check them in'**
  String get noTrustedUsers;

  /// No description provided for @checkInOtherUsersTitle.
  ///
  /// In en, this message translates to:
  /// **'Select users to check-in'**
  String get checkInOtherUsersTitle;

  /// No description provided for @operatedBy.
  ///
  /// In en, this message translates to:
  /// **'Operated By:\n{operator}'**
  String operatedBy(String operator);

  /// No description provided for @checkedInWith.
  ///
  /// In en, this message translates to:
  /// **'Checked in with:\n{client}'**
  String checkedInWith(String client);

  /// The next the gets displayed in the top most card on the Homepage
  ///
  /// In en, this message translates to:
  /// **'Find Stop (via Name or RIL 100) or @user'**
  String get homeCheckInPlaceholder;

  /// The general word for the place where public transport holds to pick-up passengers
  ///
  /// In en, this message translates to:
  /// **'Stops'**
  String get stops;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @locationDisabled.
  ///
  /// In en, this message translates to:
  /// **'Location services are disabled on your device. You can\'t use this feature'**
  String get locationDisabled;

  /// No description provided for @locationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'You didn\'t allow Träwelcross to access your position'**
  String get locationNotAllowed;

  /// No description provided for @locationDenyForever.
  ///
  /// In en, this message translates to:
  /// **'Open Settings to allow GPS access?'**
  String get locationDenyForever;

  /// No description provided for @departuresFrom.
  ///
  /// In en, this message translates to:
  /// **'Departures from: {stop}'**
  String departuresFrom(String stop);

  /// Prefix for the displayed platform
  ///
  /// In en, this message translates to:
  /// **'Pl. {platform}'**
  String platformAbrv(String platform);

  /// Displays when connection starts at diffrent stop than selected
  ///
  /// In en, this message translates to:
  /// **'From: {stop}'**
  String startsAtDifferentStop(String stop);

  /// No description provided for @suburban.
  ///
  /// In en, this message translates to:
  /// **'Suburban'**
  String get suburban;

  /// No description provided for @regional.
  ///
  /// In en, this message translates to:
  /// **'Regional'**
  String get regional;

  /// No description provided for @national.
  ///
  /// In en, this message translates to:
  /// **'Express'**
  String get national;

  /// No description provided for @subway.
  ///
  /// In en, this message translates to:
  /// **'Subway'**
  String get subway;

  /// No description provided for @tram.
  ///
  /// In en, this message translates to:
  /// **'Tram'**
  String get tram;

  /// No description provided for @bus.
  ///
  /// In en, this message translates to:
  /// **'Bus'**
  String get bus;

  /// No description provided for @ferry.
  ///
  /// In en, this message translates to:
  /// **'Ferry'**
  String get ferry;

  /// No description provided for @noRidesFound.
  ///
  /// In en, this message translates to:
  /// **'No rides available at this time with this mode of transportation'**
  String get noRidesFound;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get earlier;

  /// No description provided for @later.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// No description provided for @newHomeSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Successfully set {station} as home'**
  String newHomeSuccessful(String station);

  /// No description provided for @postOnFediverse.
  ///
  /// In en, this message translates to:
  /// **'Share ride on Mastodon'**
  String get postOnFediverse;

  /// No description provided for @attachToLastToot.
  ///
  /// In en, this message translates to:
  /// **'Attach to last toot'**
  String get attachToLastToot;

  /// Confirm text for saving ride on edit
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @checkInSuccessful.
  ///
  /// In en, this message translates to:
  /// **'You are Träwelling!'**
  String get checkInSuccessful;

  /// No description provided for @alsoOnThisConnection.
  ///
  /// In en, this message translates to:
  /// **'Also in this connection'**
  String get alsoOnThisConnection;

  /// No description provided for @changeDestination.
  ///
  /// In en, this message translates to:
  /// **'Change Destination'**
  String get changeDestination;

  /// No description provided for @geoLocationTookTooLong.
  ///
  /// In en, this message translates to:
  /// **'Hm, seems like we can\'t locate you right now, or there is no station near you!'**
  String get geoLocationTookTooLong;

  /// No description provided for @reportBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Report status'**
  String get reportBoxTitle;

  /// No description provided for @reportBoxReportReason.
  ///
  /// In en, this message translates to:
  /// **'Reason:'**
  String get reportBoxReportReason;

  /// No description provided for @reportBoxReportReasonInappropriate.
  ///
  /// In en, this message translates to:
  /// **'Inappropriate'**
  String get reportBoxReportReasonInappropriate;

  /// No description provided for @reportBoxReportReasonImplausible.
  ///
  /// In en, this message translates to:
  /// **'Implausible'**
  String get reportBoxReportReasonImplausible;

  /// No description provided for @reportBoxReportReasonSpam.
  ///
  /// In en, this message translates to:
  /// **'Spam'**
  String get reportBoxReportReasonSpam;

  /// No description provided for @reportBoxReportReasonIllegal.
  ///
  /// In en, this message translates to:
  /// **'Illegal'**
  String get reportBoxReportReasonIllegal;

  /// No description provided for @reportBoxReportReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get reportBoxReportReasonOther;

  /// No description provided for @reportBoxDescriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get reportBoxDescriptionTitle;

  /// No description provided for @reportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get reportCancel;

  /// No description provided for @reportConfirm.
  ///
  /// In en, this message translates to:
  /// **'Report!'**
  String get reportConfirm;

  /// No description provided for @reportSending.
  ///
  /// In en, this message translates to:
  /// **'Submitting your report...'**
  String get reportSending;

  /// No description provided for @reportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your report has been submitted!'**
  String get reportSuccess;

  /// No description provided for @tagTipJourneyNumber.
  ///
  /// In en, this message translates to:
  /// **'Journey Number'**
  String get tagTipJourneyNumber;

  /// No description provided for @tagTipLocomotiveClass.
  ///
  /// In en, this message translates to:
  /// **'Locomotive Class'**
  String get tagTipLocomotiveClass;

  /// No description provided for @tagTipPassengerRights.
  ///
  /// In en, this message translates to:
  /// **'Passenger Rights'**
  String get tagTipPassengerRights;

  /// No description provided for @tagTipPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get tagTipPrice;

  /// No description provided for @tagTipRole.
  ///
  /// In en, this message translates to:
  /// **'Staff role'**
  String get tagTipRole;

  /// No description provided for @tagTipSeat.
  ///
  /// In en, this message translates to:
  /// **'Seat'**
  String get tagTipSeat;

  /// No description provided for @tagTipTicket.
  ///
  /// In en, this message translates to:
  /// **'Ticket'**
  String get tagTipTicket;

  /// No description provided for @tagTipTravelClass.
  ///
  /// In en, this message translates to:
  /// **'Travel class'**
  String get tagTipTravelClass;

  /// No description provided for @tagTipVehicleNumber.
  ///
  /// In en, this message translates to:
  /// **'Vehicle number'**
  String get tagTipVehicleNumber;

  /// No description provided for @tagTipWagon.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get tagTipWagon;

  /// No description provided for @tagTipWagonClass.
  ///
  /// In en, this message translates to:
  /// **'Coach class'**
  String get tagTipWagonClass;

  /// No description provided for @tagTipJourneyNumberExample.
  ///
  /// In en, this message translates to:
  /// **'RB 14439, ME 82848, ICE 1081, S 34747'**
  String get tagTipJourneyNumberExample;

  /// No description provided for @tagTipLocomotiveClassExample.
  ///
  /// In en, this message translates to:
  /// **'BR 412, 101, ...'**
  String get tagTipLocomotiveClassExample;

  /// No description provided for @tagTipPassengerRightsExample.
  ///
  /// In en, this message translates to:
  /// **'Requested, paid out, ...'**
  String get tagTipPassengerRightsExample;

  /// No description provided for @tagTipPriceExample.
  ///
  /// In en, this message translates to:
  /// **'69€'**
  String get tagTipPriceExample;

  /// No description provided for @tagTipRoleExample.
  ///
  /// In en, this message translates to:
  /// **'Conductor, train manager, ...'**
  String get tagTipRoleExample;

  /// No description provided for @tagTipSeatExample.
  ///
  /// In en, this message translates to:
  /// **'42'**
  String get tagTipSeatExample;

  /// No description provided for @tagTipTicketExample.
  ///
  /// In en, this message translates to:
  /// **'Interrail, D-Ticket, ...'**
  String get tagTipTicketExample;

  /// No description provided for @tagTipTravelClassExample.
  ///
  /// In en, this message translates to:
  /// **'First, second, economy, ...'**
  String get tagTipTravelClassExample;

  /// No description provided for @tagTipVehicleNumberExample.
  ///
  /// In en, this message translates to:
  /// **'Tz 304, ...'**
  String get tagTipVehicleNumberExample;

  /// No description provided for @tagTipWagonExample.
  ///
  /// In en, this message translates to:
  /// **'6'**
  String get tagTipWagonExample;

  /// No description provided for @tagTipWagonClassExample.
  ///
  /// In en, this message translates to:
  /// **'Avmz, Bimmdzf, ...'**
  String get tagTipWagonClassExample;

  /// No description provided for @tagAddTag.
  ///
  /// In en, this message translates to:
  /// **'Add Tag'**
  String get tagAddTag;

  /// No description provided for @tagUnknownTip.
  ///
  /// In en, this message translates to:
  /// **'Unknown Tag ({tagKey})'**
  String tagUnknownTip(String tagKey);

  /// No description provided for @tagNoTagsLeft.
  ///
  /// In en, this message translates to:
  /// **'You already added all tags you can add. To edit or delete one, tap on the appropriate tag to do so.'**
  String get tagNoTagsLeft;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @behavior.
  ///
  /// In en, this message translates to:
  /// **'Behavior'**
  String get behavior;

  /// No description provided for @misc.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get misc;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get displayName;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required!'**
  String get fieldRequired;

  /// No description provided for @fieldNoSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'You may only include alphanumeric characters as well as _ and .'**
  String get fieldNoSpecialChar;

  /// No description provided for @privateAccount.
  ///
  /// In en, this message translates to:
  /// **'Private account'**
  String get privateAccount;

  /// No description provided for @collectPoints.
  ///
  /// In en, this message translates to:
  /// **'Collect points'**
  String get collectPoints;

  /// No description provided for @allowLikes.
  ///
  /// In en, this message translates to:
  /// **'Allow likes'**
  String get allowLikes;

  /// No description provided for @hideCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Hide Check-Ins after time'**
  String get hideCheckIns;

  /// No description provided for @noOfDaysValid.
  ///
  /// In en, this message translates to:
  /// **'Number of days must be a positive integer.'**
  String get noOfDaysValid;

  /// No description provided for @noOfDays.
  ///
  /// In en, this message translates to:
  /// **'Number of days to hide check-in after'**
  String get noOfDays;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{days} =1{day} other{days}}'**
  String days(int count);

  /// No description provided for @moreSettings.
  ///
  /// In en, this message translates to:
  /// **'More settings'**
  String get moreSettings;

  /// No description provided for @moreSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'To change things like your profile picture, tap here'**
  String get moreSettingsSub;

  /// No description provided for @unsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved Changes'**
  String get unsavedChangesTitle;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'You might have unsaved changes. Are you sure you want to go back?'**
  String get unsavedChanges;

  /// Only selected users may check the user in
  ///
  /// In en, this message translates to:
  /// **'Trusted Users'**
  String get trustedUsers;

  /// If a follower is a followee, they may check the user in
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @friendsExplanation.
  ///
  /// In en, this message translates to:
  /// **'Friends (Follow each other)'**
  String get friendsExplanation;

  /// No one may check the user in
  ///
  /// In en, this message translates to:
  /// **'No one'**
  String get noTrustedCheckIn;

  /// No description provided for @trustedUsersSelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Who may check you in?'**
  String get trustedUsersSelectTitle;

  /// No description provided for @defaultVisibilitySelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Who may see your check in by default?'**
  String get defaultVisibilitySelectTitle;

  /// No description provided for @mastodonVisibilitySelectTitle.
  ///
  /// In en, this message translates to:
  /// **'Who may see your Mastodon posts?'**
  String get mastodonVisibilitySelectTitle;

  /// No description provided for @setupTrustedUsers.
  ///
  /// In en, this message translates to:
  /// **'Modify Trusted Users'**
  String get setupTrustedUsers;

  /// Biography for account
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @expiresAt.
  ///
  /// In en, this message translates to:
  /// **'Expires At: {exp}'**
  String expiresAt(String exp);

  /// No description provided for @stopTrust.
  ///
  /// In en, this message translates to:
  /// **'Don\'t trust this user anymore'**
  String get stopTrust;

  /// Add a new user to trust
  ///
  /// In en, this message translates to:
  /// **'Add User'**
  String get addTrust;

  /// User may search for a user by username
  ///
  /// In en, this message translates to:
  /// **'Search for username'**
  String get searchUser;

  /// No description provided for @shouldTrustExpire.
  ///
  /// In en, this message translates to:
  /// **'Should trusting this user expire?'**
  String get shouldTrustExpire;

  /// No description provided for @trustExpireWhen.
  ///
  /// In en, this message translates to:
  /// **'When should trusting this user expire?'**
  String get trustExpireWhen;

  /// No description provided for @useSystemAccent.
  ///
  /// In en, this message translates to:
  /// **'Use system accent color'**
  String get useSystemAccent;

  /// No description provided for @selectAccent.
  ///
  /// In en, this message translates to:
  /// **'Select accent color:'**
  String get selectAccent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkMode;

  /// No description provided for @systemMode.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemMode;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select Design'**
  String get selectMode;

  /// No description provided for @useLineIcons.
  ///
  /// In en, this message translates to:
  /// **'Use custom line icons where available'**
  String get useLineIcons;

  /// No description provided for @selectMapType.
  ///
  /// In en, this message translates to:
  /// **'What Map overlay should be used?'**
  String get selectMapType;

  /// No description provided for @selectMapStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get selectMapStandard;

  /// No description provided for @selectMapSignals.
  ///
  /// In en, this message translates to:
  /// **'Signals'**
  String get selectMapSignals;

  /// No description provided for @selectMapMaxSpeed.
  ///
  /// In en, this message translates to:
  /// **'Max speeds'**
  String get selectMapMaxSpeed;

  /// error 403
  ///
  /// In en, this message translates to:
  /// **'Sorry, you can\'t view this profile. This is because you muted @{username}. If you want, you can unmute them.'**
  String userMuted(String username);

  /// No description provided for @overrideOnTimeTap.
  ///
  /// In en, this message translates to:
  /// **'Time can be directly be overwritten by timestamp'**
  String get overrideOnTimeTap;

  /// No description provided for @overrideOnTimeTapExplain.
  ///
  /// In en, this message translates to:
  /// **'You can override departure/arrival times directly by tapping the time stamp.'**
  String get overrideOnTimeTapExplain;

  /// No description provided for @delaySystemTimeOverride.
  ///
  /// In en, this message translates to:
  /// **'Prefill Delay'**
  String get delaySystemTimeOverride;

  /// No description provided for @delaySystemTimeOverrideExplain.
  ///
  /// In en, this message translates to:
  /// **'The time that needs to pass, that the prefilled time when overriding isn\'t system time, but planned time instead. Leave empty to always use system time. Tap to change.'**
  String get delaySystemTimeOverrideExplain;

  /// No description provided for @delaySystemTimeOverrideTextField.
  ///
  /// In en, this message translates to:
  /// **'Enter a time in minutes. Empty to disable'**
  String get delaySystemTimeOverrideTextField;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion?'**
  String get confirmDelete;

  /// No description provided for @confirmDeleteExplain.
  ///
  /// In en, this message translates to:
  /// **'If enabled, you are prompted to confirm the deletion.'**
  String get confirmDeleteExplain;

  /// No description provided for @hideManualOnTimeOverride.
  ///
  /// In en, this message translates to:
  /// **'Hide redundant overrides'**
  String get hideManualOnTimeOverride;

  /// No description provided for @hideManualOnTimeOverrideExplain.
  ///
  /// In en, this message translates to:
  /// **'If the manual override is equal to the planned time, it will be displayed as if no override has happend.'**
  String get hideManualOnTimeOverrideExplain;

  /// No description provided for @activateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable push notifications?'**
  String get activateNotifications;

  /// No description provided for @notificationChannelLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get notificationChannelLikes;

  /// No description provided for @notificationChannelCheckIns.
  ///
  /// In en, this message translates to:
  /// **'Checked in by other user'**
  String get notificationChannelCheckIns;

  /// No description provided for @notificationChannelTravelTogether.
  ///
  /// In en, this message translates to:
  /// **'User shares your connection'**
  String get notificationChannelTravelTogether;

  /// No description provided for @notificationChannelAccount.
  ///
  /// In en, this message translates to:
  /// **'Account related'**
  String get notificationChannelAccount;

  /// No description provided for @notificationChannelMisc.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get notificationChannelMisc;

  /// No description provided for @notificationPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationPreferences;

  /// No description provided for @openNotificationSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'What notifications to receive'**
  String get openNotificationSettingsTitle;

  /// No description provided for @openNotificationSettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Toggle the notifications channels you want active in the system settings'**
  String get openNotificationSettingsSub;

  /// No description provided for @bahnExpert.
  ///
  /// In en, this message translates to:
  /// **'Open in bahn.expert'**
  String get bahnExpert;

  /// No description provided for @defaultTextPreferenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Default Text'**
  String get defaultTextPreferenceTitle;

  /// No description provided for @defaultTextPreferenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can choose a text that should be inserted by default when checking in. Tap to change.'**
  String get defaultTextPreferenceSubtitle;

  /// Title for the error page
  ///
  /// In en, this message translates to:
  /// **'Oh No! :('**
  String get errorTitle;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'Snap! While trying to do this: **{errorType}**, this error occured: **{errorMsg}**.'**
  String errorText(String errorType, String errorMsg);

  /// No description provided for @errorDetail.
  ///
  /// In en, this message translates to:
  /// **'Tap here to see the exact error returned'**
  String get errorDetail;

  /// No description provided for @errorTroubleshoot.
  ///
  /// In en, this message translates to:
  /// **'You may try any of these steps to resolve this problem:'**
  String get errorTroubleshoot;

  /// No description provided for @errorTypeLogin.
  ///
  /// In en, this message translates to:
  /// **'Logging you in'**
  String get errorTypeLogin;

  /// No description provided for @errorTypeHttp.
  ///
  /// In en, this message translates to:
  /// **'HTTP Request'**
  String get errorTypeHttp;

  /// No description provided for @errorTypeLoginTroubleshoot.
  ///
  /// In en, this message translates to:
  /// **'1. Check if you have internet access\n2. Check if the OAuth2 Token hasn\'t expired\n3. Clear data & login again'**
  String get errorTypeLoginTroubleshoot;

  /// No description provided for @errorTroubleshootSuffix.
  ///
  /// In en, this message translates to:
  /// **'If this error persists, do not hesitate to open an issue on GitHub'**
  String get errorTroubleshootSuffix;

  /// No description provided for @errorTypeUnknown.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get errorTypeUnknown;

  /// No description provided for @errorTroubleshootButtonRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart App'**
  String get errorTroubleshootButtonRestart;

  /// No description provided for @errorTroubleshootButtonLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout & Reset App'**
  String get errorTroubleshootButtonLogout;

  /// No description provided for @errorTroubleshootButtonGithub.
  ///
  /// In en, this message translates to:
  /// **'Open GitHub'**
  String get errorTroubleshootButtonGithub;

  /// No description provided for @refreshTokenTitle.
  ///
  /// In en, this message translates to:
  /// **'Refresh Token'**
  String get refreshTokenTitle;

  /// No description provided for @refreshTokenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The current token will expire on: {date}. Tap here to renew.'**
  String refreshTokenSubtitle(String date);

  /// No description provided for @requestTimeoutMessage.
  ///
  /// In en, this message translates to:
  /// **'The server took too long to respond. Therefore, the request has been cancelled.'**
  String get requestTimeoutMessage;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @noNotificationsAvailable.
  ///
  /// In en, this message translates to:
  /// **'You currently don\'t have any notifications'**
  String get noNotificationsAvailable;

  /// No description provided for @authTokenAboutToExpire.
  ///
  /// In en, this message translates to:
  /// **'Your auth token is expiring in less than 31 days. Please renew now!'**
  String get authTokenAboutToExpire;

  /// No description provided for @renew.
  ///
  /// In en, this message translates to:
  /// **'Renew'**
  String get renew;

  /// No description provided for @openExternal.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openExternal;

  /// No description provided for @experimentalPrefrences.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimentalPrefrences;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get stats;

  /// No description provided for @statisticsExperimentalNote.
  ///
  /// In en, this message translates to:
  /// **'The statistics tab is by no means feature complete or polished. If you still want to look at it, enable this option.'**
  String get statisticsExperimentalNote;

  /// No description provided for @volumeBtnCtrl.
  ///
  /// In en, this message translates to:
  /// **'Volume Button Control'**
  String get volumeBtnCtrl;

  /// No description provided for @volumeBtnCtrlNote.
  ///
  /// In en, this message translates to:
  /// **'Use basic features using your volume buttons. I.e. when using gloves'**
  String get volumeBtnCtrlNote;

  /// No description provided for @reloginRequired.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t used Träwelcross for 30 days or longer. Since the duration of the authentication tokens are limited, you now need to login again. To prevent that happening in the future, make sure to open Träwelcross at least once every 30 days.'**
  String get reloginRequired;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
