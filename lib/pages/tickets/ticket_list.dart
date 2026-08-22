import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/pages/tickets/add_ticket.dart';
import 'package:traewelcross/pages/tickets/ticket_view.dart';
import 'package:traewelcross/utils/tickets/ticket_manager.dart';
import 'package:traewelcross/utils/tickets/ticket_model.dart';

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  late Future<List<Ticket>?> _ticketF;
  @override
  void initState() {
    super.initState();
    _ticketF = TicketManager.getTickets();
  }

  String buildDetailString(Ticket t) {
    String d = "";
    if (t.begin != null) {
      d += DateFormat.yMd(
        Localizations.localeOf(context).languageCode,
      ).format(t.begin!);
    }
    d += " - ";
    if (t.expire != null) {
      d += DateFormat.yMd(
        Localizations.localeOf(context).languageCode,
      ).format(t.expire!);
    }
    if (t.operator != null) {
      d += "\n${t.operator!.name}";
    }
    return d;
  }

  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.ticketListViewTitle),
      body: FutureBuilder(
        future: _ticketF,
        builder: (ctx, snp) {
          if (snp.connectionState == .waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snp.connectionState == .done) {
            if (snp.hasError) {
              return Center(child: Text(snp.error.toString()));
            }
            if (!snp.hasData || snp.data?.isEmpty == true) {
              return Center(child: Text(localize.ticketListViewNoTickets));
            }
            final tickets = snp.data!;
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: .end,
                      children: [
                        const SizedBox(width: 16),
                        const Icon(Icons.delete, color: Colors.black),
                        const Spacer(),
                        const Icon(Icons.delete, color: Colors.black),
                        const SizedBox(width: 16),
                      ],
                    ),
                  ),
                  key: Key(tickets[index].uuid),
                  onDismissed: (direction) async {
                    await TicketManager.removeTicket(tickets[index].uuid);
                    setState(() {
                      _ticketF = TicketManager.getTickets();
                    });
                  },
                  child: Card(
                    clipBehavior: .hardEdge,
                    child: ListTile(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) =>
                              TicketView(ticket: tickets[index], index: index),
                        ),
                      ),
                      title: Text(
                        tickets[index].name!.isEmpty
                            ? localize.ticketListViewGenericTicketName(
                                index + 1,
                              )
                            : tickets[index].name!,
                      ),
                      subtitle: Text(buildDetailString(tickets[index])),
                      isThreeLine:
                          (tickets[index].operator != null &&
                          (tickets[index].begin != null ||
                              tickets[index].expire != null)),
                    ),
                  ),
                );
              },
            );
          }
          return const SizedBox(height: 0);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => AddTicket()),
          );
          setState(() {
            _ticketF = TicketManager.getTickets();
          });
        },
        label: Text(localize.ticketListViewAddTicket),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
