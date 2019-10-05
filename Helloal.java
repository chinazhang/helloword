import java.io.*;
public class Helloal
{
  public static void main(String[] args) throws IOException {
    InputStreamReader reader = new InputStreamReader(System.in);
    BufferedReader input = new BufferedReader(reader);
    System.out.print("Enter your name: ");
    String name = input.readLine();
    System.out.println("Hello," + name +"!");
  }
}
