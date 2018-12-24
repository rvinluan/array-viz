import themidibus.*;
import java.util.Comparator;
import java.util.Collections;

MidiBus myBus; // The MidiBus

ArrayList<Shape> shapes = new ArrayList<Shape>();

final int lowestPitch = 24;
final int highestPitch = 101;
final int totalNotes = highestPitch - lowestPitch + 1;

final int gridSize = 60;
final int rowCount = 13;

public static Comparator<Note> pitchComparator = new Comparator<Note>() {
  @Override
    public int compare(Note n1, Note n2) {
    return (n1.pitch % 12) - (n2.pitch % 12);
  }
};

void setup() {
  size(1000, 1000);
  //fullScreen();
  noCursor();
  MidiBus.list();
  myBus = new MidiBus(this, 1, 1);
  //set up the notes
  for (int i = 0; i < totalNotes; i++) {
    int r = i % rowCount;
    int c = floor(i / rowCount);
    Shape s = new Shape(i + lowestPitch, r*gridSize, c*gridSize, floor((float)Math.random() * gridSize/2)-gridSize/4);
    shapes.add(s);
  }
}

void drawGrid() {
  for (int i = 0; i < totalNotes; i++) {
    int r = i % rowCount;
    int c = floor(i / rowCount);
    fill(255);
    rectMode(CORNER);
    rect(r*gridSize - gridSize/2, c*gridSize - gridSize/2, gridSize, gridSize);
  }
}
void draw() {
  background(#A01D26);
  //center the array
  float totalWidth = gridSize * (rowCount-1);
  float totalHeight = gridSize * floor(totalNotes / rowCount);
  //translate for width and height
  pushMatrix();
  translate(width/2 - totalWidth/2, height/2 - totalHeight/2);
  for (int i = 0; i < shapes.size(); i++) {
    shapes.get(i).update();
    shapes.get(i).render();
  }
  popMatrix();
}

void noteOn(Note n) {
  if (n.pitch >= highestPitch) {
    return;
  }
  shapes.get(n.pitch - lowestPitch).on(n.velocity);
  println(n.pitch);
}

void noteOff(Note n) {
  if (n.pitch >= highestPitch) {
    return;
  }
  shapes.get(n.pitch - lowestPitch).off();
}