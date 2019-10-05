import java.util.Random;
public class Example0301{
  public static void main(String[] args) {
    Random random = new Random();
    int n = random.nextInt();
    System.out.println("n = "+n);
    if (n<0) System.out.println("*** n<0");
    System.out.println("Goodbye.");
  }
}
