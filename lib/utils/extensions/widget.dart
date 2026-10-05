import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:project_tmp/utils/constants/dimens.dart';
import 'package:project_tmp/utils/extensions/num.dart';

extension ExtendWidget on Widget {
  RenderObjectWidget get sliver {
    return SliverToBoxAdapter(
      child: this,
    );
  }

  Widget pt(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).pt(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).pt(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.pt,
        child: this,
      );
    }
  }

  Widget pb(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).pb(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).pb(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.pb,
        child: this,
      );
    }
  }

  Widget pr(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).pr(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).pr(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.pr,
        child: this,
      );
    }
  }

  Widget pl(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).pl(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).pl(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.pl,
        child: this,
      );
    }
  }

  Widget px(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).px(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).px(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.px,
        child: this,
      );
    }
  }

  Widget pxy(double sizeX, double sizeY) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: sizeY, horizontal: sizeX),
      child: this,
    );
  }

  Widget py(double size) {
    if (this is Padding) {
      return Padding(
        padding: ((this as Padding).padding as EdgeInsets).py(size),
        child: (this as Padding).child,
      );
    } else if (this is SliverPadding) {
      return SliverPadding(
        padding: ((this as SliverPadding).padding as EdgeInsets).py(size),
        sliver: (this as SliverPadding).child,
      );
    } else {
      return Padding(
        padding: size.py,
        child: this,
      );
    }
  }

  Widget p(double size) {
    return Padding(
      padding: size.p,
      child: this,
    );
  }

  Widget get ps {
    return p(AppDimens.marginX);
  }

  Widget get psx {
    return px(AppDimens.marginX);
  }

  Widget get psy {
    return py(AppDimens.marginX);
  }

  Widget rotate({
    Duration speed = const Duration(milliseconds: 1500),
    bool antiClockwise = false,
  }) {
    return _RotateWidget(
      speed: speed,
      antiClockwise: antiClockwise,
      child: this,
    );
  }

  Widget move(double x, double y) {
    return Transform.translate(
      offset: Offset(x, y),
      child: this,
    );
  }

  Widget heartbeat({
    Duration speed = const Duration(milliseconds: 2500),
  }) {
    return _HeartbeatWidget(
      speed: speed,
      child: this,
    );
  }
}

extension ListExtension on List {
  List<T> separator<T>(T Function(int index) separatorBuilder) {
    var result = List<T>.empty(growable: true);
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(separatorBuilder(i));
      }
    }
    return result;
  }
}

class _HeartbeatWidget extends StatefulWidget {
  final Widget child;
  final Duration speed;

  const _HeartbeatWidget({
    super.key,
    required this.child,
    required this.speed,
  });

  @override
  State<_HeartbeatWidget> createState() => _HeartbeatWidgetState();
}

class _HeartbeatWidgetState extends State<_HeartbeatWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.speed,
      lowerBound: 0,
      upperBound: 2 * math.pi,
    );

    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Transform.scale(
          scale: 1 + math.sin(animationController.value) * 0.1,
          child: widget.child,
        );
      },
    );
  }
}

class _RotateWidget extends StatefulWidget {
  final Widget child;
  final Duration speed;
  final bool antiClockwise;

  const _RotateWidget({
    required this.child,
    required this.speed,
    this.antiClockwise = false,
  });

  @override
  State<_RotateWidget> createState() => _RotateWidgetState();
}

class _RotateWidgetState extends State<_RotateWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: widget.speed,
      lowerBound: 0,
      upperBound: 2 * math.pi,
    );

    animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (
        context,
        child,
      ) {
        return Transform.rotate(
          angle: animationController.value * (widget.antiClockwise ? -1 : 1),
          child: child,
        );
      },
    );
  }
}








extension EdgeInsetsExtension on EdgeInsets {
EdgeInsets pt(double size) {
  return copyWith(
    top: size,
  );
}

EdgeInsets pb(double size) {
  return copyWith(
    bottom: size,
  );
}

EdgeInsets pl(double size) {
  return copyWith(
    left: size,
  );
}

EdgeInsets pr(double size) {
  return copyWith(
    right: size,
  );
}

EdgeInsets px(double size) {
  return copyWith(
    left: size,
    right: size,
  );
}

EdgeInsets py(double size) {
  return copyWith(
    top: size,
    bottom: size,
  );
}}