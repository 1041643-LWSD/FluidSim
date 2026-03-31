package fluidSim;

import java.util.Arrays;

public class Particle {
	private double x;
	private double y;
	private double xVel;
	private double yVel;
	private final double INFLUENCE_RANGE = 10;
	private final double REPULSIVE_RANGE = 2;
	private final double FRICTION = 0.99;
	private final double FORCE_CONSTANT = 1;

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
                if (this.withinInfluence(particle)) {
                    if (this.tooClose(particle)) {
						xForce -= this.FORCE_CONSTANT/this.getXDistance(particle);
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

	public void updatePosition() {
		this.x += this.xVel;
		this.y += this.yVel;
		this.xVel *= this.FRICTION;
		this.yVel *= this.FRICTION;
	}

	private double getX() {
		return this.x;
	}
	
	private double getY() {
		return this.y;
	}

	public void draw() {
		StdDraw.circle(this.x, this.y, 0.01);
	}
}
