class Avoid {
   PVector pos;
   // Class to create obstacles
   Avoid (float xx, float yy) {
     pos = new PVector(xx,yy);
   }
   
   void go () {
     
   }
   
   void draw () {
     fill(0, 255, 200);
     ellipse(pos.x, pos.y, 15, 15);
   }
}
