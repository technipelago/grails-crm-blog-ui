package grails.plugins.crm.blog

import grails.converters.JSON
import grails.plugins.crm.content.CrmResourceFolder
import grails.plugins.crm.content.CrmResourceRef
import grails.plugins.crm.core.DateUtils
import grails.plugins.crm.core.TenantUtils
import grails.plugins.crm.core.WebUtils
import org.springframework.dao.DataIntegrityViolationException

import javax.servlet.http.HttpServletResponse

/**
 * Blog Authoring controller.
 */
class CrmBlogController {

    static allowedMethods = [create: ["GET", "POST"], edit: ["GET", "POST"], delete: "POST"]

    def crmSecurityService
    def selectionService
    def crmCoreService
    def crmBlogService
    def crmContentService

    def index() {
        // If any query parameters are specified in the URL, let them override the last query stored in session.
        def cmd = new CrmBlogQueryCommand()
        def query = params.getSelectionQuery()
        bindData(cmd, query ?: WebUtils.getTenantData(request, 'crmBlogQuery'))
        [cmd: cmd]
    }

    def list() {
        def baseURI = new URI('bean://crmBlogService/list')
        def query = params.getSelectionQuery()
        def uri

        switch (request.method) {
            case 'GET':
                uri = params.getSelectionURI() ?: selectionService.addQuery(baseURI, query)
                break
            case 'POST':
                uri = selectionService.addQuery(baseURI, query)
                WebUtils.setTenantData(request, 'crmBlogQuery', query)
                break
        }

        params.max = Math.min(params.max ? params.int('max') : 10, 100)

        def result
        try {
            result = selectionService.select(uri, params)
            [crmBlogPostList: result, crmBlogPostTotal: result.totalCount, selection: uri]
        } catch (Exception e) {
            flash.error = e.message
            [crmBlogPostList: [], crmBlogPostTotal: 0, selection: uri]
        }
    }

    def clearQuery() {
        WebUtils.setTenantData(request, 'crmBlogQuery', null)
        redirect(action: 'index')
    }

    def create() {
        def tenant = TenantUtils.tenant
        def user = crmSecurityService.getCurrentUser()
        def userList = crmSecurityService.getTenantUsers()
        def statusList = CrmBlogStatus.findAllByTenantId(tenant)
        def crmBlogPost = new CrmBlogPost(username: user.username, status: statusList?.head())

        bindData(crmBlogPost, params, [include: CrmBlogPost.BIND_WHITELIST])

        def template = [text: '']
        def fileList = []

        switch (request.method) {
            case "GET":
                return [crmBlogPost: crmBlogPost, template: template, files: fileList, statusList: statusList, userList: userList]
            case "POST":

                def date = params.remove('date') ?: new Date().format("yyyy-MM-dd")
                def visibleFrom = params.remove('visibleFrom')
                def visibleTo = params.remove('visibleTo')

                bindData(crmBlogPost, params, [include: CrmBlogPost.BIND_WHITELIST])

                bindDate(crmBlogPost, 'date', date, user?.timezoneInstance)
                bindDate(crmBlogPost, 'visibleFrom', visibleFrom ? visibleFrom + ' 00:00' : null, user?.timezoneInstance)
                bindDate(crmBlogPost, 'visibleFrom', visibleTo ? visibleTo + ' 23:59' : null, user?.timezoneInstance)

                if (!crmBlogPost.save(flush: true)) {
                    render(view: "create", model: [crmBlogPost: crmBlogPost, template: template, files: fileList, statusList: statusList, userList: userList])
                    return
                }

                byte[] bytes = (params.text ?: '').getBytes('UTF-8')
                def inputStream = new ByteArrayInputStream(bytes)
                crmContentService.createResource(inputStream, 'content.html', bytes.length, 'text/html', crmBlogPost,
                        [title: 'Artikelns innehåll', status: "shared"])

                flash.success = message(code: 'crmBlogPost.created.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), crmBlogPost.toString()])
                redirect(action: "show", id: crmBlogPost.id)
                break
        }
    }

    def edit(Long id) {
        def tenant = TenantUtils.tenant
        def crmBlogPost = CrmBlogPost.findByIdAndTenantId(id, tenant)
        if (!crmBlogPost) {
            flash.error = message(code: 'crmBlogPost.not.found.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), id])
            redirect(action: "index")
            return
        }
        def user = crmSecurityService.getCurrentUser()
        def userList = crmSecurityService.getTenantUsers()
        def statusList = CrmBlogStatus.findAllByTenantId(tenant)
        def files = crmContentService.findResourcesByReference(crmBlogPost)
        def template = files.find { it.name == 'content.html' }

        switch (request.method) {
            case "GET":
                return [crmBlogPost: crmBlogPost, template: template, files: files, statusList: statusList, userList: userList]
            case "POST":
                if (params.int('version') != null) {
                    if (crmBlogPost.version > params.int('version')) {
                        crmBlogPost.errors.rejectValue("version", "crmBlogPost.optimistic.locking.failure",
                                [message(code: 'crmBlogPost.label', default: 'Blog Post')] as Object[],
                                "Another user has updated this Post while you were editing")
                        render(view: "edit", model: [crmBlogPost: crmBlogPost, template: template, files: files, statusList: statusList, userList: userList])
                        return
                    }
                }

                def date = params.remove('date') ?: new Date().format("yyyy-MM-dd")
                def visibleFrom = params.remove('visibleFrom')
                def visibleTo = params.remove('visibleTo')

                bindData(crmBlogPost, params, [include: CrmBlogPost.BIND_WHITELIST])

                bindDate(crmBlogPost, 'date', date, user?.timezoneInstance)
                bindDate(crmBlogPost, 'visibleFrom', visibleFrom ? visibleFrom + ' 00:00' : null, user?.timezoneInstance)
                bindDate(crmBlogPost, 'visibleTo', visibleTo ? visibleTo + ' 23:59' : null, user?.timezoneInstance)

                if (!crmBlogPost.save(flush: true)) {
                    render(view: "edit", model: [crmBlogPost: crmBlogPost, template: template, files: files, statusList: statusList, userList: userList])
                    return
                }

                byte[] bytes = (params.text ?: '').getBytes('UTF-8')
                def inputStream = new ByteArrayInputStream(bytes)
                if (template) {
                    crmContentService.updateResource(template, inputStream, 'text/html')
                } else {
                    template = crmContentService.createResource(inputStream, 'content.html', bytes.length, 'text/html', crmBlogPost,
                            [title: 'Artikelns innehåll', status: "shared"])
                }

                flash.success = message(code: 'crmBlogPost.updated.message', args: [message(code: 'crmBlogPost.label', default: 'Blog'), crmBlogPost.toString()])
                redirect(action: "show", id: crmBlogPost.id)
                break
        }
    }

    def delete(Long id) {

        def tenant = TenantUtils.tenant
        def crmBlogPost = CrmBlogPost.findByIdAndTenantId(id, tenant)
        if (!crmBlogPost) {
            flash.error = message(code: 'crmBlogPost.not.found.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), id])
            redirect(action: "index")
            return
        }

        try {
            def tombstone = crmBlogPost.toString()
            crmBlogPost.delete(flush: true)
            flash.warning = message(code: 'crmBlogPost.deleted.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), tombstone])
            redirect(action: "index")
        }
        catch (DataIntegrityViolationException e) {
            flash.error = message(code: 'crmBlogPost.not.deleted.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), id])
            redirect(action: "show", id: id)
        }
    }

    def show(Long id) {

        def tenant = TenantUtils.tenant
        def crmBlogPost = CrmBlogPost.findByIdAndTenantId(id, tenant)
        if (!crmBlogPost) {
            flash.error = message(code: 'crmBlogPost.not.found.message', args: [message(code: 'crmBlogPost.label', default: 'Blog Post'), id])
            redirect(action: "index")
            return
        }

        def files = crmContentService.findResourcesByReference(crmBlogPost)
        def template = files.find { it.name == 'content.html' }

        [crmBlogPost: crmBlogPost, template: template, files: files]
    }

    private void bindDate(CrmBlogPost target, String property, String value, TimeZone timezone = null) {
        if (value) {
            try {
                target[property] = DateUtils.parseDateTime(value, timezone ?: TimeZone.default)
            } catch (Exception e) {
                def entityName = message(code: 'crmBlogPost.label', default: 'Blog Post')
                def propertyName = message(code: 'crmBlogPost.' + property + '.label', default: property)
                target.errors.rejectValue(property, 'default.invalid.date.message', [propertyName, entityName, value.toString(), e.message].toArray(), "Invalid date: {2}")
            }
        } else {
            target[property] = null
        }
    }

    def browse(String reference) {
        def domainInstance
        if (reference) {
            domainInstance = crmCoreService.getReference(reference)
            if (!domainInstance) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
            def tenant = TenantUtils.tenant
            if (domainInstance.hasProperty('tenantId') && domainInstance.tenantId != tenant) {
                log.warn "Forbidden access to $reference in tenant ${tenant} from ${request.remoteAddr}"
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
        }
        [reference: domainInstance, identifier: reference]
    }

    def tree(String reference) {
        def domainInstance
        if (reference) {
            domainInstance = crmCoreService.getReference(reference)
            if (!domainInstance) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
            def tenant = TenantUtils.tenant
            if (domainInstance.hasProperty('tenantId') && domainInstance.tenantId != tenant) {
                log.warn "Forbidden access to $reference in tenant ${tenant} from ${request.remoteAddr}"
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
        }

        def root = new Node(null, 'root', [type: 'folder'])

        if (domainInstance) {
            def node = new Node(root, domainInstance.toString(), [type: 'folder', id: reference, open: true])
            /*def images = crmContentService.findResourcesByReference(domainInstance).findAll { isImage(it.name) }
            for (img in images) {
                new Node(node, img.name, [type: 'file', id: crmCoreService.getReferenceIdentifier(img)])
            }*/
        }
        def folders = crmContentService.list()
        addFolders(folders, root)
        [node: root, reference: domainInstance, identifier: reference]
    }

    private void addFolders(Collection folders, Node parent) {
        for (folder in folders) {
            def node = new Node(parent, folder.toString(), [type: 'folder', id: crmCoreService.getReferenceIdentifier(folder)])
            addFolders(folder.folders, node)
            /*def images = folder.files.findAll { isImage(it.name) }
            for (img in images) {
                new Node(node, img.name, [type: 'file', id: crmCoreService.getReferenceIdentifier(img)])
            }*/
        }
    }

    private boolean isImage(String name) {
        name = name.toLowerCase()
        name.endsWith('.png') || name.endsWith('.jpg') || name.endsWith('.gif')
    }

    def images(String reference) {
        def tenant = TenantUtils.tenant
        def domainInstance
        if (reference) {
            domainInstance = crmCoreService.getReference(reference)
            if (!domainInstance) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
            if (domainInstance.hasProperty('tenantId') && domainInstance.tenantId != tenant) {
                log.warn "Forbidden access to $reference in tenant ${tenant} from ${request.remoteAddr}"
                response.sendError(HttpServletResponse.SC_NOT_FOUND)
                return
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
            return
        }
        def images = crmContentService.findResourcesByReference(domainInstance).findAll { isImage(it.name) }
        def path = crmContentService.getAbsolutePath(domainInstance)
        if (path) {
            path = path.split('/')
        } else {
            path = [domainInstance.toString()]
        }
        def baseUrl = grailsApplication.config.crm.web.url ?: ''
        withFormat {
            html {
                return [reference: domainInstance, identifier: reference, base: baseUrl, path: path, images: images]
            }
            json {
                def result = images.collect { ref ->
                    def md = ref.metadata
                    def result = [id: ref.id, name: ref.name, title: ref.title, base: baseUrl, path: path, bytes: md.bytes, size: md.size,
                            contentType: md.contentType, status: ref.statusText, modified: md.modified]
                    def ctrl
                    if (domainInstance instanceof CrmResourceFolder) {
                        if (!(domainInstance.sharedPath || ref.shared || (ref.published && (ref.tenantId == tenant)))) {
                            throw new RuntimeException("Can't link to a non-shared resource [$ref]")
                        }
                        ctrl = 'r'
                    } else {
                        if (!(ref.shared || (ref.published && (ref.tenantId == tenant)))) {
                            throw new RuntimeException("Can't link to a non-shared resource [$ref]")
                        }
                        ctrl = 's'
                    }
                    //def url = g.createLink(absolute: false, controller: ctrl).toString()
                    def url = baseUrl + '/' + ctrl
                    def absolutePath = crmContentService.getAbsolutePath(ref, true)
                    if (absolutePath) {
                        result.url = "${url}/${ref.tenantId}/${absolutePath}"
                    } else {
                        throw new RuntimeException("Trying to use tag [createResourceLink] with a non-shared resource [$ref]")
                    }
                    return result
                }
                render result as JSON
            }
        }
    }
}
