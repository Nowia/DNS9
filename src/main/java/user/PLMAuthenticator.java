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
    //�n�J��k1 �^��200���`
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
    //�n�J��k2 �^��200���`
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
    
    //�o�ePOST�ШD�A����A�Ⱦ���^���G
    public String readContentFromPost(String url) throws IOException {
    	//�ϥ�Authenticator �@���n�J ���session����
    	//setAuthenticator();
        URL postUrl = new URL(url);
        HttpURLConnection connection = (HttpURLConnection) postUrl.openConnection();
        
        connection.setRequestProperty("Authorization", createBasicAuthHeaderValue()); //�@���ʵn�J
        
        connection.setConnectTimeout(2000);// �]�m�s���D���W�ɡ]���G�@��^
        connection.setReadTimeout(5000);// �]�m�q�D��Ū���ƾڶW�ɡ]���G�@��^
        connection.setRequestMethod("POST");
        connection.setDoInput(true);
        connection.setDoOutput(true);
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        
        // �إ߻P�A�Ⱦ����s���A�å��o�e�ƾ�
        connection.connect();
        
         OutputStreamWriter outputStreamWriter = new OutputStreamWriter(connection.getOutputStream(), "utf-8");  
         //outputStreamWriter.write(data);
         outputStreamWriter.flush();
         outputStreamWriter.close();
        
        if (connection.getResponseCode() == 200) {
            // �o�e�ƾڨ�A�Ⱦ��èϥ�ReaderŪ����^���ƾ�
            StringBuffer sBuffer = new StringBuffer();

            InputStream inStream = null;
            byte[] buf = new byte[1024];
            inStream = connection.getInputStream();
            for (int n; (n = inStream.read(buf)) != -1;) {
                sBuffer.append(new String(buf, 0, n, "UTF-8"));
            }
            inStream.close();
            connection.disconnect();// �_�}�s��
               
            return sBuffer.toString();	
        }
        else {
            
            return "fail";
        }
    }
}