
import 'face.dart';
import 'edge.dart';
import 'face_collection.dart';
import 'vertex.dart';
import 'dart:math';

///Computes a delaunay triangulation of given points
class DelaunayTriangulation {
  Set<Vertex> _vertecies;
  Set<Face>   _faces;
  Set<Edge>   _edges;

  DelaunayTriangulation(Iterable<Vertex> inp) {
    var vertecies = <Vertex>{}..addAll(inp);
    var faceCollection = FaceCollection();

    if (vertecies.length < 3) {
      throw Exception('Triangulation with less than 3 points is not possible!');
    }

    var mag = vertecies.map((v) => max(v.x.abs(),v.y.abs())).reduce(max) * 16.0;
    var omega1 = Vertex(0.0,3.0*mag);
    var omega2 = Vertex(3.0*mag,0.0);
    var omega3 = Vertex(-3.0*mag,-3.0*mag);
    var omegaFace = Face(omega1, omega2, omega3);
    faceCollection.add(omegaFace);

    for (var vertex in vertecies) {
      var face = faceCollection.findContainingFace(vertex);
      if (face == null) {
        var edge = faceCollection.findNearestEdge(vertex);
        var adjacentFaces = faceCollection.findFacesSharingEdge(edge);
        
        if (adjacentFaces.length != 2) throw Exception('Edge adjacent to ${adjacentFaces.length} faces!');
        
        var first = adjacentFaces.first;
        var second  = adjacentFaces.last;

        var firstRemainingVertex = first.getRemainingVertex(edge);
        var secondRemainingVertex = second.getRemainingVertex(edge);

        var face1 = Face(edge.p, firstRemainingVertex, vertex);
        var face2 = Face(edge.q, firstRemainingVertex, vertex);
        var face3 = Face(edge.p, secondRemainingVertex, vertex);
        var face4 = Face(edge.q, secondRemainingVertex, vertex);
        
        faceCollection.remove(first);
        faceCollection.remove(second);

        faceCollection.add(face1);
        faceCollection.add(face2);
        faceCollection.add(face3);
        faceCollection.add(face4);

        _legalizeEdge(face1, Edge(edge.p, firstRemainingVertex), vertex, faceCollection);
        _legalizeEdge(face2, Edge(edge.q, firstRemainingVertex), vertex, faceCollection);
        _legalizeEdge(face3, Edge(edge.p, secondRemainingVertex), vertex, faceCollection);
        _legalizeEdge(face4, Edge(edge.q, secondRemainingVertex), vertex, faceCollection);
      } else {
        //Vertex vertex lies within face face

        var a = face.a;
        var b = face.b;
        var c = face.c;

        var first = Face(a, b, vertex);
        var second = Face(b, c, vertex);
        var third = Face(c, a, vertex);

        faceCollection.remove(face);

        faceCollection.add(first);
        faceCollection.add(second);
        faceCollection.add(third);

        _legalizeEdge(first,  Edge(a, b), vertex, faceCollection);
        _legalizeEdge(second, Edge(b, c), vertex, faceCollection);
        _legalizeEdge(third,  Edge(c, a), vertex, faceCollection);
      }
    }

    faceCollection.removeTrianglesUsing(omega1);
    faceCollection.removeTrianglesUsing(omega2);
    faceCollection.removeTrianglesUsing(omega3);

    //init fields
    _vertecies = vertecies;
    _faces = faceCollection.faces;
  }

  void _legalizeEdge(Face face, Edge edge, Vertex vertex, FaceCollection collection) {
    var neighbouringFace = collection.findNeighbouringEdge(face, edge);

    if (neighbouringFace != null && neighbouringFace.liesWithinCircumcircle(vertex)) {
      var noneEdgeVertex = neighbouringFace.getRemainingVertex(edge);

      var firstFace =Face(noneEdgeVertex, edge.p, vertex);
      var secondFace = Face(noneEdgeVertex, edge.q, vertex);

      collection.remove(face);
      collection.remove(neighbouringFace);
      
      collection.add(firstFace);
      collection.add(secondFace);

      _legalizeEdge(firstFace, Edge(noneEdgeVertex, edge.p), vertex, collection);
      _legalizeEdge(secondFace, Edge(noneEdgeVertex, edge.q), vertex, collection);
    }
  }

  Set<Vertex> get vertecies => _vertecies;
  Set<Face>   get faces     => _faces;
  Set<Edge>   get edges {
    if (_edges != null) {
      return _edges;
    }
    _edges = faces.map((face)=>face.edges).reduce((s,t)=>s.union(t));
    return _edges;
  }
}
