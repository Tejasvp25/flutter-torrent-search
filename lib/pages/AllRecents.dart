import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class AllRecents extends StatefulWidget {
  @override
  _AllRecentsState createState() => _AllRecentsState();
}

class _AllRecentsState extends State<AllRecents> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final BorderRadius borderRadius = BorderRadius.circular(5);

    bool movies = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: movies
              ? getRecentMovies(longList: true)
              : getRecentSeries(longList: true),
          builder:
              (BuildContext ctx, AsyncSnapshot<List<RecentInfo>> snapshot) {
            if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.all(5.0),
                child: Container(
                  child: GridView.count(
                    physics: ScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    crossAxisCount: 3,
                    mainAxisSpacing: 5.0,
                    crossAxisSpacing: 5.0,
                    childAspectRatio: (((width+48) / 2)/(height /2)),
                    children: snapshot.data.map((e) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/recentinfo",
                              arguments: {
                                "imdbcode": e.imdbcode,
                                "imgurl": e.imgUrl,
                              });
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: borderRadius),
                          child: ClipRRect(
                            borderRadius: borderRadius,
                            child: CachedNetworkImage(
                              fit: BoxFit.fill,
                              imageUrl: e.imgUrl,
                              progressIndicatorBuilder:
                                  (ctx, url, progress) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).accentColor),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey
                    : Theme.of(context).accentColor,
              ));
            }
          },
        ),
      ),
    );
  }
}
