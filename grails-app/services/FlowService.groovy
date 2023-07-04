
import gestion.General
import grails.gorm.transactions.Transactional

import groovy.json.JsonSlurper

import javax.crypto.Mac
import javax.crypto.spec.SecretKeySpec
import java.nio.charset.StandardCharsets
import java.security.InvalidKeyException
import java.security.NoSuchAlgorithmException
import java.text.SimpleDateFormat

/**
 * UserService
 * A service class encapsulates the core business logic of a Grails application
 */

@Transactional
class FlowService {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    def paymentStatus(String token, String apiKey, String secretKey) {
        def params = [
                "apiKey": apiKey,
                "token" : token
        ]
        params["s"] = sign(params, secretKey)
        String parametros = formatoUrl(params)

        def url = new URL("${General.findByNombre("serverFlow")?.valor}/payment/getStatus?" + parametros)
        def connection = url.openConnection() as HttpURLConnection
        connection.requestMethod = 'GET'
        if (connection.responseCode == 200) {
            def resp = connection.content.text
            def list = new JsonSlurper().parseText( resp )
            return list?.status
        } else {
            return connection.responseCode
        }
    }

    def createPayment(def params, String secretKey){
        def array = []
        params["s"] = sign(params, secretKey)
        String parametros = formatoUrl(params)
        byte[] postData = parametros.getBytes(StandardCharsets.UTF_8)
        HttpURLConnection conn = conexion(postData, "/payment/create", "POST","application/x-www-form-urlencoded",  General.findByNombre("serverFlow")?.valor)
        try {
            DataOutputStream wr = new DataOutputStream(conn.getOutputStream())
            wr.write(postData)
            def json = conn.inputStream.withCloseable { inStream ->
                new JsonSlurper().parse(inStream as InputStream)
            }
            json.each { item ->
                array.add(item.value)
            }
            return array
        } catch (e) {
            return array
        }
    }

    def getPaymentsValidate(String apiKey, String secretKey) {
        boolean exito = true
        Date hoy = new Date()
        String fechaHoy = sdf.format( hoy )
        def params = [
                "apiKey": apiKey,
                "date" : fechaHoy
        ]
        params["s"] = sign(params, secretKey)
        String parametros = formatoUrl(params)

        def url = new URL("${General.findByNombre("serverFlow")?.valor}/payment/getPayments?" + parametros)
        def connection = url.openConnection() as HttpURLConnection
        connection.requestMethod = 'GET'
        if (connection.responseCode == 200) {
            exito = true
        } else {
            exito = false
        }
        return exito
    }

    def sign(def params, String secretKey){
        String toSign = ""
        for ( value in params){
            toSign += value.key + value.value
        }
        String sign = hmacSHA256(secretKey, toSign)
        return sign
    }

    def hmacSHA256(String secret, String data) {
        try {
            if (secret == null || data == null) {
                return ""
            }
            SecretKeySpec secretKeySpec = new SecretKeySpec(secret.getBytes("UTF-8"), "HmacSHA256")
            Mac mac = Mac.getInstance("HmacSHA256")
            mac.init(secretKeySpec)
            byte[] digest = mac.doFinal(data.getBytes("UTF-8"))
            return byteArrayToString(digest)
        } catch (InvalidKeyException ignored) {
            throw new RuntimeException("Invalid key exception while converting to HMac SHA256")
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace()
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace()
        }
        return null
    }

    private static String byteArrayToString(byte[] data) {
        BigInteger bigInteger = new BigInteger(1, data)
        String hash = bigInteger.toString(16)
        while (hash.length() < 64) {
            hash = "0" + hash
        }
        return hash
    }

    def formatoUrl(def params){
        String parametros = ""
        if(params.size() > 0 ){
            for ( value in params){
                parametros += "&" + URLEncoder.encode(value.key.toString(), "UTF-8") + "=" + URLEncoder.encode(value.value.toString(), "UTF-8")
            }
            return parametros.substring(1)
        }
    }

    HttpURLConnection conexion( byte[] postData, String metodoFlow, String requestMethod, String requestProperty, String servidor){
        int postDataLength = postData.length
        String request = servidor + metodoFlow
        URL url = new URL(request)
        HttpURLConnection conn = (HttpURLConnection) url.openConnection()
        conn.setDoOutput(true)
        conn.setInstanceFollowRedirects(false)
        conn.setRequestMethod(requestMethod)
        conn.setRequestProperty("Content-Type", requestProperty)
        conn.setRequestProperty("charset", "utf-8")
        conn.setRequestProperty("Content-Length", Integer.toString(postDataLength))
        conn.setUseCaches(false)

        return conn
    }

    String correlativoFlow(){
        Formatter  frm = new Formatter()
        Date today = new Date()
        Calendar c = Calendar.getInstance()
        c.setTime(today)
        frm.format("%08d", General.findByNombre('correlativoFlow').valor.toInteger())
        def mes = c.get(Calendar.MONTH) + 1
        return "BKM" + c.get(Calendar.DAY_OF_MONTH).toString() + mes.toString() + c.get(Calendar.YEAR).toString() + frm
    }

    void avanceCorrelativo(){
        General conf = General.findByNombre('correlativoFlow')
        Integer valorAux = conf?.valor.toInteger() + 1
        conf?.valor = valorAux.toString()
        conf.save()
    }

}
