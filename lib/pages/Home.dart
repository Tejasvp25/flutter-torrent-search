import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/database/DatabaseHelper.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textEditingController;
  final DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final Color accentColor = Theme.of(context).accentColor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.darkTheme
            ? Theme.of(context).backgroundColor
            : Colors.white,
        extendBodyBehindAppBar: true,
        body: Container(
            width: width,
            height: height,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 5.0),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Center(
                          child: Text(
                            "Torrent Search",
                            style: TextStyle(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/favourite");
                            },
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              Icons.history,
                              color: accentColor,
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, "/history");
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _buildSearch(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Recent Movies",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          InkWell(
                            child: Text("View all"),
                            onTap: () {
                              Navigator.pushNamed(context, "/allrecents",
                                  arguments: true);
                            },
                          ),
                        ],
                      ),
                    ),
                    _buildRecent(context),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Recent TV Shows",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          InkWell(
                            child: Text("View all"),
                            onTap: () {
                              Navigator.pushNamed(context, "/allrecents",
                                  arguments: false);
                            },
                          )
                        ],
                      ),
                    ),
                    _buildRecent(context, movies: false),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  Widget _buildSearch(BuildContext ctx) {
//    final double height = MediaQuery.of(ctx).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final double width = MediaQuery.of(ctx).size.width;
    final Color accentColor = Theme.of(context).accentColor;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: accentColor, width: 2.0),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: BorderSide(color: accentColor, width: 2.0),
              ),
            ),
            cursorColor: accentColor,
            keyboardType: TextInputType.text,
            maxLines: 1,
            textAlign: TextAlign.center,
            textInputAction: TextInputAction.search,
            onSubmitted: (term) async {
              if (_textEditingController.text != "") {
                await databaseHelper.insert(
                    history: History(_textEditingController.text));
                Navigator.pushNamed(context, "/result",
                    arguments: _textEditingController.text);
              }
            },
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        RaisedButton.icon(
          label: Text(
            "SEARCH",
            style: TextStyle(
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
          icon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            if (_textEditingController.text != "") {
              Navigator.pushNamed(context, "/result",
                  arguments: _textEditingController.text);
            }
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: accentColor,
        ),
        SizedBox(height: 10.0),
        RaisedButton.icon(
          icon: Icon(
            Icons.settings,
            color: Colors.white,
          ),
          label: Text(
            "Settings",
            style: TextStyle(
              letterSpacing: 2.0,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            Navigator.pushNamed(context, "/settings");
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          color: accentColor,
        ),
      ],
    );
  }

  Widget _buildRecent(BuildContext ctx, {movies = true}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borderRadius = BorderRadius.circular(5);
    final Color accentColor = Theme.of(context).accentColor;
    return Container(
      height: height * 0.27,
      width: width,
      padding: EdgeInsets.only(left: 5.0),
      child: FutureBuilder<List<RecentInfo>>(
          future: movies ? getRecentMovies() : getRecentSeries(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                separatorBuilder: (ctx, index) {
                  return SizedBox(
                    width: 5.0,
                  );
                },
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/recentinfo", arguments: {
                        "imdbcode": snapshot.data[index].imdbcode,
                        "imgurl": snapshot.data[index].imgUrl,
                      });
                    },
                    child: Container(
                      width: width * 0.40,
//                      height: height * 0.20,
                      child: Card(
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: snapshot.data[index].imgUrl,
                            progressIndicatorBuilder: (ctx, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      accentColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              switch (snapshot.error.runtimeType) {
                case NoContentFoundException:
                  return noContentFound();
                  break;
                case InternalServerError:
                  return serverError();
                  break;
                case SocketException:
                  return noInternet();
                  break;
                default:
                  return unExpectedError();
              }
            } else {
              return Center(
                  child: SpinKitThreeBounce(
                color: accentColor,
              ));
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
