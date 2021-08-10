import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'collapsing_toolbar_decoration.dart';

const Color _kDefaultBackgroundColor = Colors.white;
const Color _kDefaultForegroundColor = Color(0xfff42222);

/// It helps you in creating a Romantic Collapsing Toolbar.
/// This widget is created to be able to standalone with any views, helps you able to add it into any complex ScrollView or ListView.
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
  final Color decorationBackgroundColor;
  final Color decorationForegroundColor;
  final bool useDefaultDecoration;

  /// Create a CollapsingToolbar.
  ///
  /// [controller] is the [ScrollController] of your current scroll view, it's used to listen the scrolling offset and calculate the animation value.
  /// [collapsedHeight] & [expandedHeight] are required to handle the animation.
  /// [onCollapsing] is a callback function, it is important because it is a part that help this widget can standalone with the scroll view. During scrolling, you need to use its offset value to make a padding for your scroll|list view. For more details please see the example.
  /// [animationCurve] it helps the collapsing effect more excited.
  /// There is an [AppBar] in this. It helps easier to handle some regular features such as: a [leading] action, list of right [actions] and the [title] of the screen.
  ///
  /// [featureIconBuilder] & [featureLabelBuilder] & [featureOnPressed] & [featureButtonStyle], they help you can create your own styled feature buttons easier. [featureButtonStyle] is used to create the pressing effect.
  /// [featureCount] is count of your feature buttons. Tips: many regular designs use only 4 feature buttons.
  /// [featureCollapsedFactor] is the scale of the [Row] of feature buttons when it is collapsed.
  ///
  /// [horizontalPadding] & [verticalPadding] are used to set padding and margin the whole widget.
  ///
  /// [useDefaultDecoration] : if you want not to use the default [CollapsingToolbarDecoration], set it to false, default is true.
  ///
  /// [decorationBackgroundColor] & [decorationForegroundColor] are used to draw the default [CollapsingToolbarDecoration].
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
    required this.featureLabelBuilder,
    required this.featureCount,
    this.featureButtonStyle,
    this.featureCollapsedFactor: 0.6,
    required this.featureOnPressed,
    this.horizontalPadding: 12,
    this.verticalPadding: 12,
    this.decorationBackgroundColor: _kDefaultBackgroundColor,
    this.decorationForegroundColor: _kDefaultForegroundColor,
    this.useDefaultDecoration: true,
  }) : super(key: key);

  @override
  _CollapsingToolbarState createState() => _CollapsingToolbarState();
}

class _CollapsingToolbarState extends State<CollapsingToolbar> {
  late double _toolbarHeight;
  double _animationValue = 1.0;

  @override
  void initState() {
    _toolbarHeight = widget.expandedHeight;
    widget.controller.addListener(this._onScrolling);
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.removeListener(this._onScrolling);
    super.dispose();
  }

  void _onScrolling() {
    setState(() {
      var offset = widget.controller.offset;
      var max = widget.expandedHeight;
      var min = widget.collapsedHeight;
      var gap = max - min;
      var factor = math.min(1.0, math.max(0.0, offset / gap));
      _animationValue = 1 - widget.animationCurve.transform(factor);
      _toolbarHeight = max - factor * gap;
      widget.onCollapsing(factor * gap);
    });
  }

  @override
  Widget build(BuildContext context) {
    var body = Container(
      height: _toolbarHeight,
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
                opacity: _animationValue,
                child: Transform.scale(
                  child: widget.title,
                  alignment: Alignment.centerLeft,
                  scale: _animationValue,
                ),
              ),
              actions: widget.actions,
            ),
          ),
          Align(
            alignment: Tween<Alignment>(
                    end: Alignment.bottomCenter, begin: Alignment.topLeft)
                .transform(_animationValue),
            child: Padding(
              padding: EdgeInsetsTween(
                  begin: EdgeInsets.only(
                      left: widget.collapsedHeight,
                      top: widget.verticalPadding),
                  end: EdgeInsets.only(
                    bottom: widget.verticalPadding,
                    left: widget.horizontalPadding,
                    right: widget.horizontalPadding,
                  )).transform(_animationValue),
              child: Transform.scale(
                alignment: Alignment.centerLeft,
                scale: Tween(begin: widget.featureCollapsedFactor, end: 1.0)
                    .transform(_animationValue),
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
                                opacity: _animationValue,
                                child: Transform.scale(
                                  alignment: Alignment.topCenter,
                                  scale: _animationValue,
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
    return widget.useDefaultDecoration
        ? CollapsingToolbarDecoration(
            animationValue: _animationValue,
            backgroundColor: widget.decorationBackgroundColor,
            foregroundColor: widget.decorationForegroundColor,
            child: body,
          )
        : body;
  }
}
