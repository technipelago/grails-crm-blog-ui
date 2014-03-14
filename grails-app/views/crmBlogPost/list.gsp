<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogPost.label', default: 'Blog Post')}"/>
    <title><g:message code="crmBlogPost.list.title" args="[entityName]"/></title>
</head>

<body>

<crm:header title="crmBlogPost.list.title" subtitle="crmBlogPost.totalCount.label"
            args="${[entityName, crmBlogPostTotal]}">
</crm:header>


<table class="table table-striped">
    <thead>
    <tr>
        <crm:sortableColumn property="title"
                            title="${message(code: 'crmBlogPost.title.label', default: 'Title')}"/>
        <crm:sortableColumn property="username"
                                    title="${message(code: 'crmBlogPost.username.label', default: 'Author')}"/>
        <crm:sortableColumn property="date"
                                    title="${message(code: 'crmBlogPost.date.label', default: 'Published')}"/>
        <crm:sortableColumn property="status"
                            title="${message(code: 'crmBlogPost.status.label', default: 'Status')}"/>
    </tr>
    </thead>
    <tbody>
    <g:each in="${crmBlogPostList}" var="crmBlogPost">
        <tr class="${crmBlogPost.active ? '' : 'disabled'}">

            <td>
                <select:link action="show" id="${crmBlogPost.id}" selection="${selection}">
                    ${fieldValue(bean: crmBlogPost, field: "title")}
                </select:link>
            </td>

            <td>
                <g:if test="${crmBlogPost.username}">
                    <crm:user username="${crmBlogPost.username}">${name}</crm:user>
                </g:if>
            </td>

            <td>
                <g:formatDate type="date" date="${crmBlogPost.date}"/>
            </td>

            <td>
                <g:fieldValue bean="${crmBlogPost}" field="status"/>
            </td>
        </tr>
    </g:each>
    </tbody>
</table>

<crm:paginate total="${crmBlogPostTotal}"/>

<div class="form-actions btn-toolbar">
    <crm:selectionMenu visual="primary"/>
    <div class="btn-group">
        <crm:button type="link" action="create" visual="success" icon="icon-file icon-white"
                    label="crmBlogPost.button.create.label" permission="crmBlogPost:create"/>
    </div>
</div>

</body>
</html>
