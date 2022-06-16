  class Room {
  Room({
    required this.id,
    required this.status,
    required this.isStart,
    required this.isDare,
    required this.king,
    required this.user1,
    required this.user2,
    required this.live1,
    required this.live2,
    required this.live3,
    required this.live4,
    required this.count,
    required this.avatarUrl1,
    required this.avatarUrl2,
    required this.avatarUrl3,
    required this.avatarUrl4,
  });
  late final String? id;
  late final String? status;
  late final String? name;
  late final String? explain;
  late final bool isStart;
  late final bool isDare;
  late final int king;
  late final String? user1;
  late final String? user2;
  late final String? live1;
  late final String? live2;
  late final String? live3;
  late final String? live4;
  late final String? avatarUrl1;
  late final String? avatarUrl2;
  late final String? avatarUrl3;
  late final String? avatarUrl4;

  late final int count;

  Room.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    explain = json['explain'];
    status = json['status'];
    isStart = json['isStart'];
    isDare = json['isDare'];
    king = json['king'];
    user1 = json['user1'];
    user2 = json['user2'];
    live1 = json['live1'];
    live2 = json['live2'];
    live3 = json['live3'];
    live4 = json['live4'];
    count = json['count'];
    avatarUrl1 = json['avatarUrl1'];
    avatarUrl2 = json['avatarUrl2'];
    avatarUrl3 = json['avatarUrl3'];
    avatarUrl4 = json['avatarUrl4'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['explain'] = explain;
    _data['id'] = id;
    _data['status'] = status;
    _data['isStart'] = isStart;
    _data['isDare'] = isDare;
    _data['king'] = king;
    _data['user1'] = user1;
    _data['user2'] = user2;
    _data['live1'] = live1;
    _data['live2'] = live2;
    _data['count'] = count;
    _data['avatarUrl1'] = avatarUrl1;
    _data['avatarUrl2'] = avatarUrl2;
    _data['avatarUrl3'] = avatarUrl3;
    _data['avatarUrl4'] = avatarUrl4;

    return _data;
  }
}
