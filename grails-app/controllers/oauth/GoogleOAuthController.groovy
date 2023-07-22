package oauth


import auth.UserUtilService
import com.sun.istack.Nullable
import gestion.General
import grails.plugin.springsecurity.SpringSecurityService
import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.oauth2.SpringSecurityOauth2BaseService
import grails.plugin.springsecurity.oauth2.exception.OAuth2Exception
import grails.plugin.springsecurity.oauth2.token.OAuth2SpringToken
import grails.plugin.springsecurity.userdetails.GrailsUser
import groovy.util.logging.Slf4j
import org.springframework.security.core.context.SecurityContextHolder

@Slf4j
@Secured(['permitAll()'])
class GoogleOAuthController {

    public static final String SPRING_SECURITY_OAUTH_TOKEN = 'springSecurityOAuthToken'

    SpringSecurityOauth2BaseService springSecurityOauth2BaseService
    SpringSecurityService springSecurityService

    UserUtilService userUtilService

    def onSuccess(String provider) {
        provider = "google"
        if (!provider) {
            log.warn "The Spring Security OAuth callback URL must include the 'provider' URL parameter"
            throw new OAuth2Exception("The Spring Security OAuth callback URL must include the 'provider' URL parameter")
        }
        def sessionKey = springSecurityOauth2BaseService.sessionKeyForAccessToken(provider)
        if (!session[sessionKey]) {
            log.warn "No OAuth token in the session for provider '${provider}'"
            throw new OAuth2Exception("Authentication error for provider '${provider}'")
        }
        // Create the relevant authentication token and attempt to log in.
        OAuth2SpringToken oAuthToken = springSecurityOauth2BaseService.createAuthToken(provider, session[sessionKey])
        GrailsUser grailsUser = userUtilService?.identificarCuenta( oAuthToken?.email,  oAuthToken?.accessToken?.accessToken)
        oAuthToken.setAuthorities(grailsUser.authorities)
        oAuthToken.setPrincipal( grailsUser )
        oAuthToken.setAuthenticated(true)
        authenticateAndRedirect(oAuthToken, getDefaultTargetUrl())

//        if( !userUtilService?.faltanDatos(grailsUser?.username) ){
//            authenticateAndRedirect(oAuthToken, getDefaultTargetUrl())
//        }else{
//            session[SPRING_SECURITY_OAUTH_TOKEN] = oAuthToken
//            def redirectUrl = springSecurityOauth2BaseService.getAskToLinkOrCreateAccountUri()
//            if (!redirectUrl) {
//                log.warn "grails.plugin.springsecurity.oauth.registration.askToLinkOrCreateAccountUri configuration option must be set"
//                throw new OAuth2Exception('Internal error')
//            }
//            log.debug "Redirecting to askToLinkOrCreateAccountUri: ${redirectUrl}"
//            redirect( action: 'ask', id: User.findByUsername(grailsUser?.username)?.id )
//        }
    }

    protected void authenticateAndRedirect(@Nullable OAuth2SpringToken oAuthToken, redirectUrl) {
        session.removeAttribute SPRING_SECURITY_OAUTH_TOKEN
        SecurityContextHolder.context.authentication = oAuthToken
        redirect(redirectUrl instanceof Map ? redirectUrl : [uri: redirectUrl])
    }

    protected Map getDefaultTargetUrl() {
        def config = SpringSecurityUtils.securityConfig
        General general = General.findByNombre("baseUrl")
        def defaultUrlOnNull = '/'
        if (general?.valor && !config.successHandler.alwaysUseDefault) {
            return [url: (general?.valor  + "/" ?: defaultUrlOnNull)]
        }
        return [uri: (config.successHandler.defaultTargetUrl ?: defaultUrlOnNull)]
    }
}
