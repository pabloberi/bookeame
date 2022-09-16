import auth.User
import auth.UserService
import grails.plugin.springsecurity.annotation.Secured

@Secured(['permitAll'])
class WebServiceController {
    def springSecurityService
    UserService userService
    def index() { }

    @Secured(['isAuthenticated()'])
    def getTokenFirebaseFromApp(String token){
        User user = springSecurityService.getCurrentUser()
        if( user && token ){
            try{
                user.tokenFirebase = token
                userService.save(user)
            }catch(e){}
        }
        redirect(controller: 'home', action: 'welcomeApp', id: user?.id, params:[username: user?.username])
    }

}
