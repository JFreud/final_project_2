import java.util.Random;
import java.util.Arrays;

class Network{
  
  ArrayList<Node> nodes = new ArrayList<Node>();
  ArrayList<Edge> edges = new ArrayList<Edge>();
  BinarySearchTree bst;
  //float Kr = Rep_Force;
  //float Ks = Spring_Force;
  float restLength = 50;
 
  
  Network(int targetCluster){
    Table table = loadTable( "clusterNew.csv", "header" );
    
    // iterate through each row
    bst = new BinarySearchTree();
    for( TableRow row : table.rows() ){
      int cluster = row.getInt("cluster");
      if(cluster == targetCluster){   // if this interaction is within the cluster
        
        String p1 = row.getString("SymbolA");
        String p2 = row.getString("SymbolB");
        Random random = new Random();
        Node n1 = new Node( p1, 350 + random.nextInt(501), 100 + random.nextInt(501), Rep_Force );
        //println(350 + random.nextInt(501));
        Node n2 = new Node( p2, 350 + random.nextInt(501), 100 + random.nextInt(501), Rep_Force );
        
        Node bstRes1 = bst.find(n1); // the result of trying to find the node in the list of current nodes
        Node bstRes2 = bst.find(n2);
        
        if( bstRes1 == null && bstRes2 == null){
          bst.add(n1);
          bst.add(n2);
          nodes.add(n1);
          nodes.add(n2);
          edges.add( new Edge( n1, n2, Spring_Force, restLength ) );
        } else if (bstRes1 == null){
          bst.add(n1);
          nodes.add(n1);
          edges.add( new Edge( n1, bstRes2, Spring_Force, restLength ) );
        } else if (bstRes2 == null){
          bst.add(n2);
          nodes.add(n2);
          edges.add( new Edge( bstRes1, n2, Spring_Force, restLength ) );
        } else {
          edges.add( new Edge( bstRes1, bstRes2, Spring_Force, restLength) );
        }
        
      }
    }
    
    // System.out.println( nodes );
    // System.out.println( edges );
  }
  
  
  
  
  void setRepForce() {
    for (int i = 0; i < nodes.size(); i++) {
      PVector repForce = new PVector(0,0);
      for (int j = 0; j < nodes.size(); j++) {
        if (nodes.get(i) != nodes.get(j)) {
          //println(repForce);
          repForce.add(nodes.get(i).repel(nodes.get(j)));
        }
      }
      nodes.get(i).repForce = repForce;
    }
  }
  
  
  void setSpringForce(){
    //for( Edge e : edges ){
    for(int i = 0; i < edges.size(); i++) {
      edges.get(i).calcSpringForce();
    }
  }
  
  
  void update(){    background(100);
 
   setRepForce();
      setSpringForce();
   for( Node n : nodes ){
      //println("repF" + n.repForce);
      //println("repS" + n.springForce);
      if (input.equals(n.protein)) {
        n.highlighted = true;
      }
      else {
        n.highlighted = false;
      }
      n.update();
    }
    for( Edge e : edges ){
      e.display();
    }
    for( Node n : nodes ){
      n.display();
    }
  }
  
}