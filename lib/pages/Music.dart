import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/Network.dart';
import 'package:torrentsearch/utils/Utils.dart';
import 'package:torrentsearch/widgets/CustomWidgets.dart';

class Music extends StatefulWidget {
  @override
  MusicState createState() => MusicState();
}

class MusicState extends State<Music> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _textEditingController =
      TextEditingController(text: "");

  final DatabaseHelper databaseHelper = DatabaseHelper();
  final Preferences pref = Preferences();
  bool torrent = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PreferenceProvider provider =
        Provider.of<PreferenceProvider>(context);
    return ListView(
      physics: BouncingScrollPhysics(),
      // shrinkWrap: true,
      children: <Widget>[
        _buildSearch(context),
        Center(
          child: FutureBuilder(
            future: getJioSaavnHome(provider.baseUrl),
            builder:
                (BuildContext context, AsyncSnapshot<JioSaavnHome> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Charts",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          InkWell(
                            child: Text(
                              "View all",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/allmusic",
                                arguments: {
                                  "list": snapshot.data.charts,
                                  "type": "Charts"
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildList(context, data: snapshot.data.charts),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Trending",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          InkWell(
                            child: Text(
                              "View all",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/allmusic",
                                arguments: {
                                  "list": snapshot.data.trending,
                                  "type": "Trending"
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    _buildList(context, data: snapshot.data.trending),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Top Playlist",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          InkWell(
                            child: Text(
                              "View all",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                                letterSpacing: 1.0,
                              ),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/allmusic",
                                arguments: {
                                  "list": snapshot.data.topPlaylists,
                                  "type": "Top Playlists"
                                },
                              );
                            },
                          )
                        ],
                      ),
                    ),
                    _buildList(context, data: snapshot.data.topPlaylists),
                    SizedBox(height: 70.0),
                  ],
                );
              } else if (snapshot.hasError) {
                ExceptionWidget(snapshot.error);
              }
              return ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Charts",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        InkWell(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/allmusic",
                              arguments: {
                                "list": snapshot.data.charts,
                                "type": "Charts"
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  _buildList(context, loading: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Trending",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        GestureDetector(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/allmusic",
                              arguments: {
                                "list": snapshot.data.trending,
                                "type": "Trending"
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  _buildList(context, loading: true),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 15.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Top Playlist",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2.0,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Spacer(),
                        InkWell(
                          child: Text(
                            "View all",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              letterSpacing: 1.0,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/allmusic",
                              arguments: {
                                "list": snapshot.data.topPlaylists,
                                "type": "Top Playlists"
                              },
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  _buildList(context, loading: true),
                  SizedBox(height: 70.0),
                ],
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color accentColor = theme.accentColor;
    final OutlineInputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide.none,
    );
    final Color fillColor = theme.brightness == Brightness.dark
        ? Color(0xff424242)
        : Colors.black12;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              hintText: "Search Music Here",
              prefixIcon: Icon(
                Icons.search,
                color: accentColor,
              ),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  _textEditingController.clear();
                },
                color: accentColor,
              ),
              contentPadding: EdgeInsets.all(10.0),
              border: inputBorder,
              focusedBorder: inputBorder,
            ),
            cursorColor: accentColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (term) {
              if (_textEditingController.text != "") {
                databaseHelper.insert(
                    history:
                        History(_textEditingController.text, type: "music"));
                Navigator.pushNamed(context, "/musicresult",
                    arguments: _textEditingController.text);
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              label: Text(
                "SEARCH",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.music_note,
                color: Colors.white,
              ),
              onPressed: () {
                if (_textEditingController.text != "") {
                  databaseHelper.insert(
                      history:
                          History(_textEditingController.text, type: "music"));

                  Navigator.pushNamed(
                    context,
                    "/musicresult",
                    arguments: _textEditingController.text,
                  );
                }
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
            RaisedButton.icon(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: Text(
                "SETTINGS",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                Navigator.pushNamed(context, "/settings");
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: accentColor,
            ),
          ],
        )
      ],
    );
  }

  Widget _buildList(BuildContext context,
      {List<JioSaavnInfo> data, bool loading = false}) {
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final double width = mediaQueryData.size.width;
    return loading
        ? Container(
            height: width * 0.35,
            width: width * 0.40,
            child: LoadingWidget(),
          )
        : Container(
            height: width * 0.40,
            width: width * 0.40,
            padding: EdgeInsets.only(left: 5.0),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext ctxt, int index) {
                final JioSaavnInfo info = data[index];
                return MusicThumbnail(
                  url: info.image,
                  onpressed: () {
                    switch (info.type) {
                      case "album":
                        Navigator.of(context)
                            .pushNamed("/albuminfo", arguments: info.id);
                        break;
                      case "playlist":
                        Navigator.of(context)
                            .pushNamed("/playlistinfo", arguments: info.id);
                        break;
                      case "song":
                        Navigator.of(context)
                            .pushNamed("/musicinfo", arguments: info.id);
                        break;
                      default:
                    }
                  },
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
