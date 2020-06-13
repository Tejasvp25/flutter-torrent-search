import 'package:extended_tabs/extended_tabs.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/utils/Preferences.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class TorrentResult extends StatefulWidget {
  @override
  _TorrentResultState createState() => _TorrentResultState();
}

class _TorrentResultState extends State<TorrentResult> {
  final Preferences pref = Preferences();
  List<String> titles = List<String>();
  List<String> endpoints = List<String>();
  bool _isSnackbarShown = false;

  Future<void> _init() async {
    ApiConstants.INDEXERS.forEach((element)async {
      if(await pref.getIndexers(element)==true){
        switch(element){
          case "1337x" : titles.add(ApiConstants.INDEXERS[0]); endpoints.add(ApiConstants.ENDPOINT_1337x); break;
          case "Eztv" : titles.add(ApiConstants.INDEXERS[1]);endpoints.add(ApiConstants.EZTV_TORRENT);break;
          case "Kickass" : titles.add(ApiConstants.INDEXERS[2]);endpoints.add(ApiConstants.KICKASS_ENDPOINT);break;
          case "Limetorrents" : titles.add(ApiConstants.INDEXERS[3]);endpoints.add(ApiConstants.LIMETORRENTS_ENDPOINT);break;
          case "Skytorrents" : titles.add(ApiConstants.INDEXERS[4]);endpoints.add(ApiConstants.SKYTORRENT_ENDPOINT);break;
          case "Pirate Bay" : titles.add(ApiConstants.INDEXERS[5]);endpoints.add(ApiConstants.TPB_ENDPOINT);break;
          case "Torrent Downloads" : titles.add(ApiConstants.INDEXERS[6]);endpoints.add(ApiConstants.TORRENTDOWNLOADS_ENDPOINT);break;
          case "Torrent Galaxy" : titles.add(ApiConstants.INDEXERS[7]);endpoints.add(ApiConstants.TGX_ENDPOINT);break;
          case "Yts" : titles.add(ApiConstants.INDEXERS[8]);endpoints.add(ApiConstants.YTS_ENDPOINT);break;
          case "Nyaa" : titles.add(ApiConstants.INDEXERS[9]);endpoints.add(ApiConstants.NYAA_ENDPOINT);break;
          case "Horriblesubs" : titles.add(ApiConstants.INDEXERS[10]);endpoints.add(ApiConstants.HORRIBLESUBS_ENDPOINT);break;
        }
      }
    });
    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    titles.clear();
    endpoints.clear();
    String search = ModalRoute.of(context).settings.arguments;
      return Scaffold(
//        backgroundColor: Theme.of(context).accentColor,
        body:  FutureBuilder(
          future: _init(),
          builder: (ctx,snapshot){
            if(snapshot.hasData){
              if(titles.length==0){
                titles.add(ApiConstants.INDEXERS[0]);
                endpoints.add(ApiConstants.ENDPOINT_1337x);
                pref.setIndexers("1337x", true);
              }
              return  DefaultTabController(
                length: titles.length,
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Theme.of(context).accentColor,
                    title: Text(
                      'RESULTS',
                      style:TextStyle(
                          color: Colors.white,
                          letterSpacing: 3.0
                      ),
                    ),
                    centerTitle: true,
                    bottom: TabBar(
                      labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : Theme.of(context).accentColor,
                      isScrollable: true,
                      tabs: titles.map((e) {
                        return Text(e);
                      }).toList(),
                    ),
                  ),
                  body: ExtendedTabBarView(
                    children: endpoints.map((e) {
                      return Torrenttab(e, search);
                    }).toList(),
                    cacheExtent: endpoints.length,
                  ),
                ),
              );
            }else{
              return CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
              );
            }
          },
        )
      );
  }

  void showFlushbar(BuildContext context){
    Flushbar(
      message: "Tap on List Item to Copy/Share Magnet Link",
      duration: Duration(seconds: 4),
      flushbarStyle: FlushbarStyle.FLOATING,
    ).show(context);
  }

}
