class Disco {
  private float x;
  private float y;
  private float r = 90;

  Disco(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void draw() {
    fill(61, 255, 245, 50);
    ellipse(x, y, 2*r, 2*r);
  }

  void setX(float x) {
    this.x = x;
  }

  void setY(float y) {
    this.y = y;
  }

  float getX() {
    return this.x;
  }
  
  float getY() {
    return this.y;
  }

  void setPonto(float x, float y) {
    this.x = x;
    this.y = y;
  }

  boolean verifica(Ponto p) {
    if (dist(p.x, p.y, x, y) <= r) return true;
    return false;
  }
  

}