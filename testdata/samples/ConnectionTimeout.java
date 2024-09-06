import java.net.HttpURLConnection;
import java.net.URL;

public class ConnectionTimeout {
    public void unsafe() {
        try {
            String apiKey = System.getenv("API_KEY");
            URL url = createValidUrl("https://api.example.com/data?apiKey=" + apiKey);
            if (url == null) {
                throw new RuntimeException("Invalid URL");
            }
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setRequestMethod("GET");
            // Additional connection setup and handling the response...
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void safe() {
        try {
            String apiKey = System.getenv("API_KEY");
            if (apiKey == null) {
                throw new RuntimeException("API_KEY environment variable is not set.");
            }
            URL url = createValidUrl("https://api.example.com/data?apiKey=" + apiKey);
            if (url == null) {
                throw new RuntimeException("Invalid URL");
            }
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            // Set timeout values
            int timeout = 10000; // 10 seconds
            conn.setConnectTimeout(timeout); // Sets the timeout for connecting to the url
            conn.setReadTimeout(timeout);    // Sets the timeout for reading the data from the url            
            conn.setRequestMethod("GET");
            // Additional connection setup and handling the response...
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    private URL createValidUrl(String url) {
        try {
            URL valideUrl = new URL(url);
            valideUrl.toURI(); // Validate the URL
            return valideUrl;
        } catch (Exception e) {
            return null;
        }
    }
}

