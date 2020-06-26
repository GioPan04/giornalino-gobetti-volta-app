import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giornalino_gv_app/models/EditionModel.dart';

class EditionThumbnail extends StatelessWidget {

  final Edition data;
  final Function(Edition) onTap;

  const EditionThumbnail(this.data, {Key key, this.onTap}) : super(key: key);
  
  Widget _buildThumnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: CachedNetworkImage(
        imageUrl: data.thumbnailUrl,
        width: 90,
        height: 140,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      data.title,
      style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 17, fontWeight: FontWeight.w600 ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildThumnail(),
          SizedBox(width: 7,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildTitle(context),
                Text("Autore: ${data.author}", style: TextStyle(color: Colors.white54),),
                Text("Pubblicato il: ${data.timestamp}", style: TextStyle(color: Colors.white54),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}