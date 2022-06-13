
import 'dart:convert';

UserInfo userInfoFromJson(String str) => UserInfo.fromJson(json.decode(str));

String userInfoToJson(UserInfo data) => json.encode(data.toJson());

class UserInfo {
  UserInfo({
    this.address,
    this.age,
    this.agentId,
    this.anchorGrade,
    this.anchorGradeImg,
    this.avatar,
    this.birthday,
    this.broadCast,
    this.canLinkMic,
    this.chargeShow,
    this.charmGrade,
    this.charmGradeImg,
    this.charmPoint,
    this.city,
    this.coin,
    this.constellation,
    this.consumption,
    this.createTime,
    this.devoteShow,
    this.giftGlobalBroadcast,
    this.goodnum,
    this.groupId,
    this.headNo,
    this.height,
    this.isAnchorAuth,
    this.isFirstRecharge,
    this.isNotDisturb,
    this.isPid,
    this.isPush,
    this.isSvip,
    this.isTone,
    this.isYouthModel,
    this.iszombie,
    this.iszombiep,
    this.joinRoomShow,
    this.lastOffLineTime,
    this.lat,
    this.linkOtherSid,
    this.linkOtherStatus,
    this.liveStatus,
    this.liveThumb,
    this.liveType,
    this.lng,
    this.managerCoId,
    this.managerId,
    this.mobile,
    this.mobileLengthTalking,
    this.mobleAvatarFrame,
    this.nobleGrade,
    this.nobleGradImge,
    this.nobleModal,
    this.nobleName,
    this.onlineStatus,
    this.oooLiveStatus,
    this.oooTwoClassifyId,
    this.otherRoomid,
    this.otherUid,
    this.portrait,
    this.poster,
    this.province,
    this.readShortVideoNumber,
    this.role,
    this.roomId,
    this.roomIsVideo,
    this.roomPkSid,
    this.roomType,
    this.sanwei,
    this.sex,
    this.showId,
    this.signature,
    this.status,
    this.userGrade,
    this.userGradeImg,
    this.userId,
    this.userSetOnlineStatus,
    this.userType,
    this.username,
    this.videoCoin,
    this.vocation,
    this.voiceCoin,
    this.voiceStatus,
    this.votes,
    this.wealthGrade,
    this.wealthGradeImg,
    this.weight,
    this.whetherEnablePositioningShow,
  });

  String? address;
  int? age;
  int? agentId;
  int? anchorGrade;
  String? anchorGradeImg;
  String? avatar;
  DateTime? birthday;
  int? broadCast;
  int? canLinkMic;
  int? chargeShow;
  int? charmGrade;
  String? charmGradeImg;
  int? charmPoint;
  String? city;
  double? coin;
  String? constellation;
  double? consumption;
  DateTime? createTime;
  int? devoteShow;
  int? giftGlobalBroadcast;
  String? goodnum;
  int? groupId;
  int? headNo;
  int? height;
  int? isAnchorAuth;
  int? isFirstRecharge;
  int? isNotDisturb;
  int? isPid;
  int? isPush;
  int? isSvip;
  int? isTone;
  int? isYouthModel;
  int? iszombie;
  int? iszombiep;
  int? joinRoomShow;
  int? lastOffLineTime;
  double? lat;
  int? linkOtherSid;
  int? linkOtherStatus;
  int? liveStatus;
  String? liveThumb;
  int? liveType;
  double? lng;
  int? managerCoId;
  int? managerId;
  String? mobile;
  int? mobileLengthTalking;
  String? mobleAvatarFrame;
  int? nobleGrade;
  String? nobleGradImge;
  String? nobleModal;
  String? nobleName;
  int? onlineStatus;
  int? oooLiveStatus;
  int? oooTwoClassifyId;
  int? otherRoomid;
  int? otherUid;
  String? portrait;
  String? poster;
  String? province;
  int? readShortVideoNumber;
  int? role;
  int? roomId;
  int? roomIsVideo;
  int? roomPkSid;
  int? roomType;
  String? sanwei;
  int? sex;
  String? showId;
  String? signature;
  int? status;
  int? userGrade;
  String? userGradeImg;
  int? userId;
  int? userSetOnlineStatus;
  int? userType;
  String? username;
  double? videoCoin;
  String? vocation;
  double? voiceCoin;
  int? voiceStatus;
  double? votes;
  int? wealthGrade;
  String? wealthGradeImg;
  double? weight;
  int? whetherEnablePositioningShow;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        address: json["address"],
        age: json["age"],
        agentId: json["agentId"],
        anchorGrade: json["anchorGrade"],
        anchorGradeImg: json["anchorGradeImg"],
        avatar: json["avatar"],
        birthday: DateTime.parse(json["birthday"]),
        broadCast: json["broadCast"],
        canLinkMic: json["canLinkMic"],
        chargeShow: json["chargeShow"],
        charmGrade: json["charmGrade"],
        charmGradeImg: json["charmGradeImg"],
        charmPoint: json["charmPoint"],
        city: json["city"],
        coin: json["coin"],
        constellation: json["constellation"],
        consumption: json["consumption"],
        createTime: DateTime.parse(json["createTime"]),
        devoteShow: json["devoteShow"],
        giftGlobalBroadcast: json["giftGlobalBroadcast"],
        goodnum: json["goodnum"],
        groupId: json["groupId"],
        headNo: json["headNo"],
        height: json["height"],
        isAnchorAuth: json["isAnchorAuth"],
        isFirstRecharge: json["isFirstRecharge"],
        isNotDisturb: json["isNotDisturb"],
        isPid: json["isPid"],
        isPush: json["isPush"],
        isSvip: json["isSvip"],
        isTone: json["isTone"],
        isYouthModel: json["isYouthModel"],
        iszombie: json["iszombie"],
        iszombiep: json["iszombiep"],
        joinRoomShow: json["joinRoomShow"],
        lastOffLineTime: json["lastOffLineTime"],
        lat: json["lat"].toDouble(),
        linkOtherSid: json["linkOtherSid"],
        linkOtherStatus: json["linkOtherStatus"],
        liveStatus: json["liveStatus"],
        liveThumb: json["liveThumb"],
        liveType: json["liveType"],
        lng: json["lng"].toDouble(),
        managerCoId: json["managerCoId"],
        managerId: json["managerId"],
        mobile: json["mobile"],
        mobileLengthTalking: json["mobileLengthTalking"],
        mobleAvatarFrame: json["mobleAvatarFrame"],
        nobleGrade: json["nobleGrade"],
        nobleGradImge: json["nobleGradImge"],
        nobleModal: json["nobleModal"],
        nobleName: json["nobleName"],
        onlineStatus: json["onlineStatus"],
        oooLiveStatus: json["oooLiveStatus"],
        oooTwoClassifyId: json["oooTwoClassifyId"],
        otherRoomid: json["otherRoomid"],
        otherUid: json["otherUid"],
        portrait: json["portrait"],
        poster: json["poster"],
        province: json["province"],
        readShortVideoNumber: json["readShortVideoNumber"],
        role: json["role"],
        roomId: json["roomId"],
        roomIsVideo: json["roomIsVideo"],
        roomPkSid: json["roomPkSid"],
        roomType: json["roomType"],
        sanwei: json["sanwei"],
        sex: json["sex"],
        showId: json["showId"],
        signature: json["signature"],
        status: json["status"],
        userGrade: json["userGrade"],
        userGradeImg: json["userGradeImg"],
        userId: json["userId"],
        userSetOnlineStatus: json["userSetOnlineStatus"],
        userType: json["userType"],
        username: json["username"],
        videoCoin: json["videoCoin"],
        vocation: json["vocation"],
        voiceCoin: json["voiceCoin"],
        voiceStatus: json["voiceStatus"],
        votes: json["votes"],
        wealthGrade: json["wealthGrade"],
        wealthGradeImg: json["wealthGradeImg"],
        weight: json["weight"],
        whetherEnablePositioningShow: json["whetherEnablePositioningShow"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "age": age,
        "agentId": agentId,
        "anchorGrade": anchorGrade,
        "anchorGradeImg": anchorGradeImg,
        "avatar": avatar,
        "birthday":
            "${birthday?.year.toString().padLeft(4, '0')}-${birthday?.month.toString().padLeft(2, '0')}-${birthday?.day.toString().padLeft(2, '0')}",
        "broadCast": broadCast,
        "canLinkMic": canLinkMic,
        "chargeShow": chargeShow,
        "charmGrade": charmGrade,
        "charmGradeImg": charmGradeImg,
        "charmPoint": charmPoint,
        "city": city,
        "coin": coin,
        "constellation": constellation,
        "consumption": consumption,
        "createTime": createTime?.toIso8601String(),
        "devoteShow": devoteShow,
        "giftGlobalBroadcast": giftGlobalBroadcast,
        "goodnum": goodnum,
        "groupId": groupId,
        "headNo": headNo,
        "height": height,
        "isAnchorAuth": isAnchorAuth,
        "isFirstRecharge": isFirstRecharge,
        "isNotDisturb": isNotDisturb,
        "isPid": isPid,
        "isPush": isPush,
        "isSvip": isSvip,
        "isTone": isTone,
        "isYouthModel": isYouthModel,
        "iszombie": iszombie,
        "iszombiep": iszombiep,
        "joinRoomShow": joinRoomShow,
        "lastOffLineTime": lastOffLineTime,
        "lat": lat,
        "linkOtherSid": linkOtherSid,
        "linkOtherStatus": linkOtherStatus,
        "liveStatus": liveStatus,
        "liveThumb": liveThumb,
        "liveType": liveType,
        "lng": lng,
        "managerCoId": managerCoId,
        "managerId": managerId,
        "mobile": mobile,
        "mobileLengthTalking": mobileLengthTalking,
        "mobleAvatarFrame": mobleAvatarFrame,
        "nobleGrade": nobleGrade,
        "nobleGradImge": nobleGradImge,
        "nobleModal": nobleModal,
        "nobleName": nobleName,
        "onlineStatus": onlineStatus,
        "oooLiveStatus": oooLiveStatus,
        "oooTwoClassifyId": oooTwoClassifyId,
        "otherRoomid": otherRoomid,
        "otherUid": otherUid,
        "portrait": portrait,
        "poster": poster,
        "province": province,
        "readShortVideoNumber": readShortVideoNumber,
        "role": role,
        "roomId": roomId,
        "roomIsVideo": roomIsVideo,
        "roomPkSid": roomPkSid,
        "roomType": roomType,
        "sanwei": sanwei,
        "sex": sex,
        "showId": showId,
        "signature": signature,
        "status": status,
        "userGrade": userGrade,
        "userGradeImg": userGradeImg,
        "userId": userId,
        "userSetOnlineStatus": userSetOnlineStatus,
        "userType": userType,
        "username": username,
        "videoCoin": videoCoin,
        "vocation": vocation,
        "voiceCoin": voiceCoin,
        "voiceStatus": voiceStatus,
        "votes": votes,
        "wealthGrade": wealthGrade,
        "wealthGradeImg": wealthGradeImg,
        "weight": weight,
        "whetherEnablePositioningShow": whetherEnablePositioningShow,
      };
}
