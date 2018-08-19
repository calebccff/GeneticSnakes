float MUTATION_RATE = 0.015;
float MUTATION_AMT = 0.02; //Decrease over time?

class Brain{
  private final float SYNAPSE_MIN = -1f; //Some constants to fine tune the NN, could have a drastic effect on evolution
  private final float SYNAPSE_MAX = 1f;

  float[] dna = new float[1];
  private int chromCount = -1;

  private Node[][] nodesVisible = new Node[2][]; //Staggered 2d array of Node objects that make up the BRAIN
  private Node[][] nodesHidden;

  private int countSynapses(int inp, int[] hidden, int out){
    int sum = inp*hidden[0];
    sum += hidden[hidden.length-1]*out;
    for(int i = 0; i < hidden.length-1; i++){
      sum += hidden[i] * hidden[i+1];
    }
    return sum;
  }

  private float nextChromosome(){
    return dna[++chromCount];
  }

  void randomDNA(int lenInput, int[] lenHidden, int lenOutput){
    dna = new float[countSynapses(lenInput, lenHidden, lenOutput)];
    for(int i = 0; i < dna.length; i++){
      dna[i] = random(1);
    }
  }

  void initNodes(int lenInput, int[] lenHidden, int lenOutput){
    nodesVisible[0] = new Node[lenInput]; //Initialises the second dimension of the array
    nodesVisible[1] = new Node[lenOutput];
    nodesHidden = new Node[lenHidden.length][];

    for(int i = 0; i < nodesVisible[0].length; i++){
      nodesVisible[0][i] = new Node(0);
    }

    for(int i = 0; i < nodesHidden.length; i++){ //Creates the array of hidden layers
      nodesHidden[i] = new Node[lenHidden[i]];
    }

    for(int i = 0; i < nodesHidden[0].length; i++){ //assignment of first hidden layer
      nodesHidden[0][i] = new Node(nodesVisible[0].length);
    }
    for(int i = 1; i < nodesHidden.length; i++){ //The rest of the hidden layers
      for(int j = 0; j < nodesHidden[i].length; j++){
        nodesHidden[i][j] = new Node(nodesHidden[i-1].length);
      }
    }

    for(int i = 0; i < nodesVisible[1].length; i++){
      nodesVisible[1][i] = new Node(nodesHidden[nodesHidden.length-1].length);
    }
  }

  Brain(int lenInput, int[] lenHidden, int lenOutput) { //Default constructor, specify the lengths of each layer
    randomDNA(lenInput, lenHidden, lenOutput);
    initNodes(lenInput, lenHidden, lenOutput);
  }

  Brain(Brain a, Brain b){
    int[] lenHidden = new int[a.nodesHidden.length];
    for(int i = 0; i < lenHidden.length; i++){
      lenHidden[i] = a.nodesHidden[i].length;
    }
    dna = new float[a.dna.length];
    for(int i = 0; i < dna.length; i++){
      float r = random(1);
      if(r < MUTATION_RATE){
        dna[i] = random(1);
      }else if(r < MUTATION_RATE+(1-MUTATION_RATE)/2){
        dna[i] = b.dna[i]+random(-MUTATION_AMT, MUTATION_AMT);
      }else{
        dna[i] = a.dna[i]+random(-MUTATION_AMT, MUTATION_AMT);
      }
    }
    initNodes(a.nodesVisible[0].length, lenHidden, a.nodesVisible[1].length);

  }

  float[] propForward(float[] inputs) { //Propagates forward, passes inputs through the net and gets an output.
    // Input
    for (int j = 0; j < inputs.length; ++j) { //For the first layer, set the values.
      nodesVisible[0][j].setValue(inputs[j]);
    }
    // Hidden/Outer
    for (int i = 0; i < nodesHidden[0].length; ++i) { //Set the next layer
      nodesHidden[0][i].propForward(nodesVisible[0]);
    }
    for (int j = 1; j < nodesHidden.length; ++j) {
      for (int i = 0; i < nodesHidden[j].length; ++i) {
        nodesHidden[j][i].propForward(nodesHidden[j-1]);
      }
    }
    for (int i = 0; i < nodesVisible[1].length; ++i) {
      nodesVisible[1][i].propForward(nodesHidden[nodesHidden.length-1]);
    }

    // Get/return the outputs
    float[] output = new float[nodesVisible[nodesVisible.length-1].length]; //Gets the outputs from the last layer
    for (int i = 0; i < output.length; ++i) {
      output[i] = nodesVisible[nodesVisible.length-1][i].getValue();
      //output[i] = sig(output[i]);
    }

    return output; //Return them
  }

  float sig(float x) { //The sigmoid function, look it up.
    return 1/(1+exp(-x)); //looks like and S shape, Eulers number is AWESOME!
  }

  class Node{
    float[] synapses;
    float value = 0;

    Node(int synLen){
      synapses = new float[synLen];
      for(int i = 0; i < synLen; i++){
        synapses[i] = nextChromosome();
      }
    }
    Node(Node p){
      this(p.synapses.length); //Created from parent
    }

    void propForward(Node[] nodes){ //Takes value from previous layers
      value = 0;
      for(int i = 0; i < nodes.length; i++){
        value += nodes[i].getValue()*synapses[i];
      }
      value = sig(value);
    }

    float getValue(){
      return value;
    }

    void setValue(float x){
      this.value = x;
    }
  }
}
