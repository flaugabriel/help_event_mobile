class EventModel {
  List<Event> event;

  EventModel({this.event});

  EventModel.fromJson(Map<String, dynamic> json) {
    print(json['event']);
    if (json['event'] != null) {
      event = new List<Event>();
      json['event'].forEach((v) {
        event.add(new Event.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.event != null) {
      data['event'] = this.event.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Event {
  int id;
  String description;
  DateTime created_at;
  String user;
  String total;

  Event(
      {this.id,
        this.description,
        this.created_at,
        this.user,
        this.total
      });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    created_at = json['created_at'];
    user = json['user'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['created_at'] = this.created_at;
    data['user'] = this.user;
    data['total'] = this.total;
    return data;
  }
}

