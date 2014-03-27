/*
 * Copyright (c) 2013 Goran Ehrsson.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

class CrmBlogUiGrailsPlugin {
    def groupId = "grails.crm"
    def version = "1.2.3"
    def grailsVersion = "2.0 > *"
    def dependsOn = [:]
    def pluginExcludes = [
            "grails-app/views/error.gsp"
    ]
    def title = "GR8 CRM Blog Authoring Plugin"
    def author = "Göran Ehrsson"
    def authorEmail = "goran@technipelago.se"
    def description = '''\
GR8 CRM Blog Author User Interface
'''
    def documentation = "https://github.com/technipelago/grails-crm-blog-ui"
    def license = "APACHE"
    def organization = [name: "Technipelago AB", url: "http://www.technipelago.se/"]
    def issueManagement = [system: "github", url: "https://github.com/technipelago/grails-crm-blog-ui/issues"]
    def scm = [url: "https://github.com/technipelago/grails-crm-blog-ui"]

    def features = {
        crmBlog {
            description "Blog Authoring"
            link controller: "crmBlog", action: "index"
            permissions {
                guest "crmBlogPost:index,list,show"
                partner "crmBlogPost:index,list,show"
                user "crmBlogPost:*"
                admin "crmBlogPost,crmBlogStatus:*"
            }
        }
    }
}
