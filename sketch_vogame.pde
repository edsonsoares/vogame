import processing.video.*;

// Variable for Dancer's video
Movie video;

// background
PImage backgroundImage;

// How different must a pixel be to be a foreground pixel
float threshold = 70;

// previous camera frame
PImage prevCamFrame;

// cam
Capture cam;

// Images to display the videos
PImage currentDancerFrame;
PImage currentCamFrame;

// Intro "Voguing"
Title title1;

//Imagem "Start" the game
PImage start;




void setup() {
  frameRate(60);
  size(1280, 720);
  video = new Movie(this, "back2.mov");
  video.play();
  
  // Background to compare to the video and create silhouete
  backgroundImage = loadImage("background.png");
  
  // Image to manipulate video   separatedely
  currentDancerFrame = createImage(video.width, video.height,RGB);

  //Capture
  cam = new Capture(this, 1280, 720);
  cam.start();
  
  
  
  // Create an empty image the same size as the cam
  prevCamFrame = createImage(cam.width, cam.height, RGB);
  
   // Image to manipulate cam separatedely
  currentCamFrame = createImage(cam.width, cam.height, RGB);

  //title
  title1 = new Title (1000, 40);
  
  //Start image
  start = loadImage ("start.png");
  
}




void draw() {

  // raise the tint back up to 100% opacity
  tint(255, 255);

  drawTheBackgroundDancer();

  // save the current frame of the sketch as an image. You don't need to export.
  // let's call it "currentDanceFrame"


  // if the title1 x is lower than a certain variable, draw the camera.
  if (title1.x < width - 5699) {

    drawTheCamera();   
    image(start, width/2, height/2);
    
    
    // reset the screen to be black
    // drawTheCamera();


    // save the camera frame of the sketch as an image. You don't need to export.
    // let's call it currentCamFrame
  }

  // Draw the currentDancerFrame
  // then draw the curretnCamFrame in lower tint.
  // image(currentFrameDancer, 0, 0, video.width, video.height);
  // tint(100);
  // image(currentFrameCam, 0, 0, video.width, video.height);



  // Name of the game
  title1.write();
  title1.move();
  
  
  // tint or blend or whatever?
  //image(currentDancerFrame,0,0);
  //tint(120);
  //image(currentCamFrame,0,0);
}



void movieEvent(Movie video) {
  video.read();
}

void drawTheBackgroundDancer() {
  
  // We are looking at the video's pixels, the memorized backgroundImage's pixels, as well as accessing the display pixels. 
  // So we must loadPixels() for all!
  loadPixels();
  video.loadPixels(); 
  backgroundImage.loadPixels();
  currentDancerFrame.loadPixels();



  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width; // Step 1, what is the 1D pixel location
      color fgColor = video.pixels[loc]; // Step 2, what is the foreground color
      color bgColor = backgroundImage.pixels[loc]; // Step 3, what is the background color

      // Step 4, compare the foreground and background color
      float r1 = red(fgColor);
      float g1 = green(fgColor);
      float b1 = blue(fgColor);
      float r2 = red(bgColor);
      float g2 = green(bgColor);
      float b2 = blue(bgColor);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, Is the foreground color different from the background color
      if (diff > threshold) {
        // If so, display the foreground color
        pixels[loc] = color(255);
      } else {
        // If not, display white
        pixels[loc] = color(0); // We could choose to replace the background pixels with something other than the color green!
      }
    }
  }

  // update pixels only after the walkthrough background looping
  updatePixels();
}


// void captureEvent(Capture cam){ 
//   cam.read();
// }


void drawTheCamera() {
  cam.read();
  
  pushMatrix();
  translate(0, 0);
 
  //we need to do the motion detection here
  cam.loadPixels();
  prevCamFrame.loadPixels();
  //currentCamFrame.loadPixels();


  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {


      int loc = x + y*cam.width;            // Step 1, what is the 1D pixel location
      color current = cam.pixels[loc];      // Step 2, what is the current color
      color previous = prevCamFrame.pixels[loc]; // Step 3, what is the previous color

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // If motion, display black
        cam.pixels[loc] = color(0);
      } else {
        // If not, display white
        cam.pixels[loc] = color(255, 0, 0);
      }
    }
  }
  updatePixels();


  // turn off this opacity for the currentFrame stuff.
  tint(255, 100);

  // flipping the video
  pushMatrix();
  scale(-1.0, 1.0);
  image(cam, -cam.width, 0);
  popMatrix();
  popMatrix();
}
