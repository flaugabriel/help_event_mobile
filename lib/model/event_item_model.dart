class EventItemModel {
  List<EventItem> event_item;

  EventItemModel({this.event_item});

  EventItemModel.fromJson(Map<String, dynamic> json) {
    if (json['event_items'] != null) {
      event_item = new List<EventItem>();
      json['event_items'].forEach((v) {
        event_item.add(new EventItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.event_item != null) {
      data['event_items'] = this.event_item.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class EventItem {
  int id;
  String description;
  String location;
  String status;
  String user;
  int item_id;
  String value;

  EventItem(
      {this.id,
        this.description,
        this.user,
        this.location,
        this.status,
        this.item_id,
        this.value
      });

  EventItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    item_id = json['item_id'];
    description = json['description'];
    location = json['location'];
    status = json['status'].toString();
    user = json['user'];
    value = json['value'] == null ? '0,0' : json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['item_id'] = this.item_id;
    data['user'] = this.user;
    data['location'] = this.location;
    data['status'] = this.status;
    data['value'] = this.value;
    return data;
  }
}

