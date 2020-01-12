import 'dart:math';

class Vertex {
  final double x,y;
  const Vertex(this.x,this.y);

  @override
  bool operator == (dynamic other) => other is Vertex && other.x == x && other.y == y;
  @override
  int get hashCode => x.hashCode ^ y.hashCode;

  Vertex operator - (Vertex other)  => Vertex(x-other.x, y-other.y);
  Vertex operator + (Vertex other)  => Vertex(x+other.x, y+other.y);
  Vertex operator * (double factor) => Vertex(x*factor, y*factor);
  Vertex operator / (double div)    => Vertex(x/div, y/div);
  double get mag => sqrt(pow(x,2)+pow(y,2));
  double dot(Vertex other) => x*other.x + y*other.y;
  double cross(Vertex other) => y * other.x - x * other.y;

}