import 'package:delaunay_triangulation/src/util.dart';

import 'edge.dart';
import 'vertex.dart';

///Representation of a triangular face in a triangulation
///Order of vertecies is irrelevant and two triangles are
///consired to be euqual (by evaluating equal operator or
///computing hash function) if the (unoredered) sets of 
///their three enclosing vertecies are equal.
class Face {
  final Vertex a,b,c;
  Face(this.a,this.b,this.c);

  @override
  bool operator == (dynamic other)
   => other is Face && <Vertex>{a,b,c}.union(<Vertex>{other.a,other.b,other.c}).length == 3;

  @override
  int get hashCode => a.hashCode ^ b.hashCode ^ c.hashCode;

  bool contains(Vertex vertex) {
    var pab =  (vertex - a).cross(b - a);
    var pbc = (vertex - b).cross(c - b);

    if (!(pab.sign == pbc.sign)) {
        return false;
    }

    var pca = (vertex - c).cross(a - c);

    if (!(pab.sign == pca.sign)) {
        return false;
    }

    return true;
  }

  bool get hasCounterClockwiseOrientation {
    var a11 = a.x - c.x;
    var a21 = b.x - c.x;

    var a12 = a.y - c.y;
    var a22 = b.y - c.y;

    var det = a11 * a22 - a12 * a21;

    return det > 0.0;
  }

  bool liesWithinCircumcircle(Vertex vertex) {
    var a11 = a.x - vertex.x;
    var a21 = b.x - vertex.x;
    var a31 = c.x - vertex.x;

    var a12 = a.y - vertex.y;
    var a22 = b.y - vertex.y;
    var a32 = c.y - vertex.y;

    var a13 = (a.x - vertex.x) * (a.x - vertex.x) + (a.y - vertex.y) * (a.y - vertex.y);
    var a23 = (b.x - vertex.x) * (b.x - vertex.x) + (b.y - vertex.y) * (b.y - vertex.y);
    var a33 = (c.x - vertex.x) * (c.x - vertex.x) + (c.y - vertex.y) * (c.y - vertex.y);

    var det = a11 * a22 * a33 + a12 * a23 * a31 + a13 * a21 * a32 - a13 * a22 * a31 - a12 * a21 * a33
            - a11 * a23 * a32;

    if (hasCounterClockwiseOrientation) {
        return det > 0;
    } else {
      return det < 0;
    }
  }

  bool isNeighbour(Edge edge)
    => <Vertex>{edge.p,edge.q}.intersection(<Vertex>{a,b,c}).length == 2;
  
  Pair<Edge, double> nearestEdge(Vertex vertex) {
    var ab = Edge(a, b);
    var ac = Edge(a, c);
    var bc = Edge(b, c);
    var list = <Pair<Edge,double>>[
      for (var e in [ab,ac,bc])
        Pair(e, (e.computeClosestVertexOnEdge(vertex)-vertex).mag),
    ];
    list.sort((s,t) => s.second.compareTo(t.second));
    return list[0];
  }

  Vertex getRemainingVertex(Edge edge) {
    return <Vertex>{a,b,c}.difference(<Vertex>{edge.p,edge.q}).first;
  }

  Set<Edge> get edges => <Edge>{Edge(a,b),Edge(a,c),Edge(b,c)};

  Vertex get centroid => (a+b+c)/3;
}