import 'package:delaunay_triangulation/delaunay_triangulation.dart';
import 'dart:math';

void main() {
  var random = Random();
  var randPoints = List<Vertex>.generate(700, (_) {
    return Vertex(random.nextDouble()*1000, random.nextDouble()*1000);
  });
  var triangulation = DelaunayTriangulation(randPoints);
}
