

import 'package:delaunay_triangulation/src/vertex.dart';
import 'edge.dart';
import 'face.dart';

class FaceCollection {

  final Set<Face> faces;
  FaceCollection() : faces = {};

  void add(Face face) => faces.add(face);
  void remove(Face face) => faces.remove(face);

  Face findContainingFace(Vertex vertex) {
    for (var face in faces) {
      if (face.contains(vertex)) {
        return face;
      }
    }
    return null;
  }

  Edge findNearestEdge(Vertex vertex) {
    var list = [
      for (var face in faces)
        face.nearestEdge(vertex)
    ];
    list.sort((s,t)=>s.second.compareTo(t.second));
    return list[0].first;
  }

  Set<Face> findFacesSharingEdge(Edge egde) {
    var adjacent = <Face>{};
    for (var face in faces) {
      if (face.isNeighbour(egde)) {
        adjacent.add(face);
      }
    }
    return adjacent;
  }

  Face findNeighbouringEdge(Face face, Edge edge) {
    var nei = findFacesSharingEdge(edge);
    nei.removeWhere((f)=>f==face);
    if (nei.isNotEmpty) {
      return nei.first;
    } else {
      return null;
    }
  }

  void removeTrianglesUsing(Vertex vertex) {
    faces.removeWhere((face) => <Vertex>{face.a,face.b,face.c}.contains(vertex));
  }

}