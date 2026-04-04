final int SIZE = 100;
final int NUM_PARTICLES = 1000;
Particle[] particles;

void setup() {
  size(600, 600);  // Window size in pixels
  pixelDensity(2);
  particles = new Particle[NUM_PARTICLES];
  for (int i = 0; i < NUM_PARTICLES; i++) {
    particles[i] = new Particle(random(SIZE), random(SIZE));
  }
}

void draw() {
  // Map 0-100 coordinate system to 0-600 pixels
  background(255);  // White background
  
  // Update physics
  for (Particle particle : particles) {
    particle.calculateNextPosition(particles);
  }
  for (Particle particle : particles) {
    particle.updatePosition();
  }
  
  // Draw
  fill(0);  // Black fill
  noStroke();
  for (Particle particle : particles) {
    particle.display();
  }
}

class Particle {
  float x, y;
  float nextX, nextY;
  float xVel, yVel;
  
  final float INFLUENCE_RANGE = 20;
  final float REPULSIVE_RANGE = 15;
  final float FRICTION = 0.9;
  final float ATTRACTIVE_FORCE_CONSTANT = 0.01;
  final float REPULSIVE_FORCE_CONSTANT = 0.5;
  final float PARTICLE_SIZE = 1;
  final float MAX_VELOCITY = 5;
  boolean gravity = true;
  final float GRAVITY_STRENGTH = .3;
  final float MOUSE_STRENGTH = .1;
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
      float simMouseX = map(mouseX, 0, width, 0, SIZE);
      float simMouseY = map(mouseY, 0, height, 0, SIZE);
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
    this.nextX = constrain(this.nextX, 0, SIZE);
    this.nextY = constrain(this.nextY, 0, SIZE);
    
    if (this.nextX == 0 || this.nextX == SIZE) {
      this.xVel *= -.5;
    }
    if (this.nextY == 0 || this.nextY == SIZE) {
      this.yVel *= -.5;
    }

    this.nextX = this.x + this.xVel;
    this.nextY = this.y + this.yVel;
    this.xVel *= FRICTION;
    this.yVel *= FRICTION;
  }

  void updatePosition() {
    this.x = this.nextX;
    this.y = this.nextY;
  }

  void display() {
    // Map from 0-100 to 0-600 pixel coordinates
    float pixelX = map(x, 0, SIZE, 0, width);
    float pixelY = map(y, 0, SIZE, 0, height);
    float pixelSize = map(PARTICLE_SIZE, 0, SIZE, 0, width);
    ellipse(pixelX, pixelY, pixelSize * 2, pixelSize * 2);
  }
}
