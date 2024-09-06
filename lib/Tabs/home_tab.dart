import 'package:flutter/cupertino.dart';

import '../HomeUI/newReleasesItems.dart';
import '../HomeUI/popularItems.dart';
import '../HomeUI/recomendedItems.dart';


class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
 return
      Column(
        children: [
          Popularitems(),
          Newreleasesitems(),
          SizedBox(height:15),
          Recomendeditems(),

        ],
      );
  }
}
