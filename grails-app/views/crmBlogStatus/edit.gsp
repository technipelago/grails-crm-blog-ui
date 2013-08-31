<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogStatus.label', default: 'Blog Status')}"/>
    <title><g:message code="crmBlogStatus.edit.title" args="[entityName, crmBlogStatus]"/></title>
</head>

<body>

<crm:header title="crmBlogStatus.edit.title" args="[entityName, crmBlogStatus]"/>

<div class="row-fluid">
    <div class="span9">

        <g:hasErrors bean="${crmBlogStatus}">
            <crm:alert class="alert-error">
                <ul>
                    <g:eachError bean="${crmBlogStatus}" var="error">
                        <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                                error="${error}"/></li>
                    </g:eachError>
                </ul>
            </crm:alert>
        </g:hasErrors>

        <g:form class="form-horizontal" action="edit"
                id="${crmBlogStatus?.id}">
            <g:hiddenField name="version" value="${crmBlogStatus?.version}"/>

            <f:with bean="crmBlogStatus">
                <f:field property="name" input-autofocus=""/>
                <f:field property="description"/>
                <f:field property="param"/>
                <f:field property="icon"/>
                <f:field property="orderIndex"/>
                <f:field property="enabled"/>
            </f:with>

            <div class="form-actions">
                <crm:button visual="primary" icon="icon-ok icon-white" label="crmBlogStatus.button.update.label"/>
                <crm:button action="delete" visual="danger" icon="icon-trash icon-white"
                            label="crmBlogStatus.button.delete.label"
                            confirm="crmBlogStatus.button.delete.confirm.message"
                            permission="crmBlogStatus:delete"/>
                <crm:button type="link" action="list"
                            icon="icon-remove"
                            label="crmBlogStatus.button.cancel.label"/>
            </div>
        </g:form>
    </div>

    <div class="span3">
        <crm:submenu/>
    </div>
</div>

</body>
</html>
