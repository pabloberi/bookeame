package gestion

import grails.gorm.transactions.Transactional

import javax.crypto.Cipher
import javax.crypto.SecretKey
import javax.crypto.spec.SecretKeySpec
import java.nio.charset.StandardCharsets
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

@Transactional
class EncryptionUtilsService {

    private static final String TRANSFORMATION = "AES/ECB/PKCS5Padding"
    private static final String ALGORITHM = "AES"
    private static final String SECRET_KEY = "Gol220022@Bookeame" // Cambia esto por tu propia clave secreta
    private static final String CHARSET = StandardCharsets.UTF_8.name()

    String encrypt(String input) {
        try{
            SecretKeySpec secretKey = crearClave()

            Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding")
            cipher.init(Cipher.ENCRYPT_MODE, secretKey)

            byte[] datosEncriptar = input.getBytes("UTF-8")
            byte[] bytesEncriptados = cipher.doFinal(datosEncriptar)
            String token = Base64.getEncoder().encodeToString(bytesEncriptados)
            return token
        }catch(e){
            throw new Exception(e)
        }
    }

    String decrypt(String encryptedText) {
        try{
            SecretKeySpec secretKey = this.crearClave();

            Cipher cipher = Cipher.getInstance(TRANSFORMATION);
            cipher.init(Cipher.DECRYPT_MODE, secretKey);

            byte[] bytesEncriptados = Base64.getDecoder().decode(encryptedText);
            byte[] datosDesencriptados = cipher.doFinal(bytesEncriptados);
            String datos = new String(datosDesencriptados);

            return datos
        }catch(e){
            throw new Exception(e)
        }
    }

    private SecretKeySpec crearClave() throws UnsupportedEncodingException, NoSuchAlgorithmException {
        try{
            byte[] claveEncriptacion = SECRET_KEY.getBytes(CHARSET);

            MessageDigest sha = MessageDigest.getInstance("SHA-1");

            claveEncriptacion = sha.digest(claveEncriptacion);
            claveEncriptacion = Arrays.copyOf(claveEncriptacion, 16);

            SecretKeySpec secretKey = new SecretKeySpec(claveEncriptacion, "AES");

            return secretKey;
        }catch(e){
            throw new Exception(e)
        }
    }

}
