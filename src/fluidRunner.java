public class fluidRunner {
	
	private final static int SIZE = 100;
	private final static int NUM_PARTICLES = 100;
	
    public static void main(String[] args) {
    	StdDraw.enableDoubleBuffering();
        StdDraw.setScale(0, SIZE);
        Particle[] particles = new Particle[NUM_PARTICLES];
        for(int i = 0; i < NUM_PARTICLES; i++) {
        	particles[i] = new Particle(Math.random() * SIZE, Math.random() * SIZE);
        }

        while (true) {
        	StdDraw.clear();
            for (Particle particle : particles) {
                particle.updatePosition(particles);
                particle.draw();
            }
            StdDraw.show();
        }
    }
}
