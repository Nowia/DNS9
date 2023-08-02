package user;

import java.io.IOException;
import java.net.Authenticator;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.PasswordAuthentication;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.charset.StandardCharsets;

import org.apache.commons.codec.binary.Base64;

import java.io.OutputStreamWriter;
import java.io.InputStream;

public class PLMAuthenticator {

    private final String user;
    private final String password;

    public PLMAuthenticator(String user, String password) {
        this.user = user;
        this.password = password;
    }
    //登入方法1 回傳200正常
    public int sendRquestWithAuthHeader(String url) throws IOException {
        HttpURLConnection connection = null;
        try {
            connection = createConnection(url);
            connection.setRequestProperty("Authorization", createBasicAuthHeaderValue());
            return connection.getResponseCode();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }
    //登入方法2 回傳200正常
    public int sendRquestWithAuthenticator(String url) throws IOException {
        setAuthenticator();

        HttpURLConnection connection = null;
        try {
            connection = createConnection(url);
            return connection.getResponseCode();
        } finally {
            if (connection != null) {
                connection.disconnect();
            }
        }
    }

    private HttpURLConnection createConnection(String urlString) throws MalformedURLException, IOException, ProtocolException {
        URL url = new URL(String.format(urlString));
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("GET");
        return connection;
    }

    private String createBasicAuthHeaderValue() {
        String auth = user + ":" + password;
        byte[] encodedAuth = Base64.encodeBase64(auth.getBytes(StandardCharsets.UTF_8));
        String authHeaderValue = "Basic " + new String(encodedAuth);
        return authHeaderValue;
    }

    private void setAuthenticator() {
        Authenticator.setDefault(new BasicAuthenticator());
    }

    private final class BasicAuthenticator extends Authenticator {
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication(user, password.toCharArray());
        }
    }
    
    //發送POST請求，獲取服務器返回結果
    public String readContentFromPost(String url) throws IOException {
    	//使用Authenticator 一次登入 整個session有效
    	//setAuthenticator();
        URL postUrl = new URL(url);
        HttpURLConnection connection = (HttpURLConnection) postUrl.openConnection();
        
        connection.setRequestProperty("Authorization", createBasicAuthHeaderValue()); //一次性登入
        
        connection.setConnectTimeout(2000);// 設置連接主機超時（單位：毫秒）
        connection.setReadTimeout(5000);// 設置從主機讀取數據超時（單位：毫秒）
        connection.setRequestMethod("POST");
        connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        
        // 建立與服務器的連接，並未發送數據
        connection.connect();
        
         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(connection.getOutputStream(), "utf-8");  
         //outputStreamWriter.write(data);
         outputStreamWriter.flush();
         outputStreamWriter.close();
        
        if (connection.getResponseCode() == 200) {
            // 發送數據到服務器並使用Reader讀取返回的數據
            StringBuffer sBuffer = new StringBuffer();

            InputStream inStream = null;
            byte[] buf = new byte[1024];
            inStream = connection.getInputStream();
            for (int n; (n = inStream.read(buf)) != -1;) {
                sBuffer.append(new String(buf, 0, n, "UTF-8"));
            }
            inStream.close();
            connection.disconnect();// 斷開連接
               
            return sBuffer.toString();	
        }
        else {
            
            return "fail";
        }
    }
}