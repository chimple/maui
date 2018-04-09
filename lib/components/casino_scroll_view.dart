// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';

/// A controller for scroll views whose items have the same size.
///
/// Similar to a standard [ScrollController] but with the added convenience
/// mechanisms to read and go to item indices rather than a raw pixel scroll
/// offset.
///
/// See also:
///
///  * [CasinoScrollView], a scrollable view widget with fixed size items
///    that this widget controls.
///  * [CasinoMetrics], the `metrics` property exposed by
///    [ScrollNotification] from [CasinoScrollView] which can be used
///    to listen to the current item index on a push basis rather than polling
///    the [CasinoScrollController].
class CasinoScrollController extends FixedExtentScrollController {
  /// Creates a scroll controller for scrollables whose items have the same size.
  ///
  /// [initialItem] defaults to 0 and must not be null.
  CasinoScrollController({
    this.initialItem: 0,
  }) : assert(initialItem != null);

  /// The page to show when first creating the scroll view.
  ///
  /// Defaults to 0 and must not be null.
  final int initialItem;

  /// The currently selected item index that's closest to the center of the viewport.
  ///
  /// There are circumstances that this [CasinoScrollController] can't know
  /// the current item. Reading [selectedItem] will throw an [AssertionError] in
  /// the following cases:
  ///
  /// 1. No scroll view is currently using this [CasinoScrollController].
  /// 2. More than one scroll views using the same [CasinoScrollController].
  ///
  /// The [hasClients] property can be used to check if a scroll view is
  /// attached prior to accessing [selectedItem].
  int get selectedItem {
    assert(
    positions.isNotEmpty,
    'CasinoScrollController.selectedItem cannot be accessed before a '
        'scroll view is built with it.',
    );
    assert(
    positions.length == 1,
    'The selectedItem property cannot be read when multiple scroll views are '
    'attached to the same CasinoScrollController.',
    );
    final _CasinoScrollPosition position = this.position;
    return position.itemIndex;
  }

  /// Animates the controlled scroll view to the given item index.
  ///
  /// The animation lasts for the given duration and follows the given curve.
  /// The returned [Future] resolves when the animation completes.
  ///
  /// The `duration` and `curve` arguments must not be null.
  Future<Null> animateToItem(int itemIndex, {
    @required Duration duration,
    @required Curve curve,
  }) {
    if (!hasClients) {
      return new Future<Null>.value();
    }

    final List<Future<Null>> futures = <Future<Null>>[];
    for (_CasinoScrollPosition position in positions) {
      futures.add(position.animateTo(
        itemIndex * position.itemExtent,
        duration: duration,
        curve: curve,
      ));
    }
    return Future.wait(futures);
  }

  /// Changes which item index is centered in the controlled scroll view.
  ///
  /// Jumps the item index position from its current value to the given value,
  /// without animation, and without checking if the new value is in range.
  void jumpToItem(int itemIndex) {
    for (_CasinoScrollPosition position in positions) {
      position.jumpTo(itemIndex * position.itemExtent);
    }
  }

  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics, ScrollContext context, ScrollPosition oldPosition) {
    return new _CasinoScrollPosition(
      physics: physics,
      context: context,
      initialItem: initialItem,
      oldPosition: oldPosition,
    );
  }
}

/// Metrics for a [ScrollPosition] to a scroll view with fixed item sizes.
///
/// The metrics are available on [ScrollNotification]s generated from a scroll
/// views such as [CasinoScrollView]s with a [CasinoScrollController] and
/// exposes the current [itemIndex] and the scroll view's [itemExtent].
///
/// `Casino` refers to the fact that the scrollable items have the same size.
/// This is distinct from `Fixed` in the parent class name's [FixedScrollMetric]
/// which refers to its immutability.
class CasinoMetrics extends FixedScrollMetrics {
  /// Creates an immutable snapshot of values associated with a
  /// [CasinoScrollView].
  CasinoMetrics({
    @required double minScrollExtent,
    @required double maxScrollExtent,
    @required double pixels,
    @required double viewportDimension,
    @required AxisDirection axisDirection,
    @required this.itemIndex,
  }) : super(
    minScrollExtent: minScrollExtent,
    maxScrollExtent: maxScrollExtent,
    pixels: pixels,
    viewportDimension: viewportDimension,
    axisDirection: axisDirection,
  );

  @override
  CasinoMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return new CasinoMetrics(
      minScrollExtent: minScrollExtent ?? this.minScrollExtent,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      pixels: pixels ?? this.pixels,
      viewportDimension: viewportDimension ?? this.viewportDimension,
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }

  /// The scroll view's currently selected item index.
  final int itemIndex;
}

int _getItemFromOffset({
  double offset,
  double itemExtent,
  double minScrollExtent,
  double maxScrollExtent,
}) {
  return (_clipOffsetToScrollableRange(offset, minScrollExtent, maxScrollExtent) / itemExtent).round();
}

double _clipOffsetToScrollableRange(
    double offset,
    double minScrollExtent,
    double maxScrollExtent
    ) {
  return math.min(math.max(offset, minScrollExtent), maxScrollExtent);
}

/// A [ScrollPositionWithSingleContext] that can only be created based on
/// [_CasinoScrollable] and can access its `itemExtent` to derive [itemIndex].
class _CasinoScrollPosition extends ScrollPositionWithSingleContext implements CasinoMetrics {
  _CasinoScrollPosition({
    @required ScrollPhysics physics,
    @required ScrollContext context,
    @required int initialItem,
    bool keepScrollOffset: true,
    ScrollPosition oldPosition,
    String debugLabel,
  }) : assert(
  context is _CasinoScrollableState,
  'CasinoScrollController can only be used with CasinoScrollViews'
  ),
        super(
        physics: physics,
        context: context,
        initialPixels: _getItemExtentFromScrollContext(context) * initialItem,
        keepScrollOffset: keepScrollOffset,
        oldPosition: oldPosition,
        debugLabel: debugLabel,
      );

  static double _getItemExtentFromScrollContext(ScrollContext context) {
    final _CasinoScrollableState scrollable = context;
    return scrollable.itemExtent;
  }

  double get itemExtent => _getItemExtentFromScrollContext(context);

  @override
  int get itemIndex {
    return _getItemFromOffset(
      offset: pixels,
      itemExtent: itemExtent,
      minScrollExtent: minScrollExtent,
      maxScrollExtent: maxScrollExtent,
    );
  }

  @override
  CasinoMetrics copyWith({
    double minScrollExtent,
    double maxScrollExtent,
    double pixels,
    double viewportDimension,
    AxisDirection axisDirection,
    int itemIndex,
  }) {
    return new CasinoMetrics(
      minScrollExtent: minScrollExtent ?? this.minScrollExtent,
      maxScrollExtent: maxScrollExtent ?? this.maxScrollExtent,
      pixels: pixels ?? this.pixels,
      viewportDimension: viewportDimension ?? this.viewportDimension,
      axisDirection: axisDirection ?? this.axisDirection,
      itemIndex: itemIndex ?? this.itemIndex,
    );
  }
}

/// A [Scrollable] which must be given its viewport children's item extent
/// size so it can pass it on ultimately to the [CasinoScrollController].
class _CasinoScrollable extends Scrollable {
  const _CasinoScrollable({
    Key key,
    @required bool this.isRotated,
    ScrollController controller,
    ScrollPhysics physics,
    @required this.itemExtent,
    @required ViewportBuilder viewportBuilder,
  }) : super (
    key: key,
    axisDirection: isRotated ? AxisDirection.up : AxisDirection.down,
    controller: controller,
    physics: physics,
    viewportBuilder: viewportBuilder,
  );

  final double itemExtent;
  final bool isRotated;

  @override
  _CasinoScrollableState createState() => new _CasinoScrollableState();
}

/// This [ScrollContext] is used by [_CasinoScrollPosition] to read the
/// prescribed [itemExtent].
class _CasinoScrollableState extends ScrollableState {
  double get itemExtent {
    // Downcast because only _CasinoScrollable can make _CasinoScrollableState.
    final _CasinoScrollable actualWidget = widget;
    return actualWidget.itemExtent;
  }
}

/// A snapping physics that always lands directly on items instead of anywhere
/// within the scroll extent.
///
/// Behaves similarly to a slot machine wheel except the ballistics simulation
/// never overshoots and rolls back within a single item if it's to settle on
/// that item.
///
/// Must be used with a scrollable that uses a [CasinoScrollController].
///
/// Defers back to the parent beyond the scroll extents.
class CasinoScrollPhysics extends ScrollPhysics {
  /// Creates a scroll physics that always lands on items.
  const CasinoScrollPhysics({ ScrollPhysics parent }) : super(parent: parent);

  @override
  CasinoScrollPhysics applyTo(ScrollPhysics ancestor) {
    return new CasinoScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation createBallisticSimulation(ScrollMetrics position, double velocity) {
    assert(
    position is _CasinoScrollPosition,
    'CasinoScrollPhysics can only be used with Scrollables that uses '
        'the CasinoScrollController'
    );

    final _CasinoScrollPosition metrics = position;

    // Scenario 1:
    // If we're out of range and not headed back in range, defer to the parent
    // ballistics, which should put us back in range at the scrollable's boundary.
    if ((velocity <= 0.0 && metrics.pixels <= metrics.minScrollExtent) ||
        (velocity >= 0.0 && metrics.pixels >= metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // Create a test simulation to see where it would have ballistically fallen
    // naturally without settling onto items.
    final Simulation testFrictionSimulation =
    super.createBallisticSimulation(metrics, velocity);

    // Scenario 2:
    // If it was going to end up past the scroll extent, defer back to the
    // parent physics' ballistics again which should put us on the scrollable's
    // boundary.
    if (testFrictionSimulation != null
        && (testFrictionSimulation.x(double.infinity) == metrics.minScrollExtent
            || testFrictionSimulation.x(double.infinity) == metrics.maxScrollExtent)) {
      return super.createBallisticSimulation(metrics, velocity);
    }

    // From the natural final position, find the nearest item it should have
    // settled to.
    final int settlingItemIndex = _getItemFromOffset(
      offset: testFrictionSimulation?.x(double.infinity) ?? metrics.pixels,
      itemExtent: metrics.itemExtent,
      minScrollExtent: metrics.minScrollExtent,
      maxScrollExtent: metrics.maxScrollExtent,
    );

    final double settlingPixels = settlingItemIndex * metrics.itemExtent;

    // Scenario 3:
    // If there's no velocity and we're already at where we intend to land,
    // do nothing.
    if (velocity.abs() < tolerance.velocity
        && (settlingPixels - metrics.pixels).abs() < tolerance.distance) {
      return null;
    }

    // Scenario 4:
    // If we're going to end back at the same item because initial velocity
    // is too low to break past it, use a spring simulation to get back.
    if (settlingItemIndex == metrics.itemIndex) {
      return new SpringSimulation(
        spring,
        metrics.pixels,
        settlingPixels,
        velocity,
        tolerance: tolerance,
      );
    }

    // Scenario 5:
    // Create a new friction simulation except the drag will be tweaked to land
    // exactly on the item closest to the natural stopping point.
    return new FrictionSimulation.through(
      metrics.pixels,
      settlingPixels,
      velocity,
      tolerance.velocity * velocity.sign,
    );
  }
}

/// A box in which children on a wheel can be scrolled.
///
/// This widget is similar to a [ListView] but with the restriction that all
/// children must be the same size along the scrolling axis.
///
/// When the list is at the zero scroll offset, the first child is aligned with
/// the middle of the viewport. When the list is at the final scroll offset,
/// the last child is aligned with the middle of the viewport
///
/// The children are rendered as if rotating on a wheel instead of scrolling on
/// a plane.
class CasinoScrollView extends StatefulWidget {
  /// Creates a box in which children are scrolled on a wheel.
  const CasinoScrollView({
    Key key,
    this.controller,
    this.physics,
    this.diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
    this.perspective: RenderListWheelViewport.defaultPerspective,
    @required this.itemExtent,
    this.onSelectedItemChanged,
    this.clipToSize: true,
    this.isRotated = false,
    this.renderChildrenOutsideViewport: false,
    @required this.children,
  }) : assert(diameterRatio != null),
        assert(diameterRatio > 0.0, RenderListWheelViewport.diameterRatioZeroMessage),
  assert(perspective != null),
  assert(perspective > 0),
  assert(perspective <= 0.01, RenderListWheelViewport.perspectiveTooHighMessage),
  assert(itemExtent != null),
  assert(itemExtent > 0),
  assert(clipToSize != null),
  assert(renderChildrenOutsideViewport != null),
  assert(
  !renderChildrenOutsideViewport || !clipToSize,
  RenderListWheelViewport.clipToSizeAndRenderChildrenOutsideViewportConflict,
  ),
  super(key: key);

  /// Typically a [CasinoScrollController] used to control the current item.
  ///
  /// A [CasinoScrollController] can be used to read the currently
  /// selected/centered child item and can be used to change the current item.
  ///
  /// If none is provided, a new [CasinoScrollController] is implicitly
  /// created.
  ///
  /// If a [ScrollController] is used instead of [CasinoScrollController],
  /// [ScrollNotification.metrics] will no longer provide [CasinoMetrics]
  /// to indicate the current item index and [onSelectedItemChanged] will not
  /// work.
  ///
  /// To read the current selected item only when the value changes, use
  /// [onSelectedItemChanged].
  final ScrollController controller;

  /// How the scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to animate after the
  /// user stops dragging the scroll view.
  ///
  /// Defaults to matching platform conventions.
  final ScrollPhysics physics;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// Size of each child in the main axis. Must not be null and must be
  /// positive.
  final double itemExtent;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onSelectedItemChanged;

  /// {@macro flutter.rendering.wheelList.clipToSize}
  final bool clipToSize;

  /// {@macro flutter.rendering.wheelList.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// List of children to scroll on top of the cylinder.
  final List<Widget> children;

  final bool isRotated;

  @override
  _CasinoScrollViewState createState() => new _CasinoScrollViewState();
}

class _CasinoScrollViewState extends State<CasinoScrollView> {
  int _lastReportedItemIndex = 0;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = widget.controller ?? new CasinoScrollController();
    if (widget.controller is CasinoScrollController) {
      final CasinoScrollController controller = widget.controller;
      _lastReportedItemIndex = controller.initialItem;
    }
  }

  @override
  void didUpdateWidget(CasinoScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != null && widget.controller != scrollController) {
      final ScrollController oldScrollController = scrollController;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        oldScrollController.dispose();
      });
      scrollController = widget.controller;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification.depth == 0
            && widget.onSelectedItemChanged != null
            && notification is ScrollUpdateNotification
            && notification.metrics is CasinoMetrics) {
          final CasinoMetrics metrics = notification.metrics;
          final int currentItemIndex = metrics.itemIndex;
          if (currentItemIndex != _lastReportedItemIndex) {
            _lastReportedItemIndex = currentItemIndex;
            widget.onSelectedItemChanged(currentItemIndex);
          }
        }
        return false;
      },
      child: new _CasinoScrollable(
        controller: scrollController,
        physics: widget.physics,
        itemExtent: widget.itemExtent,
        isRotated: widget.isRotated,
        viewportBuilder: (BuildContext context, ViewportOffset offset) {
          return new ListWheelViewport(
            diameterRatio: widget.diameterRatio,
            perspective: widget.perspective,
            itemExtent: widget.itemExtent,
            clipToSize: widget.clipToSize,
            renderChildrenOutsideViewport: widget.renderChildrenOutsideViewport,
            offset: offset,
            children: widget.children,
          );
        },
      ),
    );
  }
}

/// A viewport showing a subset of children on a wheel.
///
/// Typically used with [CasinoScrollView], this viewport is similar to
/// [Viewport] in that it shows a subset of children in a scrollable based
/// on the scrolling offset and the childrens' dimensions. But uses
/// [RenderListWheelViewport] to display the children on a wheel.
///
/// See also:
///
///  * [CasinoScrollView], widget that combines this viewport with a scrollable.
///  * [RenderListWheelViewport], the render object that renders the children
///    on a wheel.
class ListWheelViewport extends MultiChildRenderObjectWidget {
  /// Create a viewport where children are rendered onto a wheel.
  ///
  /// The [diameterRatio] argument defaults to 2.0 and must not be null.
  ///
  /// The [perspective] argument defaults to 0.003 and must not be null.
  ///
  /// The [itemExtent] argument in pixels must be provided and must be positive.
  ///
  /// The [clipToSize] argument defaults to true and must not be null.
  ///
  /// The [renderChildrenOutsideViewport] argument defaults to false and must
  /// not be null.
  ///
  /// The [offset] argument must be provided and must not be null.
  ListWheelViewport({
    Key key,
    this.diameterRatio: RenderListWheelViewport.defaultDiameterRatio,
    this.perspective: RenderListWheelViewport.defaultPerspective,
    @required this.itemExtent,
    this.clipToSize: true,
    this.renderChildrenOutsideViewport: false,
    @required this.offset,
    List<Widget> children,
  }) : assert(offset != null),
        assert(diameterRatio != null),
        assert(diameterRatio > 0, RenderListWheelViewport.diameterRatioZeroMessage),
  assert(perspective != null),
  assert(perspective > 0),
  assert(perspective <= 0.01, RenderListWheelViewport.perspectiveTooHighMessage),
  assert(itemExtent != null),
  assert(itemExtent > 0),
  assert(clipToSize != null),
  assert(renderChildrenOutsideViewport != null),
  assert(
  !renderChildrenOutsideViewport || !clipToSize,
  RenderListWheelViewport.clipToSizeAndRenderChildrenOutsideViewportConflict,
  ),
  super(key: key, children: children);

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// {@macro flutter.rendering.wheelList.itemExtent}
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.clipToSize}
  final bool clipToSize;

  /// {@macro flutter.rendering.wheelList.renderChildrenOutsideViewport}
  final bool renderChildrenOutsideViewport;

  /// [ViewportOffset] object describing the content that should be visible
  /// in the viewport.
  final ViewportOffset offset;

  @override
  RenderListWheelViewport createRenderObject(BuildContext context) {
    return new RenderListWheelViewport(
      diameterRatio: diameterRatio,
      perspective: perspective,
      itemExtent: itemExtent,
      clipToSize: clipToSize,
      renderChildrenOutsideViewport: renderChildrenOutsideViewport,
      offset: offset,
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderListWheelViewport renderObject) {
    renderObject
      ..diameterRatio = diameterRatio
      ..perspective = perspective
      ..itemExtent = itemExtent
      ..clipToSize = clipToSize
      ..renderChildrenOutsideViewport = renderChildrenOutsideViewport
      ..offset = offset;
  }
}