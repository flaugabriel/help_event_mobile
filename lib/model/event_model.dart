class EventModel {
  List<Event> event;
  String msg;

  EventModel({this.event});

  EventModel.fromJson(Map<String, dynamic> json) {
    if(json == null){
      this.msg = "Sem eventos";
    }else if (json['event'] != null) {
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
  String created_at;
  int items;
  String user;
  String total;
  String error;

  Event(
      {this.id,
      this.items,
        this.description,
        this.created_at,
        this.user,
        this.total
      });

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    created_at = json['created_at'];
    items = json['items']  == null ? '0' : json['items'];
    user = json['user'];
    total = json['total'] == null ? '0,0' : json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['created_at'] = this.created_at;
    data['items'] = this.items;
    data['user'] = this.user;
    data['total'] = this.total;
    return data;
  }
}

