import 'dart:math' as math;

import 'package:flutter/material.dart';

class CollapsingToolbar extends StatefulWidget {
  final ScrollController controller;
  final double expandedHeight;
  final double collapsedHeight;
  final Function(double offset) onCollapsing;
  final Curve animationCurve;
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final Widget Function(BuildContext context, int index) featureIconBuilder;
  final Widget Function(BuildContext context, int index) featureLabelBuilder;
  final int featureCount;
  final double horizontalPadding;
  final double verticalPadding;
  final ButtonStyle? featureButtonStyle;
  final double featureCollapsedFactor;
  final Function(BuildContext context, int index) featureOnPressed;

  const CollapsingToolbar({
    Key? key,
    required this.controller,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.onCollapsing,
    this.animationCurve: Curves.easeIn,
    this.leading,
    this.title,
    this.actions,
    required this.featureIconBuilder,
    required this.featureCount,
    required this.featureLabelBuilder,
    this.horizontalPadding: 12,
    this.verticalPadding: 12,
    this.featureButtonStyle,
    this.featureCollapsedFactor: 0.6,
    required this.featureOnPressed,
  }) : super(key: key);

  @override
  _CollapsingToolbarState createState() => _CollapsingToolbarState();
}

class _CollapsingToolbarState extends State<CollapsingToolbar> {
  late double toolbarHeight;
  double animationValue = 1.0;

  @override
  void initState() {
    toolbarHeight = widget.expandedHeight;
    widget.controller.addListener(this.onScrolling);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(this.onScrolling);
    super.dispose();
  }

  void onScrolling() {
    setState(() {
      var offset = widget.controller.offset;
      var max = widget.expandedHeight;
      var min = widget.collapsedHeight;
      var gap = max - min;
      var factor = math.min(1.0, math.max(0.0, offset / gap));
      animationValue = 1 - widget.animationCurve.transform(factor);
      toolbarHeight = max - factor * gap;
      widget.onCollapsing(factor * gap);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade800,
      height: toolbarHeight,
      child: Stack(
        children: [
          Container(
            height: widget.collapsedHeight,
            child: AppBar(
              primary: false,
              toolbarHeight: widget.collapsedHeight,
              backgroundColor: Colors.transparent,
              centerTitle: false,
              titleSpacing: widget.horizontalPadding,
              elevation: 0.0,
              leading: widget.leading,
              title: Opacity(
                opacity: animationValue,
                child: Transform.scale(
                  child: widget.title,
                  alignment: Alignment.centerLeft,
                  scale: animationValue,
                ),
              ),
              actions: widget.actions,
            ),
          ),
          Align(
            alignment: Tween<Alignment>(
                    end: Alignment.bottomCenter, begin: Alignment.topLeft)
                .transform(animationValue),
            child: Padding(
              padding: EdgeInsetsTween(
                  begin: EdgeInsets.only(
                      left: widget.collapsedHeight,
                      top: widget.verticalPadding),
                  end: EdgeInsets.only(
                    bottom: widget.verticalPadding,
                    left: widget.horizontalPadding,
                    right: widget.horizontalPadding,
                  )).transform(animationValue),
              child: Transform.scale(
                alignment: Alignment.centerLeft,
                scale: Tween(begin: widget.featureCollapsedFactor, end: 1.0)
                    .transform(animationValue),
                child: Row(
                  children: List.generate(widget.featureCount, (index) {
                    return Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          widget.featureOnPressed(context, index);
                        },
                        child: FittedBox(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              widget.featureIconBuilder(context, index),
                              Opacity(
                                opacity: animationValue,
                                child: Transform.scale(
                                  alignment: Alignment.topCenter,
                                  scale: animationValue,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: widget.verticalPadding * 0.7),
                                    child: widget.featureLabelBuilder(
                                        context, index),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        style: widget.featureButtonStyle ??
                            ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              elevation: MaterialStateProperty.all(0.0),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
