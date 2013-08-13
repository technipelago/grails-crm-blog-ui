<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogPost.label', default: 'Blog Post')}"/>
    <title><g:message code="crmBlogPost.create.title" args="[entityName, crmBlogPost]"/></title>
    <r:require modules="datepicker,autocomplete,aligndates"/>
    <ckeditor:resources/>
    <r:script>
        $(document).ready(function () {
            var editor = CKEDITOR.replace('content',
                {
                    width: '98.3%',
                    height: '480px',
                    resize_enabled: true,
                    startupFocus: true,
                    skin: 'kama',
                    toolbar: [
                        ['Styles', 'Format', 'Font', 'FontSize'],
                        ['Source'],
                        '/',
                        ['Bold', 'Italic', 'Underline', 'Strike', 'TextColor', 'BGColor', 'RemoveFormat'],
                        ['Paste', 'PasteText', 'PasteFromWord'],
                        ['JustifyLeft', 'JustifyCenter', 'JustifyRight'],
                        ['NumberedList', 'BulletedList', '-', 'Outdent', 'Indent'],
                        ['Link', 'Unlink'], /* Image upload is not available until document is created */
                        ['Table', 'HorizontalRule']
                    ],
                    basicEntities: false,
                    protectedSource: [/\[@link\s+[\s\S]*?\[\/@link\]/g, /\[#[\s\S]*?\]/g],
                    baseHref: "${createLink(controller: 'static')}"
                });

            $('#visibleFrom').closest('.date').datepicker({weekStart: 1}).on('changeDate', function (ev) {
                alignDates($("#visibleFrom"), $("#visibleTo"), false, ".date");
            });
            $("#visibleFrom").blur(function (ev) {
                alignDates($(this), $("#visibleTo"), false, ".date");
            });
            $('#visibleTo').closest('.date').datepicker({weekStart: 1}).on('changeDate', function (ev) {
                alignDates($("#visibleTo"), $("#visibleFrom"), true, ".date");
            });
            $("#visibleTo").blur(function (ev) {
                alignDates($(this), $("#visibleFrom"), true, ".date");
            });
        });
    </r:script>
</head>

<body>

<crm:header title="crmBlogPost.create.title" args="[entityName, crmBlogPost]"/>

<g:hasErrors bean="${crmBlogPost}">
    <crm:alert class="alert-error">
        <ul>
            <g:eachError bean="${crmBlogPost}" var="error">
                <li <g:if test="${error in org.springframework.validation.FieldError}">data-field-id="${error.field}"</g:if>><g:message
                        error="${error}"/></li>
            </g:eachError>
        </ul>
    </crm:alert>
</g:hasErrors>


<ul class="nav nav-tabs">
    <li class="active"><a href="#main" data-toggle="tab"><g:message code="crmBlogPost.tab.layout.label"/></a>
    </li>
    <crm:pluginViews location="tabs" var="view">
        <crm:pluginTab id="${view.id}" label="${view.label}" count="${view.model?.totalCount}"/>
    </crm:pluginViews>
</ul>


<g:form action="create">
    <g:hiddenField name="id" value="${crmBlogPost.id}"/>
    <g:hiddenField name="version" value="${crmBlogPost.version}"/>

    <div class="tab-content">

        <div class="tab-pane active" id="main">
            <div class="row-fluid">
                <div class="span9">
                    <div class="row-fluid">
                        <g:textArea id="content" name="text" cols="70" rows="18" class="span11"
                                    value="${template?.text}"/>
                    </div>
                </div>

                <div class="span3">
                    <f:with bean="${crmBlogPost}">
                        <f:field property="title"/>
                        <f:field property="description" input-rows="6"/>
                        <f:field property="status">
                            <g:select from="${statusList}" name="status.id" optionKey="id"
                                      value="${crmBlogPost.status?.id}"/>
                        </f:field>
                        <f:field property="visibleFrom">
                            <span class="input-append date"
                                  data-date="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleFrom ?: new Date())}">
                                <g:textField name="visibleFrom" class="span10" size="10"
                                             placeholder="ÅÅÅÅ-MM-DD"
                                             value="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleFrom)}"/><span
                                    class="add-on"><i class="icon-th"></i></span>
                            </span>
                        <%--
                                                    <g:select name="startTime" from="${timeList}"
                                                              value="${formatDate(format: 'HH:mm', date: crmCampaign.startTime)}"
                                                              class="span4"/>
                        --%>
                        </f:field>
                        <f:field property="visibleTo">
                            <span class="input-append date"
                                  data-date="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleTo ?: new Date())}">
                                <g:textField name="visibleTo" class="span10" size="10"
                                             placeholder="ÅÅÅÅ-MM-DD"
                                             value="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleTo)}"/><span
                                    class="add-on"><i class="icon-th"></i></span>
                            </span>
                        <%--
                                                    <g:select name="startTime" from="${timeList}"
                                                              value="${formatDate(format: 'HH:mm', date: crmCampaign.startTime)}"
                                                              class="span4"/>
                        --%>
                        </f:field>
                        <f:field property="username">
                            <g:select name="username" from="${userList}" optionKey="username" optionValue="name"
                                      value="${crmBlogPost.username}" noSelection="['':'']"/>
                        </f:field>
                        <f:field property="parser">
                            <g:select from="${['raw', 'freemarker', 'gsp']}" name="parser" value="${crmBlogPost.parser}"
                                      valueMessagePrefix="crmContent.parser"/>
                        </f:field>
                    </f:with>
                </div>
            </div>
        </div>

    </div>

    <div class="form-actions">
        <crm:button action="create" visual="primary" icon="icon-ok icon-white" label="crmBlogPost.button.save.label"/>
    </div>

</g:form>

</body>
</html>