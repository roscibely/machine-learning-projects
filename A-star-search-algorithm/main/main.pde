int N=3;

Estado e = new Estado(); //Estado inicial inicializado pela função embaralha()

//Retorna o estado de menor avaliação
Estado queue_dropMenor(ArrayList<Estado> queue) {
  float menorAvaliacao = queue.get(0).g;
  int p = 0;
  for (int i=1; i<queue.size(); i++) {
    if (queue.get(i).g<menorAvaliacao) {
      menorAvaliacao = queue.get(i).f;
      p = i;
    }
  }
  Estado estado = queue.get(p);
  queue.remove(p);
  return estado;
}

//verifica se dois estados são iguais
boolean igual(Estado a, Estado b){
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      if(a.M[i][j]!=b.M[i][j]){
        return false;
      }
    }
  }
  return true;
}

//verifica se já existe um estado semalhante na lista
boolean existe(ArrayList<Estado> list, Estado a){
  for(Estado e: list){
    if(igual(e,a))
      return true;
  }
  return false;
}

//Cria um tabuleiro na tela
void criar(int[][] m) {
  for (int i=0; i<N; i++) {
    for (int j=0; j<N; j++) {
      Peca p = new Peca(m[j][i], j*width/N, i*height/N, width/N, height/N);
    }
  }
}

//Embaralha o tabulairo de modo a gerar um estado solucionavel
void embaralha(){
  for(int i=0;i<50;i++){
    ArrayList<Estado> filhos = e.expande(); 
    e = filhos.get((int)random(0,filhos.size()));
  }
}

int s = 0;
int tlist = 0;

ArrayList<Estado> queue = new ArrayList<Estado>(); // Lista usada no calculo
ArrayList<Estado> solucao = new ArrayList<Estado>(); // Lista para armazenar a solução

void setup(){
  size(400,400);
  background(255,255,255);
  embaralha();
  queue.add(e);
  criar(e.M);
}

Estado estado = new Estado(); //Estado atual

void draw(){
  
  if(!queue.isEmpty() && s==0) {
    estado = queue_dropMenor(queue);
    //estado.imprime();
    if (estado.isObjective()) {
      print("Estado objetivo");
      s=1;
    }
    ArrayList<Estado> filhos = estado.expande();
    for (int i=0; i<filhos.size(); i++) {
      if(!existe(queue,filhos.get(i))/* && !existe(visitados,filhos.get(i))*/)
        queue.add(filhos.get(i));
    }
  }
  else if(s==1){
    if(!igual(estado,e)){
      solucao.add(estado);
      estado=estado.pai;
    }
    else{
      solucao.add(estado);
      tlist = solucao.size()-1;
      s=2;
    }
  }
  else{
    criar(solucao.get(tlist--).M);
    delay(1000);
    if(tlist<0) tlist=0;
  }
}