Library which can compute a two-dimensional delaunay triangulation for a given set of points.

## Usage

```dart
import 'package:delaunay_triangulation/delaunay_triangulation.dart';

main() {
  var triangulation = DelaunayTriangulation(<Vertex>{
    Vertex(1.1,-2.0),
    Vertex(4.2,7.4),
    Vertex(12,-33.44),
    //...
  });
}
```
