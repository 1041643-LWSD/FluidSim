public class fluidRunner {
	
	public final static int SIZE = 100;
	private final static int NUM_PARTICLES = 100;
	
    public static void main(String[] args) {
        // Set canvas size explicitly
        StdDraw.setCanvasSize(600, 600);
        StdDraw.setScale(0, SIZE);
        StdDraw.enableDoubleBuffering();
        
        Particle[] particles = new Particle[NUM_PARTICLES];
        for(int i = 0; i < NUM_PARTICLES; i++) {
        	particles[i] = new Particle(Math.random() * SIZE, Math.random() * SIZE);
        }

        while (true) {
            StdDraw.clear(StdDraw.WHITE);
            StdDraw.setPenColor(StdDraw.BLACK);

            for (Particle particle : particles) {
                particle.calculateNextPosition(particles);
            }

            for (Particle particle : particles) {
                particle.updatePosition();
                particle.draw();
            }
            
            StdDraw.show();
            StdDraw.pause(16);
        }
    }
}