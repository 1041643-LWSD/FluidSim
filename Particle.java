package fluidSim;

public class Particle {
	private double x;
	private double y;
	private double xVel;
	private double yVel;
	private double INFLUENCE_RANGE = 10;
	private double REPULSIVE_RANGE = 2;
	
	public Particle(double x, double y) {
		this.x = x;
		this.y = y;
	}
	
	public getNewX
	
	public double getDistance(Particle particle) {
		return Math.sqrt((particle.getX()-this.getX())*(particle.getX()-this.getX())+(particle.getY()-this.getY())*(particle.getY()-this.getY()));
	}
	
	public double getXDistance(Particle particle) {
		return x-particle.getX();
	}
	
	public double getYDistanceOf(Particle particle) {
		return y-particle.getY();
	}
	
	public boolean withinInfluence(Particle particle) {
		return getDistance(particle) < this.INFLUENCE_RANGE;
	}
	
	public boolean tooClose() {
		return getDistance(particle) < this.REPULSIVE_RANGE;
	}
	
	public double[] calculateForce(Particle[] particles) {
		for(int i = 0; i < particles.length; i++) {
			if(this.withinInfluenceOf(particles[i])) {
				if(this.tooClose(particles[i])) {
					
				}
			}
		}
	}

	private double getX() {
		return this.x;
	}
	
	private double getY() {
		return this.y;
	}

	public void draw() {
		StdDraw.Circle(this.x, this.y);
	}
}
