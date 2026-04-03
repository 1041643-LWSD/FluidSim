public class Particle {
	private double x;
	private double y;
	private double xVel;
	private double yVel;
	private final static double INFLUENCE_RANGE = 50;
	private final static double REPULSIVE_RANGE = 15;
	private final static double FRICTION = 0.9;
	private final static double ATTRACTIVE_FORCE_CONSTANT = .1;
	private final static double REPULSIVE_FORCE_CONSTANT = 1;
	private final static double SIZE = 1;

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
                	double distance = this.getDistance(particle);
                	double yDistance = this.getYDistance(particle);
                	double xDistance = this.getXDistance(particle);
                    if (this.tooClose(particle)) {
	                	double force = this.REPULSIVE_FORCE_CONSTANT/distance;
	                	xForce += force * xDistance/distance;
						yForce += force * yDistance/distance;
                    } else {
                    	double force = this.ATTRACTIVE_FORCE_CONSTANT/distance;
						xForce -= force * xDistance/distance;
						yForce -= force * yDistance/distance;
					}
                }
            }
		return new double[]{xForce, yForce};
	}

	public void calculateNewVelocity(Particle[] particles) {
		double[] forces = calculateForce(particles);
		this.xVel = forces[0];
		this.yVel = forces[1];
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
		//StdDraw.circle(x, y, this.INFLUENCE_RANGE);
		//StdDraw.circle(x, y, this.REPULSIVE_RANGE);
	}
}