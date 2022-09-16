<%@ page import="grails.core.GrailsApplication; grails.web.servlet.mvc.GrailsParameterMap; grails.web.mvc.FlashScope; grails.core.GrailsControllerClass; org.grails.web.util.GrailsApplicationAttributes; org.grails.web.servlet.mvc.GrailsWebRequest; grails.web.mapping.LinkGenerator; org.springframework.web.servlet.support.RequestDataValueProcessor; grails.web.mapping.mvc.RedirectEventListener; grails.artefact.controller.support.ResponseRedirector" %>
<!-- DOC: script to save and load page settings -->
<script>
    /**
     *	This script should be placed right after the body tag for fast execution
     *	Note: the script is written in pure javascript and does not depend on thirdparty library
     **/
    'use strict';

    var classHolder = document.getElementsByTagName("BODY")[0],
        /**
         * Load from localstorage
         **/

        themeSettings =  (localStorage.getItem('themeSettings')) ? JSON.parse(localStorage.getItem('themeSettings')) : {},
        themeURL = themeSettings.themeURL || '',
        themeOptions = themeSettings.themeOptions || '';

    /**
     * Load theme options
     **/
    if (themeSettings.themeOptions) {
        classHolder.className = themeSettings.themeOptions;
        console.log("%c✔ Theme settings loaded", "color: #148f32");
    } else {
        console.log("Heads up! Theme settings is empty or does not exist, loading default settings...");
    }
    if (themeSettings.themeURL && !document.getElementById('mytheme') ) {
        var cssfile  = document.createElement('link');
        cssfile.id = 'mytheme';
        cssfile.rel  = 'stylesheet';
        cssfile.href = themeURL;
        // document.getElementsByTagName('head')[0].appendChild(cssfile);
    }
    /**
     * Save to localstorage
     **/
    var saveSettings = function (){
        themeSettings.themeOptions =  String(classHolder.className).split(/[^\w-]+/).filter(function(item) {
            return /^(nav|header|mod|display)-/i.test(item);
        }).join(' ');
        if ( document.getElementById('mytheme') ){
            themeSettings.themeURL = document.getElementById('mytheme').getAttribute("href");
        };
        localStorage.setItem( 'themeSettings', JSON.stringify(themeSettings) );
    }
    /**
     * Reset settings
     **/
    var resetSettings = function (){
        localStorage.setItem("themeSettings", "");
    }
</script>