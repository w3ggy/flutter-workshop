import 'package:flutter/material.dart';
import 'package:flutter_workshop/models/PhotoItem.dart';
import 'package:flutter_workshop/navigation/AppRouter.dart';
import 'package:flutter_workshop/resources/ColorRes.dart';
import 'package:flutter_workshop/resources/ImageRes.dart';
import 'package:flutter_workshop/resources/StringRes.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfilePageState();
  }
}

class ProfilePageState extends State<ProfilePage> {
  final List<PhotoItem> items = List();

  @override
  void initState() {
    super.initState();
    items.addAll(_getMockItems());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      primary: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(98),
        child: _getHeader(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getBody(),
        ],
      ),
      bottomNavigationBar: _getFooter(),
    );
  }

  Widget _getHeader() {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 10, 10, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [ColorRes.midnight, ColorRes.darkIndigo],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Text(
            StringRes.profileTitle,
            style: TextStyle(
              color: ColorRes.white,
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _getBody() {
    return Flexible(
        child: GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, mainAxisSpacing: 6, crossAxisSpacing: 7),
      itemBuilder: (context, i) => _createListItem(items[i]),
      itemCount: items.length,
    ));
  }

  Widget _getFooter() {
    return Container(
      height: 100,
      padding: EdgeInsets.symmetric(horizontal: 40),
      color: ColorRes.darkIndigo,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => appRouter.openMainScreen(context),
            child: Image.asset(
              ImageRes.icHome,
              width: 28,
              height: 28,
            ),
          ),
          Image.asset(
            ImageRes.icAdd,
            width: 46,
            height: 46,
          ),
          Image.asset(
            ImageRes.icProfileFilled,
            width: 28,
            height: 28,
          ),
        ],
      ),
    );
  }

  List<PhotoItem> _getMockItems() {
    return [
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/5AC37166-3495-404D-B172-A4D55D349A66.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/91C0A8E5-F111-46BA-8314-4B4AF9E1CAB3.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/9B789546-6517-44A7-A0BD-92024A0BB6AF.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/22EF75BB-3479-4954-801B-55A481BF3B87.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/777E2954-6EAC-486E-A75A-DA7A2BF9914D.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/0D16551B-140C-4C0B-80D1-A49105C17876.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/C5E4DD25-4557-47D3-81E4-8ACF5055BD21.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/788074D1-32EF-4499-BFF7-A9DB24B4B476.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/E0BEC11B-8CC9-4C54-865C-0570334D0538.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/5B58D750-34F9-462A-B542-551A07483089.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/562DFE4F-2219-497D-BC42-B7E5D140E3C5.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/E0BBB1F6-2B38-42AC-A3CC-0AA2795691D7.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/F3D4E791-FA7F-4C57-BBD9-6CB33101AE38.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/76405892-6A80-428A-8B65-AE15DEA8F504.png'),
      PhotoItem(
          imageUrl:
              'https://cdn.zeplin.io/5ccffadfbaa9bd34a21c90b5/assets/FB7D7180-2568-4827-B4FE-416F53FEA28E.png'),
    ];
  }

  Widget _createListItem(PhotoItem item) {
    return Image.network(item.imageUrl);
  }
}
