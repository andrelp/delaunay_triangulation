import 'vertex.dart';
import 'dart:math';

class Edge {
  final Vertex p,q;
  Edge(this.p, this.q);

  @override
  bool operator == (dynamic other) => other is Edge && ((p == other.p && q == other.q) || (p == other.q && q == other.p));
  @override
  int get hashCode => p.hashCode ^ q.hashCode;
  
  Vertex computeClosestVertexOnEdge(Vertex vertex) {
    var pq = q-p;
    var t = (vertex-p).dot(pq) / pq.dot(pq);
    t = max(t, 0.0);
    t = min(t, 1.0);
    return p + (pq * t);
  }

}
