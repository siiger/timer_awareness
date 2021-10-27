import 'dart:math';

class MathUtil {
  MathUtil._();

  static int random(min, max) {
    var rn = new Random();
    return min + rn.nextInt(max - min);
  }

  //Function to divide randomly 'primaryList' into 'numParts' parts by the period 'lengthRandy'
  static List<List<DateTime>> randomlyDivideListIntoNumPartsLists(
      int numParts, List<DateTime> primaryList, int lengthRandy) {
    int lengthListRandy = lengthRandy * numParts;
    int numRandy = primaryList.length ~/ lengthListRandy;
    //int lengthOneList = (numRandy * lengthListRandy) ~/ numPart;

    var tList = List<List<DateTime>>.generate(numParts, (i) => []);
    int k = 0;
    var rn = new Random();
    for (int i = 0; i < numRandy - 1; ++i) {
      var res = primaryList.getRange(k, k + lengthListRandy).toList();
      k = k + lengthListRandy;
      for (int j = 0; j < numParts; ++j) {
        for (int n = 0; n < lengthRandy; ++n) {
          int ite = rn.nextInt(res.length);
          tList[j].add(res[ite]);
          res.removeAt(ite);
        }
      }
    }

    return tList;
  }
}
