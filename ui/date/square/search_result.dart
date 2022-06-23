import 'package:flutter/material.dart';
import 'package:ime_new/business_logic/provider/chat_provider.dart';
import 'package:ime_new/ui/otherpage/other_profile_page.dart';



import 'package:ime_new/ui/widget/stack_text.dart';
import 'package:provider/provider.dart';
import 'package:lpinyin/lpinyin.dart';
class SearchResult extends StatefulWidget {
  const SearchResult({Key? key}) : super(key: key);

  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: GestureDetector(
              child: Container(
                  width: 135,
                  height: 35,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color(0xff5ac9e8),
                        Color(0xffa1e4ac),
                      ]),
                      borderRadius: BorderRadius.circular(15)),
                  child: Center(
                      child: Text(
                    '取消篩選',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ))),
              onTap: () {
                Provider.of<ChatProvider>(context, listen: false)
                    .close_search();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0,right: 10,left: 10),
            child: Consumer<ChatProvider>(builder: (context, value, child) {
              return value.search_memberlist != null &&
                      value.search_memberlist.length != 0
                  ? GridView.builder(
                      itemCount: value.search_memberlist?.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                          childAspectRatio: 1.2),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  StackText(
                                    text: value.search_memberlist![index]
                                                    .nickname ==
                                                '' ||
                                            value.search_memberlist![index]
                                                    .nickname ==
                                                null
                                        ? '不詳'
                                        : value
                                            .search_memberlist![index].nickname,
                                    size: 12,
                                  ),
                                  StackText(
                                    text: value.search_memberlist?[index]
                                                    .introduction ==
                                                null ||
                                            value.search_memberlist?[index]
                                                    .introduction ==
                                                ''
                                        ? '不詳'
                                        : '${value.search_memberlist?[index].introduction}',
                                    size: 12,
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: Icon(
                                          Icons.location_on_outlined,
                                          size: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      StackText(
                                        text: value.search_memberlist?[index]
                                                        .area ==
                                                    null ||
                                                value.search_memberlist?[index]
                                                        .area ==
                                                    ''
                                            ? '不詳'
                                            : '${ChineseHelper.convertToTraditionalChinese(value.search_memberlist?[index].area)}',
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.3),
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                    image: value.search_memberlist![index]
                                                    .avatar_sub !=
                                                null &&
                                            value.search_memberlist![index]
                                                    .avatar_sub !=
                                                ''
                                        ? NetworkImage(
                                            '${value.search_memberlist![index].avatar_sub}',
                                          )
                                        : AssetImage(
                                                value.search_memberlist![index]
                                                                .sex ==
                                                            null ||
                                                        value
                                                                .search_memberlist![
                                                                    index]
                                                                .sex ==
                                                            '男'
                                                    ? 'assets/default/sex_man.png'
                                                    : 'assets/default/sex_woman.png')
                                            as ImageProvider,
                                    fit: BoxFit.cover),
                                border: Border.all(
                                  width: 1,
                                  color: Colors.blue.withOpacity(.3),
                                )),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OtherProfilePage(
                                          chatroomid: value
                                              .search_memberlist![index].memberid,
                                        )));
                          },
                        );
                        // return Container(
                        //   child: Text('${value.search_memberlist[index]}'),
                        // );
                      },
                    )
                  : Container(height: 60,

                  child: Center(child: Text('沒有人符合條件，請選擇其他條件')));
            }),
          )
        ],
      ),
    );
  }
}
