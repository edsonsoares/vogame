class Title {

  String title = "VOGUING";
  PFont font = createFont("Didot", 64);
  float x;
  float y;
  float speed;

  Title (float tempx, float tempspeed) {

    x = tempx;
    speed = tempspeed;
  }

  void write () {

    textFont(font);
    textSize(900);
    fill(255, 0, 0, 100);
    text(title, x, y);
    y = height - 20;

    
  }

  void move () {
    
    x = x - speed;

    if (x < width - 5800) {
      x = width - 5800;
    }
  }
}
