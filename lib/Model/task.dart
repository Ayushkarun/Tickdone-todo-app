class Task {
  final String title;
  final String description;
  final String category;
  final String date;
  final String time;
  final String userId;

  Task({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.time,
    required this.userId,
  });

  //convert task to firebase json format
  Map<String, dynamic> toFirebaseJson() {
    return {
      'title': {'stringValue': title},
      'description': {'stringValue': description},
      'category': {'stringValue': category},
      'date': {'stringValue': date},
      'time': {'stringValue': time},
      'userId': {'stringValue': userId},
    };
  }
  //convert Firebase Json to taskobject

  factory Task.fromFirebaseJson(Map<String, dynamic> json) {
    return Task(
      title: json['title']['stringValue'] ?? '',
      description: json['description']['stringValue'] ?? '',
      category: json['category']['stringValue'] ?? '',
      date: json['date']['stringValue'] ?? '',
      time: json['time']['stringValue'] ?? '',
      userId: json['userId']['stringValue'] ?? '',
    );
  }
}
