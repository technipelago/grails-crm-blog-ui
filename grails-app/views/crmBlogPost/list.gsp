<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogPost.label', default: 'Blog Post')}"/>
    <title><g:message code="crmBlogPost.list.title" args="[entityName]"/></title>
</head>

<body>

<crm:header title="crmBlogPost.list.title" subtitle="Sökningen resulterade i ${crmBlogPostTotal} st artiklar"
            args="[entityName]">
</crm:header>


<table class="table table-striped">
    <thead>
    <tr>
        <crm:sortableColumn property="title"
                            title="${message(code: 'crmBlogPost.title.label', default: 'Title')}"/>

        <th><g:message code="crmBlogPost.date.label" default="Date"/></th>
        <crm:sortableColumn property="status"
                            title="${message(code: 'crmBlogPost.status.label', default: 'Status')}"/>
    </tr>
    </thead>
    <tbody>
    <g:each in="${crmBlogPostList}" var="crmBlogPost">
        <tr class="${crmBlogPost.active ? '' : 'disabled'}">

            <td>
                <g:link controller="crmBlogPost" action="show" id="${crmBlogPost.id}">
                    ${fieldValue(bean: crmBlogPost, field: "title")}
                </g:link>
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
