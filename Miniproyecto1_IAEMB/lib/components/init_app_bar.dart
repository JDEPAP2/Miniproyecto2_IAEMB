// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:shop_app/providers/app_color_provider.dart';
// import 'package:shop_app/components/categories_dropdown.dart';
// import 'package:shop_app/providers/lock_provider.dart';

// import '../screens/cart/cart_screen.dart';
// import 'icon_btn_with_counter.dart';

// class InitAppBar extends ConsumerWidget {
//   const InitAppBar({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(child: CategoriesDropDown()),
//           const SizedBox(width: 16),
//           IconBtnWithCounter(
//             icon: FaIcon(FontAwesomeIcons.lock, color: ref.watch(AppColorProvider).primary),
//             press: () => ref.read(lockProvider.notifier).clearState(),
//           ),
//           const SizedBox(width: 8),
//           // IconBtnWithCounter(
//           //   svgSrc: "assets/icons/Bell.svg",
//           //   numOfitem: 3,
//           //   press: () {},
//           // ),
//         ],
//       ),
//     );
//   }
// }
