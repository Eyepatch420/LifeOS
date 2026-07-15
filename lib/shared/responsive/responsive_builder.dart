import 'package:flutter/widgets.dart';
import 'package:lifeos/shared/responsive/breakpoints.dart';

/// Builds [tablet] when the available width is at/above
/// [kTabletBreakpoint], otherwise [phone]. Centralizes the phone/tablet
/// branch so features don't each re-derive their own `LayoutBuilder` check.
class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    required this.phone,
    required this.tablet,
    super.key,
  });

  final WidgetBuilder phone;
  final WidgetBuilder tablet;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth >= kTabletBreakpoint
            ? tablet(context)
            : phone(context);
      },
    );
  }
}
