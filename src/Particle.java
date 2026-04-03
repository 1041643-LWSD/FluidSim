public class Particle {
	private double x;
	private double y;
	private double xVel;
	private double yVel;
	private final double INFLUENCE_RANGE = 20;
	private final double REPULSIVE_RANGE = 2;
	private final double FRICTION = 0.99;
	private final double FORCE_CONSTANT = .1;
	private final double SIZE = 1;

	public Particle(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public double getDistance(Particle particle) {
		return Math.sqrt((particle.getX()-this.getX())*(particle.getX()-this.getX())+(particle.getY()-this.getY())*(particle.getY()-this.getY()));
	}
	
	public double getXDistance(Particle particle) {
		return x-particle.getX();
	}
	
	public double getYDistance(Particle particle) {
		return y-particle.getY();
	}
	
	public boolean withinInfluence(Particle particle) {
		return getDistance(particle) < this.INFLUENCE_RANGE;
	}
	
	public boolean tooClose(Particle particle) {
		return getDistance(particle) < this.REPULSIVE_RANGE;
	}
	
	public double[] calculateForce(Particle[] particles) {
		double xForce = 0;
		double yForce = 0;
            for (Particle particle : particles) {
				if(particle == this) {
					continue;
				}
                if (this.withinInfluence(particle)) {
                    if (this.tooClose(particle)) {
						if (this.getXDistance(particle) == 0) {
							this.x += 1/50 - Math.random()/100;
						}
						xForce -= 1/this.getXDistance(particle);
						if (this.getYDistance(particle) != 0) {
							this.y += 1/50 - Math.random()/100;
						}
						yForce -= this.FORCE_CONSTANT/this.getYDistance(particle);
                    } else {
						xForce += this.FORCE_CONSTANT/this.getXDistance(particle);
						yForce += this.FORCE_CONSTANT/this.getYDistance(particle);
					}
                }
            }
		return new double[]{xForce, yForce};
	}

	public void calculateNewVelocity(Particle[] particles) {
		double[] forces = calculateForce(particles);
		this.xVel += forces[0];
		this.yVel += forces[1];
	}

	public void updatePosition(Particle[] particles) {
		calculateNewVelocity(particles);
		this.x += this.xVel;
		this.y += this.yVel;
		this.xVel *= this.FRICTION;
		this.yVel *= this.FRICTION;
	}

	public double getX() {
		return this.x;
	}
	
	public double getY() {
		return this.y;
	}

	public void draw() {
		StdDraw.filledCircle(this.x, this.y, this.SIZE);
	}
}