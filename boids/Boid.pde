class Boid {
  // main fields
  PVector pos;
  PVector move;
  float shade;
  boolean leader;
  int objective;
  ArrayList<Boid> friends;
  int battery ;
  PVector target;
  int return_flag;
  // timers
  float jar_p = 0;
  int return_trip = 1000;
  int thinkTimer = 0;
  float current_percentage = 0;
  boolean can_go = true;
  boolean order = false;
  boolean controller = false;
  int number_ordered = 0;


  Boid (float xx, float yy, boolean lead, int obj) {
    move = new PVector(0, 0);
    pos = new PVector(0, 0);
    pos.x = xx;
    pos.y = yy;
    thinkTimer = int(random(10));
    shade = random(255); // Random Color.
    friends = new ArrayList<Boid>();
    leader = lead;
    objective = obj;
    battery = 2000;
    return_trip = battery;
    target = new PVector(1024,576);
    return_flag = 1;
  }

  void go (float jar_percentage ) {
    // implementing the refuling logic
    println(return_trip);
    current_percentage = jar_percentage;
    if(objective>=4 && (return_flag==2 )){
    
    if (thinkTimer ==0 ) {
      // update our friend array (lots of square roots)
      getFriends();
      battery-=1;
      jar_p-=0.0005;
      
    }
    if(return_flag==2 && can_go){
              if(battery <= return_trip ){
                target = new PVector(0, 0);
                return_flag = 3;
                println("return");
                number_ordered = 0;
              }
     } 
    }
    
    else{
    if( PVector.dist(this.pos, new PVector(0, 0) )< 100 && return_flag ==3 && objective >=4){
               battery = 2000;
               return_trip = 2000;
               target = new PVector(1024, 576);
               return_flag = 1;
            }    
    increment();
    wrap();

    if (thinkTimer ==0 ) {
      // update our friend array (lots of square roots)
      getFriends();
      battery-=1;
      jar_p-=0.0001;
      
      
    }
    flock();
    pos.add(move);
    
    }
    
    

  }

  void flock () {
    PVector allign = getAverageDir();
    PVector avoidDir = getAvoidDir(); 
    PVector avoidObjects = getAvoidAvoids();
    PVector noise = new PVector(random(2) - 1, random(2) -1);
    PVector cohese = getCohesion();

    allign.mult(1);
    if (!option_friend) allign.mult(0);
    
    avoidDir.mult(1);
    if (!option_crowd) avoidDir.mult(0);
    
    avoidObjects.mult(3);
    if (!option_avoid) avoidObjects.mult(0);

    noise.mult(0.1);
    if (!option_noise) noise.mult(0);

    cohese.mult(1);
    if (!option_cohese) cohese.mult(0);
    
    stroke(0, 255, 160);
     
    
    if(leader){
    if(objective >= 4 )
    {
     
      //implementing the refuling logic
      if(objective == 4 && PVector.dist(this.pos, target )< 100 && battery > return_trip-battery+300 && return_flag ==1){
        return_flag = 2;
        return_trip = return_trip-battery+300;
        println("Stop");
      }
     //Implemeting the leadership protocol
     if(objective == 5 && PVector.dist(this.pos, target )< 100 && battery > return_trip-battery+300 && return_flag ==1){
        println("Inside");
        return_flag = 2;
        return_trip = return_trip-battery+300;
        println("Stop");
        this.controller = true;
        number_ordered = 0;
        this.can_go = false;
        float total=0;
        for (Boid other : friends){
          if(other.controller){
          if(other.battery<other.return_trip)
          {
          other.number_ordered = 0;
          number_ordered = 0;
          }
          else{
          number_ordered = other.number_ordered;
          other.number_ordered =0;}
          }
          other.controller = false;
          total = total + (other.return_trip*0.001*2 - battery*0.001);
          other.can_go = true;
        }
        if(total+current_percentage > 0){
          for (Boid other : friends){
          total = total + (other.return_trip*0.001*2 - battery*0.001);
          other.can_go = false;
          
          if(total+current_percentage<0){
            break;
          }
        }
        }
        else{
        if(total+current_percentage+return_trip*0.001 < 0 && number_ordered < 1){
        order = true;
        number_ordered += 1;
        }
        
        }
        
        
      }
    
    
    
    move.add(PVector.sub(target, pos).mult(0.005));
    move.limit(maxSpeed);
    move.add(avoidDir);
    move.add(avoidObjects.mult(5));
    move.add(noise);
    move.add(cohese);
    move.add(allign);
    }
    else{
    move.add(PVector.sub(target, pos).mult(0.005));
    move.limit(maxSpeed);
    move.add(avoidDir);
    move.add(avoidObjects.mult(5));
    move.add(noise);
    move.add(cohese);
    move.add(allign);}
    
    }
    
    else{
      
    move.add(allign);
    move.add(avoidDir);
    move.add(avoidObjects);
    move.add(noise);
    move.add(cohese);
    move.limit(maxSpeed);
    shade += getAverageColor() * 0.03;
    shade += (random(2) - 1) ;
    shade = (shade + 255) % 255; //max(0, min(255, shade));}
    }
    
    if(objective == 3 || objective ==4){
    PVector nice  = new PVector(0,-1);
    move.add(nice.mult(0.01*random(2)));
    }
    
    
    
  }

  void getFriends () {
    ArrayList<Boid> nearby = new ArrayList<Boid>();
    for (int i =0; i < boids.size(); i++) {
      Boid test = boids.get(i);
      if (test == this) continue;
      if (abs(test.pos.x - this.pos.x) < friendRadius &&
        abs(test.pos.y - this.pos.y) < friendRadius) {
        nearby.add(test);
      }
    }
    friends = nearby;
  }

  float getAverageColor () {
    float total = 0;
    float count = 0;
    for (Boid other : friends) {
      if (other.shade - shade < -128) {
        total += other.shade + 255 - shade;
      } else if (other.shade - shade > 128) {
        total += other.shade - 255 - shade;
      } else {
        total += other.shade - shade; 
      }
      count++;
    }
    if (count == 0) return 0;
    return total / (float) count;
  }
  
  PVector getAverageDir () {
    PVector sum = new PVector(0, 0);
    int count = 0;
    float least_dist = 114001;
    Boid lead = new Boid(0,0,false,1);
    
    for (int i = 0; i <friends.size(); i++) {
      Boid other = boids.get(i);
      float d = PVector.dist(pos, other.pos);
      float dist = PVector.dist(target, other.pos);
      
      if(objective == 2){
      if(PVector.dist(pos,target) - PVector.dist(target, other.pos) < 0){
      //lead.leader = false;
      leader = true;
      }
      }
      
      
      if(dist<least_dist){
      least_dist = d;
      lead = other;
      }
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < friendRadius)) {
        PVector copy = other.move.copy();
        copy.normalize();
        copy.div(d); 
        sum.add(copy);
        count++;
      }
      
      if (count > 0) {
        //sum.div((float)count);
      }
    }
    // Implemeting the leader logic of Objective 2
    if(objective == 2){
      if(friends.size() == 0){
        leader=true;
      }
    move.add(lead.move);
    
    if(PVector.dist(pos,target) - PVector.dist(target, lead.pos) < 0){
      //lead.leader = false;
      leader = true;
    }else{
    lead.leader=true;
    //leader = false;
    }
    }
    return sum;
  }

  PVector getAvoidDir() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      print("Distance from friends: ");
      println(d);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < crowdRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    if (count > 0) {
      //steer.div((float) count);
    }
    return steer;
  }

  PVector getAvoidAvoids() {
    PVector steer = new PVector(0, 0);
    int count = 0;

    for (Avoid other : avoids) {
      float d = PVector.dist(pos, other.pos);
      print("Distance from Avoids: ");
      println(avoidRadius);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < avoidRadius)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(pos, other.pos);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    return steer;
  }
  
  PVector getCohesion () {
   float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Boid other : friends) {
      float d = PVector.dist(pos, other.pos);
      if ((d > 0) && (d < coheseRadius)) {
        sum.add(other.pos); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      
      PVector desired = PVector.sub(sum, pos);  
      return desired.setMag(0.05);
    } 
    else {
      return new PVector(0, 0);
    }
  }

  void draw () {
    if(objective>=4){
    stroke(255);
    if(controller){
    fill(125,0);
    }
    else{
    fill(255,255);
    }
    //tint(255, 126);
    arc(this.pos.x, this.pos.y,30* globalScale,30* globalScale,0,2*PI*battery*0.001/2 );
  }
    
    
    for ( int i = 0; i < friends.size(); i++) {
      Boid f = friends.get(i);
      stroke(90);
      line(this.pos.x, this.pos.y, f.pos.x, f.pos.y);
    }
    noStroke();
    if(leader ){
       fill(255,255,255);
    }
    
    
    else{
    fill(shade, 90, 200);}
    pushMatrix();
    translate(pos.x, pos.y);
    rotate(move.heading());
    beginShape();
    vertex(15 * globalScale, 0);
    vertex(-7* globalScale, 7* globalScale);
    vertex(-7* globalScale, -7* globalScale);
    
    endShape(CLOSE);
    popMatrix();
    
  }

  // update all those timers!
  void increment () {
    thinkTimer = (thinkTimer + 1) % 1;
    
  }

  void wrap () {
    pos.x = (pos.x + width) % width;
    pos.y = (pos.y + height) % height;
  }
}
