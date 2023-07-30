package auth

import com.google.api.client.googleapis.auth.oauth2.GoogleCredential
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.HttpTransport
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.JsonFactory
import com.google.api.client.json.jackson2.JacksonFactory
import com.google.api.services.people.v1.PeopleService
import com.google.api.services.people.v1.model.Person
import grails.gorm.transactions.Transactional
import grails.plugin.springsecurity.userdetails.GrailsUser
import org.springframework.security.core.GrantedAuthority
import org.springframework.security.core.authority.SimpleGrantedAuthority

@Transactional
class UserUtilService {

    GrailsUser identificarCuenta(String email, String accessToken) {
        try{
            User user = User.findByEmail(email)
            if( !user ){
                user = crearUsuarioGoogle(email, accessToken)
            }

            Set<Role> aux = user.getAuthorities()
            List<String> authorities = new ArrayList<>()

            if( aux?.size() > 0 ){
                aux.each { rol ->
                    authorities.add(rol?.authority)
                }
            }else{
                authorities.add("ROLE_USER")
            }
            List<GrantedAuthority> grantedAuthorities = new ArrayList<>();
            authorities.each { authority ->
                grantedAuthorities.add(new SimpleGrantedAuthority(authority))
            }

            GrailsUser grailsUser = new GrailsUser(
                    user?.username,
                    user?.password,
                    user?.enabled,
                    user.accountExpired,
                    user.passwordExpired,
                    user.accountLocked,
                    grantedAuthorities,
                    user?.id
            )
            return grailsUser
        }catch(e){
            println(e)
        }
        return null
    }

    @Transactional
    def crearUsuarioGoogle(String email, String accessToken){
        User.withTransaction {
            User user = new User()
            user.username = email
            user.password = UUID.randomUUID()
            user.email = email
            user.enabled = true
            user.accountExpired = false
            user.accountLocked = false
            user.passwordExpired = false
            user.invitado = false
            user.provider = "google"
            user.foto = obtainGoogleUserImage(accessToken)
            user = obtenerInformacionUsuario(user, accessToken)
            user.save(flush: true)
            UserRole userRole = new UserRole()
            userRole.user = user
            userRole.role = Role.findByAuthority("ROLE_USER")
            userRole.save(flush: true)
            return user
        }
    }

    def faltanDatos(String username){
        User user = User.findByUsername(username)
        if( !user?.nombre || !user?.apellidoPaterno ||
                !user?.rut || !user?.fechaNac || !user?.celular){
            return true
        }
         return false
    }

    def obtainGoogleUserImage(String accessToken) {
        try{
            HttpTransport httpTransport = new NetHttpTransport()
            JsonFactory jsonFactory = new JacksonFactory()
            GoogleCredential credential = new GoogleCredential().setAccessToken(accessToken)
            PeopleService peopleService = new PeopleService.Builder(httpTransport, jsonFactory, credential).build()
            Person profile = peopleService.people().get("people/me").setPersonFields("photos").execute()
            String imageUrl = profile.photos[0].url
            return imageUrl
        }catch(e){
            return null
        }
    }

    def obtenerInformacionUsuario(User user, String accessToken) {
        try{
            HttpTransport httpTransport = new NetHttpTransport()
            JsonFactory jsonFactory = new JacksonFactory()
            GoogleCredential credential = new GoogleCredential().setAccessToken(accessToken)
            PeopleService peopleService = new PeopleService.Builder(httpTransport, jsonFactory, credential).build()
            Person profile = peopleService.people().get("people/me").setPersonFields("names,emailAddresses").execute()

            String givenName = profile.names[0].givenName
            String familyName = profile.names[0].familyName
            user?.nombre = givenName
            user?.apellidoPaterno = familyName
            return user
        }catch(e){
            return user
        }
    }
}
