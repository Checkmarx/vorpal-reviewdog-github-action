import java.io.IOException;
import java.net.InetSocketAddress;
import java.nio.channels.ServerSocketChannel;

public class BindToAll {
      public static void main(String[] args) {
        int port = 12345; // Port number to listen on
        try {
            ServerSocketChannel serverSocketChannel = ServerSocketChannel.open();
            serverSocketChannel.socket().bind(new InetSocketAddress("0.0.0.0", port));
            System.out.println("Server is listening on port " + port);
            // Accept connections and handle them
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
