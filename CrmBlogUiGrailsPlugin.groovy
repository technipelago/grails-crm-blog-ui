class CrmBlogUiGrailsPlugin {
    // Dependency group
    def groupId = "grails.crm"
    // the plugin version
    def version = "1.0-SNAPSHOT"
    // the version or versions of Grails the plugin is designed for
    def grailsVersion = "2.0 > *"
    // the other plugins this plugin depends on
    def dependsOn = [:]
    // resources that are excluded from plugin packaging
    def pluginExcludes = [
            "grails-app/views/error.gsp"
    ]

    def title = "Crm Blog Author Plugin"
    def author = "Göran Ehrsson"
    def authorEmail = "goran@technipelago.se"
    def description = '''\
Grails CRM Blog Author User Interface
'''
    def documentation = "http://grails.org/plugin/crm-blog-ui"
    def license = "APACHE"
    def organization = [name: "Technipelago AB", url: "http://www.technipelago.se/"]

//    def developers = [ [ name: "Joe Bloggs", email: "joe@bloggs.net" ]]
//    def issueManagement = [ system: "JIRA", url: "http://jira.grails.org/browse/GPMYPLUGIN" ]
//    def scm = [ url: "http://svn.codehaus.org/grails-plugins/" ]

    def features = {
        crmBlog {
            description "Blog Authoring"
            link controller: "crmBlog", action: "index"
            permissions {
                guest "crmBlogPost:index,list,show"
                user "crmBlogPost:*"
                admin "crmBlogPost,crmBlogStatus:*"
            }
        }
    }
}
