package grails.plugins.crm.blog

import org.springframework.dao.DataIntegrityViolationException

import javax.servlet.http.HttpServletResponse

/**
 * Blog Status CRUD controller.
 */
class CrmBlogStatusController {

    static allowedMethods = [create: ['GET', 'POST'], edit: ['GET', 'POST'], delete: 'POST']

    static navigation = [
            [group: 'admin',
                    order: 810,
                    title: 'crmBlogStatus.label',
                    action: 'index'
            ]
    ]

    def selectionService
    def crmBlogService

    def domainClass = CrmBlogStatus

    def index() {
        redirect action: 'list', params: params
    }

    def list() {
        def baseURI = new URI('gorm://crmBlogStatus/list')
        def query = params.getSelectionQuery()
        def uri

        switch (request.method) {
            case 'GET':
                uri = params.getSelectionURI() ?: selectionService.addQuery(baseURI, query)
                break
            case 'POST':
                uri = selectionService.addQuery(baseURI, query)
                grails.plugins.crm.core.WebUtils.setTenantData(request, 'crmBlogStatusQuery', query)
                break
        }

        params.max = Math.min(params.max ? params.int('max') : 20, 100)

        try {
            def result = selectionService.select(uri, params)
            [crmBlogStatusList: result, crmBlogStatusTotal: result.totalCount, selection: uri]
        } catch (Exception e) {
            flash.error = e.message
            [crmBlogStatusList: [], crmBlogStatusTotal: 0, selection: uri]
        }
    }

    def create() {
        def crmBlogStatus = crmBlogService.createBlogStatus(params)
        switch (request.method) {
            case 'GET':
                return [crmBlogStatus: crmBlogStatus]
            case 'POST':
                if (!crmBlogStatus.save(flush: true)) {
                    render view: 'create', model: [crmBlogStatus: crmBlogStatus]
                    return
                }

                flash.success = message(code: 'crmBlogStatus.created.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), crmBlogStatus.toString()])
                redirect action: 'list'
                break
        }
    }

    def edit() {
        switch (request.method) {
            case 'GET':
                def crmBlogStatus = domainClass.get(params.id)
                if (!crmBlogStatus) {
                    flash.error = message(code: 'crmBlogStatus.not.found.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), params.id])
                    redirect action: 'list'
                    return
                }

                return [crmBlogStatus: crmBlogStatus]
            case 'POST':
                def crmBlogStatus = domainClass.get(params.id)
                if (!crmBlogStatus) {
                    flash.error = message(code: 'crmBlogStatus.not.found.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), params.id])
                    redirect action: 'list'
                    return
                }

                if (params.version) {
                    def version = params.version.toLong()
                    if (crmBlogStatus.version > version) {
                        crmBlogStatus.errors.rejectValue('version', 'crmBlogStatus.optimistic.locking.failure',
                                [message(code: 'crmBlogStatus.label', default: 'Blog Status')] as Object[],
                                "Another user has updated this Type while you were editing")
                        render view: 'edit', model: [crmBlogStatus: crmBlogStatus]
                        return
                    }
                }

                crmBlogStatus.properties = params

                if (!crmBlogStatus.save(flush: true)) {
                    render view: 'edit', model: [crmBlogStatus: crmBlogStatus]
                    return
                }

                flash.success = message(code: 'crmBlogStatus.updated.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), crmBlogStatus.toString()])
                redirect action: 'list'
                break
        }
    }

    def delete() {
        def crmBlogStatus = domainClass.get(params.id)
        if (!crmBlogStatus) {
            flash.error = message(code: 'crmBlogStatus.not.found.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), params.id])
            redirect action: 'list'
            return
        }

        if (isInUse(crmBlogStatus)) {
            render view: 'edit', model: [crmBlogStatus: crmBlogStatus]
            return
        }

        try {
            def tombstone = crmBlogStatus.toString()
            crmBlogStatus.delete(flush: true)
            flash.warning = message(code: 'crmBlogStatus.deleted.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), tombstone])
            redirect action: 'list'
        }
        catch (DataIntegrityViolationException e) {
            flash.error = message(code: 'crmBlogStatus.not.deleted.message', args: [message(code: 'crmBlogStatus.label', default: 'Blog Status'), params.id])
            redirect action: 'edit', id: params.id
        }
    }

    private boolean isInUse(CrmBlogStatus status) {
        def count = CrmBlogPost.countByStatus(status)
        def rval = false
        if (count) {
            flash.error = message(code: "crmBlogStatus.delete.error.reference", args:
                    [message(code: 'crmBlogStatus.label', default: 'Blog Status'),
                            message(code: 'crmBlogPost.label', default: 'Blog'), count],
                    default: "This {0} is used by {1} {2}")
            rval = true
        }

        return rval
    }

    def moveUp(Long id) {
        def target = domainClass.get(id)
        if (target) {
            def sort = target.orderIndex
            def prev = domainClass.createCriteria().list([sort: 'orderIndex', order: 'desc']) {
                lt('orderIndex', sort)
                maxResults 1
            }?.find {it}
            if (prev) {
                domainClass.withTransaction {tx ->
                    target.orderIndex = prev.orderIndex
                    prev.orderIndex = sort
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
        }
        redirect action: 'list'
    }

    def moveDown(Long id) {
        def target = domainClass.get(id)
        if (target) {
            def sort = target.orderIndex
            def next = domainClass.createCriteria().list([sort: 'orderIndex', order: 'asc']) {
                gt('orderIndex', sort)
                maxResults 1
            }?.find {it}
            if (next) {
                domainClass.withTransaction {tx ->
                    target.orderIndex = next.orderIndex
                    next.orderIndex = sort
                }
            }
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND)
        }
        redirect action: 'list'
    }
}
