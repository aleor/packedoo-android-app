class Counters {
  int messages;
  int notifications;
  int suggestionCount;

  int get totalMessages => messages;
  int get pendingTotal => messages + suggestionCount;

  Counters.fromMap(Map<dynamic, dynamic> map) {
    messages = map['messages'] ?? 0;
    notifications = map['notifications'] ?? 0;
    suggestionCount = map['suggestionCount'] ?? 0;
  }
}
