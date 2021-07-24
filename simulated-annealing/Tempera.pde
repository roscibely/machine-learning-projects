final int n_pontos = 250; //<>//
final int n_discos = 20;

Disco[] atual;
Disco[] proximo;
Ponto[] pontos;

void setup() {
  size(800, 700);
  atual = new Disco[n_discos];
  pontos = new Ponto[n_pontos];
  proximo = new Disco[n_pontos];
  for (int i = 0; i < n_pontos; i++) {
    pontos[i] = new Ponto(random(0, width), random(0, height));
  }
  for (int i = 0; i < n_discos; i++) {
    atual[i] = new Disco(random(0, width), random(0, height));
    proximo[i] = new Disco(0, 0);
  }
} 

void draw() {
  background(135,206,235);
  for (int i = 0; i < n_pontos; i++)
    pontos[i].draw();
  for (int i = 0; i < n_discos; i++)
    atual[i].draw();
    //for(int k=0; k<=100; k++)
      temperaSimulada();
}

/*TÊMPERA SIMULADA*/
float T = 1000;
int n = 1000;
int deltaE;
void temperaSimulada() {
  if (valor(atual)==n_pontos) return;
  for (int i=0; i<n; i++) {
    T = escalonamento(T);
    sucessor();
    deltaE = valor(proximo) - valor(atual);
    if (deltaE>0) {
      for (int j=0; j<n_discos; j++) {
        atual[j] = proximo[j];
      }
    } 
    else {
      if (random(0, 1)<=exp(deltaE/T)){
        for (int k=0; k<n_discos; k++) {
            atual[k] = proximo[k];
        }
      }
    }
  }
}

float escalonamento(float t){
  float T = 0.99*t;
  return T;
}

/*Função para verificar se os pontos estão contidos nos discos*/
int valor(Disco[] _atual){ 
  int k = 0;
  for (int i = 0; i < n_pontos; i++) {
    for (int j = 0; j < n_discos; j++)
      if (_atual[j].verifica(pontos[i])) {
        k++;
        break;
      }
  }
  return k;
}

/*Função sucessor ou mutação*/
void sucessor(){
  for (int i=0; i<atual.length; i++) {
    proximo[i].setPonto(atual[i].x, atual[i].y);
  }
  int i = (int) random(0, n_discos);
  proximo[i] = new Disco(random(0, width), random(0, height));
}