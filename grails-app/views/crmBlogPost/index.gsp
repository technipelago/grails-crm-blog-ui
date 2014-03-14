<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogPost.label', default: 'Blog Post')}"/>
    <title><g:message code="crmBlogPost.find.title" args="[entityName]"/></title>
    <r:require modules="datepicker"/>
    <r:script>
        $(document).ready(function () {
            <crm:datepicker/>
        });
    </r:script>
</head>

<body>

<div class="row-fluid">
    <div class="span9">

        <crm:header title="crmBlogPost.find.title" args="[entityName]"/>

        <g:form action="list">

            <div class="row-fluid">

                <f:with bean="cmd">
                    <div class="span7">
                        <div class="row-fluid">
                            <f:field property="title" label="crmBlogPost.title.label"
                                     input-class="span10" input-autofocus=""
                                     input-placeholder="${message(code: 'crmBlogQueryCommand.title.placeholder', default: '')}"/>

                            <f:field property="status" label="crmBlogPost.status.label">
                                <g:select name="status" from="${metadata.statusList}" value="${cmd.status}"
                                          optionKey="param" optionValue="name" noSelection="${['': '']}"
                                          class="span10"/>
                            </f:field>
                            <f:field property="username" label="crmBlogPost.username.label">
                                <g:select name="username" from="${metadata.userList}" value="${cmd.username}"
                                          optionKey="username" optionValue="name" noSelection="${['': '']}"
                                          class="span10"/>
                            </f:field>
                        </div>
                    </div>

                    <div class="span5">
                        <div class="row-fluid">
                            <f:field property="fromDate">
                                <div class="input-append date">
                                    <g:textField name="fromDate" class="span10" placeholder="ÅÅÅÅ-MM-DD"
                                                 value="${cmd.fromDate}"/><span
                                        class="add-on"><i class="icon-th"></i></span>
                                </div>
                            </f:field>
                            <f:field property="toDate">
                                <div class="input-append date">
                                    <g:textField name="toDate" class="span10" placeholder="ÅÅÅÅ-MM-DD"
                                                 value="${cmd.toDate}"/><span
                                        class="add-on"><i class="icon-th"></i></span>
                                </div>
                            </f:field>
                        </div>
                    </div>

                </f:with>

            </div>

            <div class="form-actions btn-toolbar">
                <crm:selectionMenu visual="primary">
                    <crm:button action="list" icon="icon-search icon-white" visual="primary"
                                label="crmBlogPost.button.search.label"/>
                </crm:selectionMenu>
                <crm:button type="link" group="true" action="create" visual="success" icon="icon-file icon-white"
                            label="crmBlogPost.button.create.label" permission="crmBlogPost:create"/>
            </div>

        </g:form>
    </div>

    <div class="span3">
        <ul class="nav nav-list">
            <li class="nav-header"><g:message code="crmBlogPost.recent.title" default="Recent Posts"/></li>
            <g:each in="${recentPosts}" var="post">
                <li><g:link action="show" id="${post.id}">${post.encodeAsHTML()}</g:link></li>
            </g:each>
        </ul>
    </div>
</div>

</body>
</html>
