class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

//        "/"(view:"/index")
        "/"(controller: 'home', action: 'dashboard')
        "500"(view:'/error')
        "404"(view:'/notFound')
//
//        "/oauth2/google/authenticate"(controller: 'springSecurityOAuth2', action: 'authenticate')
//        "/oauth2/google/callback"(controller: 'googleOauth', action: 'callback')
        "/oauth2/google/success"(controller: 'googleOAuth', action: 'onSuccess')
//        "/oauth2/google/failure"(controller: 'googleOauth', action: 'onFailure')
//        "/oauth2/ask/$id?"(controller: 'googleOAuth', action: 'ask')
//        "/oauth2/linkaccount"(controller: 'googleOauth', action: 'linkAccount')
//        "/oauth2/createaccount"(controller: 'googleOauth', action: 'createAccount')
//        '500'(controller: 'login', action: 'auth', exception: OAuth2Exception)
    }
}
