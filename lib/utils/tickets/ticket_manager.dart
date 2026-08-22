import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:traewelcross/utils/tickets/ticket_model.dart';

class TicketManager {
  static Future<Ticket?> getTicket(String uuid) async {
    final secureStorage = const FlutterSecureStorage();
    final String? tickets = await secureStorage.read(key: "tickets");
    if(tickets == null) return null;
    final List<Ticket> ticket = (jsonDecode(tickets) as List<dynamic>).map((t) => Ticket.fromJson(t as Map<String, dynamic>)).toList();
    try {
      return ticket.firstWhere((ticket) => ticket.uuid == uuid);
    } on StateError {
      return null;
    }
  }
  static Future<List<Ticket>?> getTickets({String? operator}) async {
    final secureStorage = const FlutterSecureStorage();
    final String? tickets = await secureStorage.read(key: "tickets");
    if(tickets == null) return null;
    List<Ticket> ticket = (jsonDecode(tickets) as List<dynamic>).map((t) => Ticket.fromJson(t as Map<String, dynamic>)).toList();
    if(operator == null){ return ticket;}
    return ticket.where((t) => t.operator?.name == operator).toList();
  }
  static Future<void> addTicket(Ticket ticket) async{
    List<Ticket> ticketL;
    final secureStorage = const FlutterSecureStorage();
    final String? tickets = await secureStorage.read(key: "tickets");
    if(tickets == null) {
      ticketL = .empty(growable: true);
    }
    else {
      ticketL = (jsonDecode(tickets) as List<dynamic>).map((t) => Ticket.fromJson(t as Map<String, dynamic>)).toList();
    }
    ticketL.add(ticket);
    secureStorage.write(key: "tickets", value: jsonEncode(ticketL));
  }
  static Future<void> removeTicket(String uuid) async{
     List<Ticket> ticketL;
    final secureStorage = const FlutterSecureStorage();
    final String? tickets = await secureStorage.read(key: "tickets");
    if(tickets == null) {
      return;
    }
    else {
      ticketL = (jsonDecode(tickets) as List<dynamic>).map((t) => Ticket.fromJson(t as Map<String, dynamic>)).toList();
    }
    ticketL.removeWhere((t) => t.uuid == uuid);
    secureStorage.write(key: "tickets", value: jsonEncode(ticketL));
  }
  static Future<void> clearTickets() async {
    final secureStorage = const FlutterSecureStorage();
  await secureStorage.delete(key: "tickets");
  }
}