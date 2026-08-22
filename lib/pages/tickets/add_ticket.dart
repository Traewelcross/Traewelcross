import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:traewelcross/components/alert_card.dart';
import 'package:traewelcross/components/app_bar_title.dart';
import 'package:traewelcross/components/fieldset.dart';
import 'package:traewelcross/components/main_scaffold.dart';
import 'package:traewelcross/components/time_override_field.dart';
import 'package:traewelcross/l10n/app_localizations.dart';
import 'package:traewelcross/utils/api_providers/api_models.dart';
import 'package:traewelcross/utils/api_service.dart';
import 'package:traewelcross/utils/shared.dart';
import 'package:traewelcross/utils/tickets/ticket_manager.dart';
import 'package:traewelcross/utils/tickets/ticket_model.dart';
import 'package:flutter_zxing/flutter_zxing.dart';
import 'package:uuid/v4.dart';

class AddTicket extends StatefulWidget {
  const AddTicket({super.key});

  @override
  State<AddTicket> createState() => _AddTicketState();
}

class _AddTicketState extends State<AddTicket> {
  Code ticketC = Code(format: Format.aztec);
  Ticket t = Ticket(data: Uint8List(0), format: 0, uuid: "");
  bool ticketDataSet = false;
  void processImage(XFile image) async {
    Code result = await zx.readBarcodeImagePath(
      image,
      DecodeParams(
        imageFormat: ImageFormat.bgr,
        tryHarder: true,
        tryDownscale: true,
        tryInverted: true,
        maxNumberOfSymbols: 4096,
        maxSize: 4096,
      ),
    );
    if (result.rawBytes == null) return;
    ticketC = result;
    setState(() {
      ticketDataSet = true;
    });
  }
  late Iterable<Operator> _lastOptions = <Operator>[];
  Future<Iterable<Operator>> _searchOperators(String query) async {
    List<Operator> response = await getIt<ApiService>().operator
        .autocompleteOperator(query);
    return response;
  }
    final TextEditingController controller = TextEditingController();
    final TextEditingController notesController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final localize = AppLocalizations.of(context)!;
    return MainScaffold(
      title: AppBarTitle(localize.ticketListViewAddTicket),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AlertCard(text: localize.ticketAddTicketOnDeviceInfo, type: .info, size: 16,),
            SizedBox(height: 6),
            Stack(
              children: [
                Fieldset(
                  label: localize.ticketAddTicketDataFieldset,
                  child: AbsorbPointer(
                    absorbing: ticketDataSet,
                    child: Column(
                      children: [
                        FilledButton.icon(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(
                              source: .gallery,
                              requestFullMetadata: false,
                            );
                            if (image == null) return;
                            processImage(image);
                          },
                          label: Text(localize.ticketAddTicketDataFromImage),
                          icon: Icon(Icons.image),
                        ),
                        SizedBox(height: 12),
                        Text(localize.ticketAddTicketDataOr),
                        SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(
                              source: .camera,
                              requestFullMetadata: false,
                            );
                            if (image == null) return;
                            processImage(image);
                          },
                          label: Text(localize.ticketAddTicketDataFromCamera),
                          icon: Icon(Icons.camera),
                        ),
                        Divider(),
                        ExpansionTile(
                          shape: Border.all(color: Colors.transparent),
                          title: Text(localize.ticketAddTicketDataManual),
                          children: [
                            AlertCard(
                              text: localize.ticketAddTicketDataManuallyHint,
                              type: .warning,
                              size: 24,
                            ),
                            SizedBox(height: 8),
                            DropdownMenu(
                              enableSearch: false,
                              enableFilter: false,
                              selectOnly: true,
                              initialSelection: Format.aztec,
                              dropdownMenuEntries: <DropdownMenuEntry<int>>[
                                DropdownMenuEntry(
                                  value: Format.aztec,
                                  label: "AZTEC",
                                ),
                                DropdownMenuEntry(
                                  value: Format.qrCode,
                                  label: "QR-Code",
                                ),
                                DropdownMenuEntry(
                                  value: Format.dataMatrix,
                                  label: "Data Matrix",
                                ),
                                DropdownMenuEntry(
                                  value: Format.pdf417,
                                  label: "PDF 417",
                                ),
                                DropdownMenuEntry(
                                  value: Format.code128,
                                  label: "Code 128",
                                ),
                              ],
                              onSelected: (v) => ticketC.format = v,
                            ),
                            SizedBox(height: 8),
                            TextField(
                              controller: controller,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text(localize.ticketAddTicketDataData),
                              ),
                            ),
                            SizedBox(height: 8),
                            FilledButton.icon(
                              onPressed: () {
                                ticketC.text = controller.value.text;
                                setState(() {
                                  ticketDataSet = true;
                                });
                              },
                              label: Text(localize.done),
                              icon: const Icon(Icons.check),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (ticketDataSet)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withAlpha(230),
                      child: Center(
                        child: Column(
                          mainAxisSize: .min,
                          children: [
                            const Icon(
                              Icons.check,
                              size: 48,
                              color: Colors.greenAccent,
                            ),
                            Text(localize.ticketAddTicketDataSuccess),
                            TextButton(
                              onPressed: () {
                                ticketC = Code();
                                setState(() {
                                  ticketDataSet = false;
                                });
                              },
                              child: Text(localize.ticketAddTicketDataReset),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 6),
            Fieldset(
              label: localize.ticketAddOptionalDataFieldset,
              child: Column(
                spacing: 6,
                children: [
                  TextField(controller: nameController,
                    decoration: InputDecoration(border: OutlineInputBorder(), label: Text(localize.ticketAddOptionalDataName), hint: Text("Hannover Hbf - Uelzen, GVB 96h, ...")),
                  ),
                  TimeOverrideField(
                    initialDate: null,
                    onDateChanged: (d) => t.begin = d,
                    watermark: localize.ticketAddOptionalDataValidBegin,
                    showNow: false,
                  ),
                  TimeOverrideField(
                    initialDate: null,
                    onDateChanged: (d) => t.expire = d,
                    watermark: localize.ticketAddOptionalDataValidEnd,
                    showNow: false,
                  ),
                  Autocomplete<Operator>(
                    optionsBuilder: (textEditValue) {
                      final query = textEditValue.text;
                      if (query.isEmpty) {
                        _lastOptions = [];
                        return const Iterable<Operator>.empty();
                      }
                      final completer = Completer<Iterable<Operator>>();
                      EasyDebounce.debounce(
                        'se_op_tick',
                        const Duration(milliseconds: 400),
                        () async {
                          try {
                            final options = await _searchOperators(query);
                            _lastOptions = options;

                            if (!completer.isCompleted) {
                              completer.complete(options);
                            }
                          } catch (error) {
                            if (!completer.isCompleted) {
                              completer.complete(_lastOptions);
                            }
                          }
                        },
                      );
                      return completer.future;
                    },
                    displayStringForOption: (o) => o.name,
                    onSelected: (o) => t.operator = o,
                    fieldViewBuilder: (ctx, textEditC, focusN, onFieldSubmit) {
                      return TextFormField(
                        controller: textEditC,
                        focusNode: focusN,
                        onFieldSubmitted: (_) => onFieldSubmit(),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: localize.operator,
                          counterText: "",
                        ),
                      );
                    },
                  ),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(border: OutlineInputBorder(), label: Text(localize.ticketAddOptionalDataAdditionalNotes)),
                    minLines: 3,
                    maxLines: null,
                  ),
                ],
              ),
            ),
            SizedBox(height: 6,),
            FilledButton.icon(onPressed: ticketDataSet == true ? () async {
              t.uuid = UuidV4().generate();
              t.data = ticketC.rawBytes ?? utf8.encode(controller.text);
              t.format = ticketC.format!;
              t.notes = notesController.text;
              t.name = nameController.text;
              await TicketManager.addTicket(t);
              if(!context.mounted) return;
              Navigator.pop(context);
            }: null, label: Text(localize.ticketListViewAddTicket))
          ],
        ),
      ),
    );
  }
}
