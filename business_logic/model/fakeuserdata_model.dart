class Fakeuser {
  String? avatar;
  String? name;
  int? id;
  String? location;
  String? introduction;

  Fakeuser({this.id, this.avatar, this.introduction, this.location, this.name});
}

List fakeuser = [
  Fakeuser(
      avatar: 'http://61.31.228.23/A_PH/136742/3-135x135.jpg',
      name: '柴魚',
      id: 18845,
      location: '彰化',
      introduction: '雙魚座~是個愛美的女生'),
  Fakeuser(
      avatar: 'http://61.31.228.23/A_PH/157229/3-135x135.jpg',
      name: 'amanda',
      id: 18846,
      location: '雲林',
      introduction: '先找個人聊聊~現在單身中'),
  Fakeuser(
      avatar: 'http://61.31.228.23/A_PH/152408/3-135x135.jpg',
      name: '小虎牙',
      id: 18847,
      location: '鹿港',
      introduction: '虎牙是我從小到大的標誌喔!'),
  Fakeuser(
      avatar: 'http://61.31.228.23/A_PH/131419/3-135x135.jpg',
      name: '小愛奇',
      id: 18848,
      location: '屏東車城',
      introduction: '想找人跟我一起去旅遊'),
  Fakeuser(
      avatar: 'http://61.31.228.23/A_PH/122473/3-135x135.jpg',
      name: '奶茶妹',
      id: 18849,
      location: '台北',
      introduction: '23歲剛畢業目前在做室內設計師'),
];
