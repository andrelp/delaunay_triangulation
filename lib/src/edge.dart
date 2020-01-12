import 'vertex.dart';
import 'dart:math';

///Represents an Edge. The order of its vertecies is irrelevant and
///two Edges are considered to be the same (by the equal operator and
///by their hashCode) if the unordered sets of their endpoints is equal
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
