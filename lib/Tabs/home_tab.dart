import 'package:flutter/cupertino.dart';

import '../UI/newReleasesItems.dart';
import '../UI/popularItems.dart';
import '../UI/recomendedItems.dart';

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
