import 'dart:io';
import 'package:delaunay_triangulation/delaunay_triangulation.dart';
import 'package:image/image.dart';
import 'dart:math';

void main() {
  var random = Random();
  var randPoints = List<Vertex>.generate(500, (_) {
    return Vertex(random.nextDouble()*499, random.nextDouble()*499);
  });
  var edges = DelaunayTriangulation(randPoints).edges;

  //creating image of delaunay triangulation
  var img = Image(500, 500);

  //drawing points
  for (var p in randPoints) {
    var x = p.x.floor();
    var y = p.y.floor();
    drawCircle(img, x, y, 3, Color.fromRgb(255, 255, 255));
  }

  //drawing egdes:
  for (var e in edges) {
    var a = e.p;
    var b = e.q;
    drawLine(img, a.x.floor(), a.y.floor(), b.x.floor(), b.y.floor(), Color.fromRgb(255, 255, 255));
  }

  //save visual image of delaunay triangulation
  File('output.png')..writeAsBytesSync(encodePng(img));
}
