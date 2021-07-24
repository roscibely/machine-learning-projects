final int n_pontos = 200; //<>//
final int n_discos = 23;

ArrayList<Disco[]> populacao = new ArrayList<Disco[]>();
ArrayList<Disco[]> nova_populacao = new ArrayList<Disco[]>();

Ponto[] pontos;
Disco [] filho;

void setup() {
  size(800, 700);
  filho = new Disco[n_discos];
  pontos = new Ponto[n_pontos];
  for (int i = 0; i < n_pontos; i++) {
    pontos[i] = new Ponto(random(0, width), random(0, height));
  } 
  /*Criando uma População*/
  for (int j = 0; j <10; j++) {
    for (int i = 0; i < n_discos; i++) {
      filho[i] = new Disco(random(0, width), random(0, height));
    }
    populacao.add(copia(filho));
  }
}
/*************************Algoritmo Genetico*******************************/
int fitness(Disco [] a) {
  boolean [] cobertos;
  cobertos = new boolean[n_pontos];
  int k=0;
  for (int i = 0; i < n_pontos; i++) {
    for (int j = 0; j < n_discos; j++) {
      if (cobertos[i]) continue;
      if (a[j].verifica(pontos[i])) {
        k++;
        cobertos[i]= true;
      }
    }
  }
  return k;
}

Disco[] seleciona() {
  int a = (int) random(0, populacao.size());
  int b = (int) random(0, populacao.size());
  if (fitness(populacao.get(a)) > fitness(populacao.get(b))) {
    return populacao.get(a);
  } else {
    return populacao.get(b);
  }
}

Disco[] cruzamento(Disco [] x, Disco[] y) {
  int a1, a2; 
  a1 = fitness(x);
  a2 = fitness(y);
  do {
    for (int j=0; j<n_discos; j++) {
      filho[j] = random(0.0, 1.0)>0.5?new Disco(x[j].getX(), x[j].getY()):new Disco(y[j].getX(), y[j].getY());
    }
  } while (fitness(filho)<a1 && fitness(filho)<a2);
  return filho;
}

void mutacao() {
  int i = (int) random(0, n_discos);
  filho[i] = new Disco(random(0, width), random(0, height));
}

/*ALGORITMO GENETICO*/
void AlgoritmoGenetico() {
  for (int j =0; j<100; j++) {
    if (fitness(filho)==n_pontos) return;
    for (int i = 0; i<populacao.size(); i++) {
      Disco[] x = seleciona();
      Disco[] y = seleciona();
      filho = cruzamento(x, y);
      println("Fitness Filho:"+fitness(filho));
      if (random(0.0, 1.0)<0.1)
        mutacao();
      nova_populacao.add(copia(filho));
    }
    for (int i = 0; i<populacao.size(); i++) {
      populacao.add(nova_populacao.get(i));
      populacao.remove(0);
    }
    for (int i =nova_populacao.size()-1; i>=0; i--) {
      nova_populacao.remove(i);
    }
  }
}

void draw() {
  background(135, 206, 235);
  for (int i = 0; i < n_pontos; i++)
    pontos[i].draw();
  for (int i = 0; i < n_discos; i++) {
    filho[i].draw();
  }
  AlgoritmoGenetico();
}

Disco [] copia(Disco [] a) {
  Disco [] b = new Disco[n_discos];
  for (int i=0; i<n_discos; i++) {
    b[i] = new Disco(a[i].getX(), a[i].getY());
  }
  return b;
}