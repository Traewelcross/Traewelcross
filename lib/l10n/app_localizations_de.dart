// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get navHome => 'Start';

  @override
  String get navOTM => 'Unterwegs';

  @override
  String get navNotify => 'Benachrichtigungen';

  @override
  String get navProfile => 'Profil';

  @override
  String get welcome => 'Willkommen!';

  @override
  String get introText =>
      'Toll, dass du da bist! Um diese App zu nutzen, musst du erst dein Träwelling-Konto dieser App hinzufügen. Nutze den Button unten um genau das zu tun. Wenn du noch kein Träwelling-Konto hast, kannst du dort auch eines erstellen.';

  @override
  String get titleInfo => 'Informationen';

  @override
  String get viewLicensesBtn => 'Open-Source Lizenzen einsehen';

  @override
  String licenses(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lizenzen',
      one: 'Lizenz',
      zero: 'Lizenzen',
    );
    return '$_temp0';
  }

  @override
  String get noLicense => 'Keine Lizenz verfügbar';

  @override
  String get addNotices => 'Weitere Hinweise';

  @override
  String get fonts => 'Schriftarten';

  @override
  String get close => 'Schließen';

  @override
  String get viewProjectBtn => 'Projekt auf GitHub ansehen';

  @override
  String get viewImprintBtn => 'Impressum & Datenschutz';

  @override
  String get addAccountBtn => 'Träwelling-Konto hinzufügen';

  @override
  String time_summary(int days, int hours, int minutes) {
    return '$days T. $hours Std. $minutes Min.';
  }

  @override
  String points(String points, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Punkte',
      one: 'Punkt',
      zero: 'Punkte',
    );
    return '$points $_temp0';
  }

  @override
  String get morePointsNotice =>
      'Um nächstes Mal mehr Punkte zu erhalten, checke pünktlicher ein. Um die volle Anzahl an Punkten zu erhalten, checke ein während du unterwegs bist oder (bis zu 60 Minuten) vorher.';

  @override
  String get logOut => 'Abmelden';

  @override
  String get logOutNotice =>
      'Du wirst abgemeldet und die Einstellungen zurückgesetzt. Dein Account und die damit verbundenen Einstellungen sind nicht betroffen';

  @override
  String get abrvHour => 'Std.';

  @override
  String get abrvDay => 'T.';

  @override
  String get abrvMinute => 'Min.';

  @override
  String get offerAlt =>
      'Wenn nach der Autorisierung Träwelcross nicht automatisch geöffnet wurde, verwende den Button unten. Wenn die App automatisch geöffnet wurde, warte bitte ein wenig, damit die Anfrage verarbeitet werden kann. Das kann, je nach Netzgeschwindigkeit, etwas dauern.';

  @override
  String get altLoginBtn => 'Alternativer Login';

  @override
  String get noModifcationAllowed =>
      'Du bist nicht berechtigt das zu bearbeiten!';

  @override
  String get noModifcationAllowedGeneric =>
      'Du bist nicht berechtigt das zu tun!';

  @override
  String get statusNotFound =>
      'Dieser Status existiert nicht. Stelle sicher, dass er nicht gelöscht ist!';

  @override
  String get rateLimit => 'Du bist zu schnell! Verfahre langsamer.';

  @override
  String get genericErrorSnackBar => 'Ups! Das hat nicht funktioniert:';

  @override
  String get notLikeable => 'Du kannst diesen Status nicht liken!';

  @override
  String get share => 'Teilen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get delete => 'Löschen';

  @override
  String get join_ride => 'Auch einchecken';

  @override
  String get report => 'Melden';

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
    return 'Entschuldige, aber du kannst dieses Profil nicht anschauen. Das kann daran liegen, weil @$username dich blockiert hat (oder du @$username), oder weil das Profil auf Privat ist. Wenn du willst, kannst du versuchen, eine Folgeanfrage zu stellen.';
  }

  @override
  String get followRequest => 'Folgeanfrage stellen';

  @override
  String get alreadyFollowRequest => 'Du hast schon eine Folgeanfrage gestellt';

  @override
  String get followRequestSent => 'Folgeanfrage gestellt!';

  @override
  String followingSnack(String username) {
    return 'Du folgst nun @$username!';
  }

  @override
  String get followFailBlocked =>
      'Diese:r Benutzer:in hat dich geblockt, oder du ihn/sie, daher ist folgen nicht möglich.';

  @override
  String get acceptFollowTooltip => 'Folgeanfrage akzeptieren';

  @override
  String get denyFollowTooltip => 'Folgeanfrage ablehnen';

  @override
  String get remove => 'Entfernen';

  @override
  String get requestNotFound => 'Diese Folgeanfrage existiert nicht (mehr)';

  @override
  String get userNotFoundSnack => 'Diese:r Benutzer:in existiert nicht';

  @override
  String get muteOrBlockUser => 'Stumm schalten/Blocken';

  @override
  String get mutedUser => 'Stumm';

  @override
  String get blockedUser => 'Blockiert';

  @override
  String get unfollowUser => 'Entfolgen';

  @override
  String get followUser => 'Folgen';

  @override
  String get muteOrBlockHeader =>
      'Möchtest du diese:n Benutzer:in blockieren oder stummschalten?';

  @override
  String get blockConfirm => 'Ja, blockieren';

  @override
  String get muteConfirm => 'Stattdessen stumm schalten';

  @override
  String get cancelMuteBlock => 'Nichts tun';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get blockFinalConfirm =>
      'Bitte beachte, dass ein entblocken in Träwelcross nicht möglich ist.';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get unmuteUser => 'Laut schalten';

  @override
  String get loading => 'Laden...';

  @override
  String get rideNotFound => 'Status nicht gefunden';

  @override
  String get statusDeletedSuccessful => 'Status erfolgreich gelöscht!';

  @override
  String get editStatus => 'Status bearbeiten';

  @override
  String get checkIn => 'Check-In';

  @override
  String get statusText => 'Status';

  @override
  String get privateTrip => 'Privat';

  @override
  String get commuteTrip => 'Arbeitsweg';

  @override
  String get businessTrip => 'Geschäftlich';

  @override
  String get private => 'Privat';

  @override
  String get notListed => 'Nicht gelistet';

  @override
  String get followerOnly => 'Nur Follower';

  @override
  String get public => 'Öffentlich';

  @override
  String get loggedInUsers => 'Angemeldete Benutzer:innen';

  @override
  String get addEvent => 'Event hinzufügen';

  @override
  String get noEventsFound =>
      'Keine Events existieren innerhalb des Zeitfensters deiner Reise';

  @override
  String get deselectEvent => 'Kein Event';

  @override
  String get deselectEventSubtitle =>
      'Deine Reise hängt mit keinem Event zusammen';

  @override
  String get selectEventBoxTitle => 'Event auswählen';

  @override
  String get overrideDepartTime => 'Manuelle Abfahrtszeit';

  @override
  String get overrideArriveTime => 'Manuelle Ankunftszeit';

  @override
  String get now => 'Jetzt';

  @override
  String get checkInOtherUsers => 'Weitere Benutzer:innen einchecken';

  @override
  String get noTrustedUsers =>
      'Kein:e Benutzer:in erlaubt es dir sie einzuchecken';

  @override
  String get checkInOtherUsersTitle =>
      'Wähle Benutzer:innen zum einchecken aus';

  @override
  String operatedBy(String operator) {
    return 'Betrieben von:\n$operator';
  }

  @override
  String checkedInWith(String client) {
    return 'Eingecheckt mit:\n$client';
  }

  @override
  String get homeCheckInPlaceholder =>
      'Haltestelle (über Namen oder RIL 100) oder @benutzer finden';

  @override
  String get stops => 'Haltestellen';

  @override
  String get users => 'Benutzer:innen';

  @override
  String get locationDisabled =>
      'Der GPS-Dienst auf deinem Gerät ist deaktivert';

  @override
  String get locationNotAllowed =>
      'Du hast Träwelcross nicht erlaubt auf deinen Standort zuzugreifen';

  @override
  String get locationDenyForever => 'Einstellungen öffnen um GPS zu erlauben?';

  @override
  String departuresFrom(String stop) {
    return 'Abfahrten von: $stop';
  }

  @override
  String platformAbrv(String platform) {
    return 'Gl. $platform';
  }

  @override
  String startsAtDifferentStop(String stop) {
    return 'Ab: $stop';
  }

  @override
  String get suburban => 'S-Bahn';

  @override
  String get regional => 'Regional';

  @override
  String get national => 'Fernverkehr';

  @override
  String get subway => 'U-Bahn';

  @override
  String get tram => 'Tram';

  @override
  String get bus => 'Bus';

  @override
  String get ferry => 'Fähre';

  @override
  String get noRidesFound =>
      'Keine Verbindungen mit diesen Optionen gefunden :(';

  @override
  String get earlier => 'Früher';

  @override
  String get later => 'Später';

  @override
  String newHomeSuccessful(String station) {
    return 'Erfolreich $station als zuhause festgelegt';
  }

  @override
  String get postOnFediverse => 'Auf Mastodon teilen';

  @override
  String get attachToLastToot => 'An letzten Toot anhängen';

  @override
  String get save => 'Speichern';

  @override
  String get checkInSuccessful => 'Erfolgreich eingecheckt!';

  @override
  String get alsoOnThisConnection => 'Auch in deiner Verbindung';

  @override
  String get changeDestination => 'Ziel ändern';

  @override
  String get geoLocationTookTooLong =>
      'Leider kannst du gerade nicht verortet werden, oder keine Station ist in deiner Nähe!';

  @override
  String get reportBoxTitle => 'Status melden';

  @override
  String get reportBoxReportReason => 'Grund:';

  @override
  String get reportBoxReportReasonInappropriate => 'Unangemessen';

  @override
  String get reportBoxReportReasonImplausible => 'Unplausibel';

  @override
  String get reportBoxReportReasonSpam => 'Spam';

  @override
  String get reportBoxReportReasonIllegal => 'Illegal';

  @override
  String get reportBoxReportReasonOther => 'Etwas anderes';

  @override
  String get reportBoxDescriptionTitle => 'Beschreibung:';

  @override
  String get reportCancel => 'Abbrechen';

  @override
  String get reportConfirm => 'Melden!';

  @override
  String get reportSending => 'Deine Bericht wird gesendet...';

  @override
  String get reportSuccess => 'Dein Bericht wurde gesendet!';

  @override
  String get tagTipJourneyNumber => 'Fahrtnummer';

  @override
  String get tagTipLocomotiveClass => 'Baureihe';

  @override
  String get tagTipPassengerRights => 'Fahrgastrechte';

  @override
  String get tagTipPrice => 'Preis';

  @override
  String get tagTipRole => 'Rolle';

  @override
  String get tagTipSeat => 'Sitzplatz';

  @override
  String get tagTipTicket => 'Ticket';

  @override
  String get tagTipTravelClass => 'Reiseklasse';

  @override
  String get tagTipVehicleNumber => 'Fahrzeugnummer';

  @override
  String get tagTipWagon => 'Wagon';

  @override
  String get tagTipWagonClass => 'Wagongattung';

  @override
  String get tagTipJourneyNumberExample =>
      'RB 14439, ME 82848, ICE 1081, S 34747';

  @override
  String get tagTipLocomotiveClassExample => 'BR 412, 101, ...';

  @override
  String get tagTipPassengerRightsExample => 'Angefragt, ausgezahlt, ...';

  @override
  String get tagTipPriceExample => '69€';

  @override
  String get tagTipRoleExample => 'Tf, Zugchef';

  @override
  String get tagTipSeatExample => '42';

  @override
  String get tagTipTicketExample => 'Niedersachsentarif, D-Ticket, ...';

  @override
  String get tagTipTravelClassExample => '1. Klasse, 2. Klasse, ...';

  @override
  String get tagTipVehicleNumberExample => 'Tz 304, ...';

  @override
  String get tagTipWagonExample => '6';

  @override
  String get tagTipWagonClassExample => 'Avmz, Bimmdzf, ...';

  @override
  String get tagAddTag => 'Tag hinzufügen';

  @override
  String tagUnknownTip(String tagKey) {
    return 'Unbekanntes Tag ($tagKey)';
  }

  @override
  String get tagNoTagsLeft =>
      'Du hast bereits alle Tags die du hinzufügen kannst hinzugefügt. Um einen Tag zu löschen/editieren, drücke auf das jeweilige Tag.';

  @override
  String get settings => 'Einstellungen';

  @override
  String get account => 'Konto';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get behavior => 'Verhalten';

  @override
  String get misc => 'Sonstiges';

  @override
  String get username => 'Benutzername';

  @override
  String get displayName => 'Anzeigename';

  @override
  String get fieldRequired => 'Dieses Feld ist auszufüllen!';

  @override
  String get fieldNoSpecialChar =>
      'Du darfst nur Alphanumerischezeichen sowie _ und . verwenden.';

  @override
  String get privateAccount => 'Privates Konto';

  @override
  String get collectPoints => 'Punkte sammeln';

  @override
  String get allowLikes => 'Likes erlauben';

  @override
  String get hideCheckIns => 'Status nach einer Zeit verstecken';

  @override
  String get noOfDaysValid =>
      'Die Anzahl Tage muss eine positive, ganze Zahl sein.';

  @override
  String get noOfDays => 'Tage, nachdem die Status versteckt werden sollen';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
      zero: 'Tage',
    );
    return '$_temp0';
  }

  @override
  String get moreSettings => 'Mehr Einstellungen';

  @override
  String get moreSettingsSub =>
      'Um Dinge wie z.B. dein Profilbild anzupassen, drücke hier';

  @override
  String get unsavedChangesTitle => 'Ungespeicherte Änderungen';

  @override
  String get unsavedChanges =>
      'Du hast evtl. ungespeicherte Änderungen. Bist du sicher, dass zurück willst?';

  @override
  String get trustedUsers => 'Vertraute Benutzer:innen';

  @override
  String get friends => 'Freunde';

  @override
  String get friendsExplanation => 'Freunde (ihr folgt euch gegenseitig)';

  @override
  String get noTrustedCheckIn => 'Keine:r';

  @override
  String get trustedUsersSelectTitle => 'Wer darf dich miteinchecken?';

  @override
  String get defaultVisibilitySelectTitle =>
      'Wer darf deine Status standardmäßig sehen?';

  @override
  String get mastodonVisibilitySelectTitle =>
      'Wer darf deine Mastodon-Posts sehen?';

  @override
  String get setupTrustedUsers => 'Vertraute Benutzer:innen anpassen';

  @override
  String get bio => 'Bio';

  @override
  String expiresAt(String exp) {
    return 'Läuft ab am: $exp';
  }

  @override
  String get stopTrust => 'Benutzer:in nicht mehr vertrauen';

  @override
  String get addTrust => 'Benutzer:in hinzufügen';

  @override
  String get searchUser => 'Benutzer:in suchen';

  @override
  String get shouldTrustExpire => 'Soll das Vertrauen ablaufen?';

  @override
  String get trustExpireWhen => 'Wann soll das Vertrauen ablaufen?';

  @override
  String get useSystemAccent => 'Systemakzent verwenden';

  @override
  String get selectAccent => 'Akzentfarbe auswählen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get lightMode => 'Hell';

  @override
  String get darkMode => 'Dunkel';

  @override
  String get systemMode => 'System';

  @override
  String get selectMode => 'Design auswählen';

  @override
  String get useLineIcons => 'Linienicons anzeigen wenn verfügbar';

  @override
  String get selectMapType =>
      'Welches Kartenoverlaydesign soll angezeigt werden?';

  @override
  String get selectMapStandard => 'Standard';

  @override
  String get selectMapSignals => 'Signale';

  @override
  String get selectMapMaxSpeed => 'Höchstgeschwindigkeiten';

  @override
  String userMuted(String username) {
    return 'Sorry, du kannst dieses Profil nicht anschauen. Das liegt daran, dass @$username stumm geschaltet ist. Entstummen?';
  }

  @override
  String get overrideOnTimeTap => 'Zeit mit Zeitstempel überschreiben';

  @override
  String get overrideOnTimeTapExplain =>
      'Du kannst Ankunft/Abfahrt direkt über tippen auf den Zeitstempel überschreiben.';

  @override
  String get delaySystemTimeOverride => 'Vorausfüllverzögerung';

  @override
  String get delaySystemTimeOverrideExplain =>
      'Die Zeit die verstreichen muss, dass die vorausgefüllte Zeit nicht Systemzeit, sondern die geplante Zeit ist. Leave empty to always use system time. Tippen zum ändern.';

  @override
  String get delaySystemTimeOverrideTextField =>
      'Zeit in Minuten eingeben. Leer zum deaktivieren';

  @override
  String get confirmDelete => 'Löschen bestätigen?';

  @override
  String get confirmDeleteExplain =>
      'Wenn an, wirst du gefragt, ob du den Status wirklich löschen willst.';

  @override
  String get hideManualOnTimeOverride => 'Unnötige Überschreibungen verstecken';

  @override
  String get hideManualOnTimeOverrideExplain =>
      'Wenn die überschriebene Zeit gleich mit der geplanten Zeit ist, wird es so angezeigt, als hätte kein überschreiben stattgefunden';

  @override
  String get activateNotifications => 'Benachrichtigungen aktivieren';

  @override
  String get notificationChannelLikes => 'Likes';

  @override
  String get notificationChannelCheckIns => 'Check-Ins';

  @override
  String get notificationChannelTravelTogether => 'Mit in der Verbindung';

  @override
  String get notificationChannelAccount => 'Account';

  @override
  String get notificationChannelMisc => 'Sonstiges';

  @override
  String get notificationPreferences => 'Benachrichtigungen';

  @override
  String get openNotificationSettingsTitle =>
      'Welche Benachrichtigungen willst du erhalten?';

  @override
  String get openNotificationSettingsSub =>
      'Ändere die Benachrichtigungskanäle in den Einstellungen';

  @override
  String get bahnExpert => 'In bahn.expert öffnen';

  @override
  String get defaultTextPreferenceTitle => 'Standardtext';

  @override
  String get defaultTextPreferenceSubtitle =>
      'Der Text, der standardmäßig eingetragen werden soll, wenn du eincheckst. Zum ändern tippen.';

  @override
  String get errorTitle => 'Oh nein! :(';

  @override
  String errorText(String errorType, String errorMsg) {
    return 'Verdammt! Während versucht wurde: **$errorType**, ist folgendes passiert: **$errorMsg**.';
  }

  @override
  String get errorDetail => 'Tippe hier um den genauen Fehler zu sehen';

  @override
  String get errorTroubleshoot =>
      'Du kannst einen dieser Schritte probieren um das Problem zu lösen:';

  @override
  String get errorTypeLogin => 'Dich einloggen';

  @override
  String get errorTypeHttp => 'HTTP Anfrage';

  @override
  String get errorTypeLoginTroubleshoot =>
      '1. Überprüfe ob du Internet hast\n2. Überprüfe ob der Authentifizierungstoken nicht abgelaufen ist\n3. Zurücksetzen und neu anmelden';

  @override
  String get errorTroubleshootSuffix =>
      'Wenn dieser Fehler bestehen bleibt, scheue dich nicht einen Issue auf GitHub zu öfnen';

  @override
  String get errorTypeUnknown => 'Nicht verfügbar';

  @override
  String get errorTroubleshootButtonRestart => 'App neustarten';

  @override
  String get errorTroubleshootButtonLogout => 'Abmelden & App zurücksetzen';

  @override
  String get errorTroubleshootButtonGithub => 'GitHub öffnen';

  @override
  String get refreshTokenTitle => 'Token erneuern';

  @override
  String refreshTokenSubtitle(String date) {
    return 'Der aktuelle Token läuft ab am: $date. Hier tippen um ihn zu erneuern.';
  }

  @override
  String get requestTimeoutMessage =>
      'Der Server hat zu lange gebraucht, um zu antworten. Die Anfrage wurde abgebrochen.';

  @override
  String get retry => 'Neu probieren';

  @override
  String get noNotificationsAvailable => 'Du hast keine Benachrichtigungen.';

  @override
  String get authTokenAboutToExpire =>
      'Dein Authentifizierungstoken läuft in weniger als 31 Tagen ab!';

  @override
  String get renew => 'Erneuern';
}
