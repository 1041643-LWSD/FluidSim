public class fluidRunner {
    public static void main(String[] args) {
        StdDraw.setScale(0, 100);
        int numParticles = 2;
        Particle[] particles = new Particle[numParticles];
        particles[0] = new Particle(50, 50);
        particles[1] = new Particle(60, 60);

        while (true) {
            StdDraw.clear();
            for (Particle particle : particles) {
                particle.updatePosition(particles);
                particle.draw();
            }
            //System.out.println(particles[0].getX() + ", " + particles[0].getY());
            StdDraw.show();
        }
    }
}
