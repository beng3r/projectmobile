import 'dart:convert';

class BusTicket {
  final int? book_id;
  final DateTime depart_date;
  final String time;
  final String depart_station;
  final String dest_station;
  BusTicket({
    this.book_id,
    required this.depart_date,
    required this.time,
    required this.depart_station,
    required this.dest_station,
  });
  // Convert a Brand into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'depart_date': depart_date,
      'time': time,
      'depart_station': depart_station,
      'dest_station': dest_station,
    };

    if (book_id != null) {
      map['book_id'] = book_id;
    }
    return map;
  }

  factory BusTicket.fromMap(Map<String, dynamic> map) {
    return BusTicket(
      book_id: map['book_id']?.toInt() ?? 0,
      depart_date: map['depart_date'] ?? '',
      time: map['time'] ?? '',
      depart_station: map['depart_station'] ?? '',
      dest_station: map['dest_station'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());
  factory BusTicket.fromJson(String source) =>
      BusTicket.fromMap(json.decode(source));
  // Implement toString to make it easier to see information about
  // each brandd when using the print statement.
  @override
  String toString() =>
      'BusTicket(book_id: $book_id, depart_date: $depart_date, time: $time, depart_station: $depart_station, dest_station: $dest_station)';
}
