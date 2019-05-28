import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/product.dart';
import '../../scoped-models/main.dart';

class ProductFAB extends StatefulWidget {
  final Product product;

  ProductFAB(this.product);

  @override
  State<StatefulWidget> createState() {
    return _ProductFABState();
  }
}

class _ProductFABState extends State<ProductFAB> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
                  parent: _controller,
                ),
                child: FloatingActionButton(
                  heroTag: 'contact',
                  backgroundColor: Theme.of(context).cardColor,
                  mini: true,
                  onPressed: () async {
                    final url = 'mailto:${widget.product.userEmail}';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch';
                    }
                  },
                  child: Icon(
                    Icons.mail,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            Container(
              height: 70.0,
              width: 56.0,
              alignment: FractionalOffset.topCenter,
              child: ScaleTransition(
                scale: CurvedAnimation(
                  curve: Interval(0.0, 0.5, curve: Curves.easeInOut),
                  parent: _controller,
                ),
                child: FloatingActionButton(
                  heroTag: 'favorite',
                  backgroundColor: Theme.of(context).cardColor,
                  mini: true,
                  onPressed: model.toggleProductFavoriteStatus,
                  child: Icon(
                      model.selectedProduct.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: Colors.red),
                ),
              ),
            ),
            FloatingActionButton(
              heroTag: 'more',
              onPressed: () {
                if (_controller.isDismissed) {
                  _controller.forward();
                } else {
                  _controller.reverse();
                }
              },
              child: AnimatedBuilder(
                animation: _controller,
                builder: (
                  BuildContext context,
                  Widget child,
                ) {
                  return Transform(
                    transform:
                        Matrix4.rotationZ(_controller.value * 0.5 * math.pi),
                    alignment: FractionalOffset.center,
                    child: Icon(_controller.isDismissed
                        ? Icons.more_vert
                        : Icons.close),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
