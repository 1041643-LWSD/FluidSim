final int SIZE_X = 200;
final int SIZE_Y = 100;
final int NUM_PARTICLES = 1000;
Particle[] particles;

void setup() {
  size(1200, 600);  // Window size in pixels
  pixelDensity(2);
  particles = new Particle[NUM_PARTICLES];
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle(random(SIZE_X), random(SIZE_Y));
  }
}

void draw() {
  //background(255);  // White background
  
  fill(255, 50);   // instead of background()
  rect(0, 0, width, height);
  
  // Update physics
  for (Particle particle : particles) {
    particle.calculateNextPosition(particles);
  }
  for (Particle particle : particles) {
    particle.updatePosition();
  }
  int cols = width / 10;
  int rows = height / 10;
  int[][] density = new int[cols][rows];
  
  // count hits
  for (Particle p : particles) {
    float px = map(p.x, 0, SIZE_X, 0, width);
    float py = map(p.y, 0, SIZE_Y, 0, height);
    
    int cx = int(px / 10);
    int cy = int(py / 10);
    cx = constrain(cx, 0, cols - 1);
    cy = constrain(cy, 0, rows - 1);
    density[cx][cy]++;
  }

  int[][] smoothDensity = new int[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      int sum = 0;
      // Sum the 3x3 grid centered at (x, y)
      for (int dx = -1; dx <= 1; dx++) {
        for (int dy = -1; dy <= 1; dy++) {
          int nx = x + dx;
          int ny = y + dy;
          // Check bounds
          if (nx >= 0 && nx < cols && ny >= 0 && ny < rows) {
            sum += density[nx][ny];
          }
        }
      }
      smoothDensity[x][y] = sum;
    }
  }
  
  noStroke();
  // draw using smoothed density
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      fill(0, smoothDensity[x][y] * 255/20);  // Adjusted divisor since we're summing 9 cells
      rect(x*10, y*10, 10, 10);
    }
  }
}

class Particle {
  float x, y;
  float nextX, nextY;
  float xVel, yVel;
  
  final float INFLUENCE_RANGE = 20;
  final float REPULSIVE_RANGE = 10;
  final float FRICTION = 0.95;
  final float ATTRACTIVE_FORCE_CONSTANT = 1;
  final float REPULSIVE_FORCE_CONSTANT = 1;
  final float PARTICLE_SIZE = 5;
  final float MAX_VELOCITY = 5;
  boolean gravity = true;
  final float GRAVITY_STRENGTH = .3;
  final float MOUSE_STRENGTH = 2;
  final float MOUSE_RANGE = 20;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    this.nextX = x;
    this.nextY = y;
    this.xVel = 0;
    this.yVel = 0;
  }
  
  float getDistance(Particle particle) {
    float dx = particle.x - this.x;
    float dy = particle.y - this.y;
    return sqrt(dx*dx + dy*dy);
  }
  
  float getXDistance(Particle particle) {
    return x - particle.x;
  }
  
  float getYDistance(Particle particle) {
    return y - particle.y;
  }
  
  boolean withinInfluence(Particle particle) {
    return getDistance(particle) < INFLUENCE_RANGE;
  }
  
  boolean tooClose(Particle particle) {
    return getDistance(particle) < REPULSIVE_RANGE;
  }
  
  float[] calculateForce(Particle[] particles) {
    float xForce = 0;
    float yForce = 0;
    
    for (Particle particle : particles) {
      if (particle == this) continue;
      
      if (this.withinInfluence(particle)) {
        float distance = max(1, this.getDistance(particle));
        float yDistance = this.getYDistance(particle);
        float xDistance = this.getXDistance(particle);
        
        if (this.tooClose(particle)) {
          float force = REPULSIVE_FORCE_CONSTANT / distance;
          xForce += force * xDistance / distance;
          yForce += force * yDistance / distance;
        } else {
          float force = ATTRACTIVE_FORCE_CONSTANT / distance;
          xForce -= force * xDistance / distance;
          yForce -= force * yDistance / distance;
        }
      }
    }
    
    if(gravity) {
      yForce += GRAVITY_STRENGTH;
    }
    
    if(mousePressed) {
      float simMouseX = map(mouseX, 0, width, 0, SIZE_X);
      float simMouseY = map(mouseY, 0, height, 0, SIZE_Y);
      float distance = max(1, dist(simMouseX, simMouseY, this.x, this.y));
      if(distance < MOUSE_RANGE) {
        float xDistance = simMouseX - this.x;
        float yDistance = simMouseY - this.y;
        float force = MOUSE_STRENGTH * distance;
        if(mouseButton == LEFT) {
          xForce += force * xDistance / distance;
          yForce += force * yDistance / distance;
        } else if(mouseButton == RIGHT) {
          xForce -= force * xDistance / distance;
          yForce -= force * yDistance / distance;
        }
      }
    }
    return new float[]{xForce, yForce};
  }

  void calculateNextPosition(Particle[] particles) {
    float[] forces = calculateForce(particles);
    this.xVel += forces[0];
    this.yVel += forces[1];
    
    this.xVel = constrain(this.xVel, -MAX_VELOCITY, MAX_VELOCITY);
    this.yVel = constrain(this.yVel, -MAX_VELOCITY, MAX_VELOCITY);
    
    this.xVel *= FRICTION;
    this.yVel *= FRICTION;
    
    this.nextX = this.x + this.xVel;
    this.nextY = this.y + this.yVel;
    
    this.nextX = constrain(this.nextX, 0, SIZE_X);
    this.nextY = constrain(this.nextY, 0, SIZE_Y);
    
    if (this.nextX == 0 || this.nextX == SIZE_X) {
      this.xVel *= -.99;
    }
    if (this.nextY == 0) {
      this.yVel *= -.99;
    }
  }

  void updatePosition() {
    this.x = this.nextX;
    this.y = this.nextY;
  }

  void display() {
    // Map from 0-100 to 0-600 pixel coordinates
    float pixelX = map(x, 0, SIZE_X, 0, width);
    float pixelY = map(y, 0, SIZE_Y, 0, height);
    float pixelSize = map(PARTICLE_SIZE, 0, SIZE_X, 0, width);
    ellipse(pixelX, pixelY, pixelSize * 2, pixelSize * 2);
  }
}
