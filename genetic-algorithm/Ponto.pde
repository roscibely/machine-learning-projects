class Ponto {
  float x;
  float y;

  Ponto(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void draw(){
    fill(0,0,0);
    ellipse(x, y, 2, 2);
  }
  
}