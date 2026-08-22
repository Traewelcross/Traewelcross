import 'package:barcode/barcode.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/alert_card.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/tickets/ticket_model.dart';
import "package:flutter_zxing/flutter_zxing.dart";

class TicketView extends StatelessWidget {
  const TicketView({super.key, required this.ticket, required this.index});
  final Ticket ticket;
  final int index;
  String getTicketCode() {
    final bc = switch (ticket.format) {
      Format.aztec => Barcode.aztec(minECCPercent: 50),
      Format.pdf417 => Barcode.pdf417(),
      Format.qrCode => Barcode.qrCode(errorCorrectLevel: .high),
      Format.code128 => Barcode.code128(),
      Format.dataMatrix => Barcode.dataMatrix(),
      _ => Barcode.aztec(),
    };
    return bc.toSvgBytes(ticket.data, width: 200, height: 200, drawText: false);
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(
        ticket.name!.isEmpty
            ? localize.ticketListViewGenericTicketName(index)
            : ticket.name!,
      ),
      body: ListView(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 512),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: SvgPicture.string(
                    getTicketCode(),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
          AlertCard(
            text: localize.ticketViewDisclaimer,
            type: .warning,
            title: localize.ticketViewDisclaimerTitle,
            size: 24,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    localize.ticketViewAdditionalDetails,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Divider(),
                  Text(
                    "${localize.ticketAddOptionalDataValidBegin}: ${ticket.begin != null ? DateFormat.yMd(Localizations.localeOf(context).languageCode).add_Hm().format(ticket.begin!) : "N/A"}",
                  ),
                  Text(
                    "${localize.ticketAddOptionalDataValidEnd}: ${ticket.expire != null ? DateFormat.yMd(Localizations.localeOf(context).languageCode).add_Hm().format(ticket.expire!) : "N/A"}",
                  ),
                  Text(
                    "${localize.operator}: ${ticket.operator != null ? ticket.operator!.name : "N/A"}",
                  ),
                  Text(
                    "${localize.ticketAddOptionalDataAdditionalNotes}:\n${ticket.notes}",
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
