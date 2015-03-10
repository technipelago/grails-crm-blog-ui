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
            var stylesheet = ["${resource(dir: 'less', file: 'bootstrap.less.css', plugin: 'twitter-bootstrap')}",
            "${resource(dir: 'less', file: 'crm-ui-bootstrap.less.css', plugin: 'crm-ui-bootstrap')}",
            "${resource(dir: 'less', file: 'responsive.less.css', plugin: 'twitter-bootstrap')}"];
            <% if (css) { %>
            stylesheet.push("${resource(css)}");
            <% } %>
            var editor = CKEDITOR.replace('content',
            {
                customConfig: "${resource(dir: 'js', file: 'crm-ckeditor-config.js', plugin: 'crm-content-ui')}",
                stylesSet: "crm-web-styles:${resource(dir: 'js', file: 'crm-ckeditor-styles.js', plugin: 'crm-content-ui')}",
                baseHref: "${createLink(controller: 'static')}",
                contentsCss: stylesheet
            });

            $('#visibleFrom').closest('.date').datepicker({
                    weekStart:1,
                    language: "${(org.springframework.web.servlet.support.RequestContextUtils.getLocale(request) ?: new Locale('sv_SE')).getLanguage()}",
                    calendarWeeks: ${grailsApplication.config.crm.datepicker.calendarWeeks ?: false},
                    todayHighlight: true,
                    autoclose: true
                }).on('changeDate', function (ev) {
                alignDates($("#visibleFrom"), $("#visibleTo"), false, ".date");
            });
            $("#visibleFrom").blur(function (ev) {
                alignDates($(this), $("#visibleTo"), false, ".date");
            });
            $('#visibleTo').closest('.date').datepicker({
                    weekStart:1,
                    language: "${(org.springframework.web.servlet.support.RequestContextUtils.getLocale(request) ?: new Locale('sv_SE')).getLanguage()}",
                    calendarWeeks: ${grailsApplication.config.crm.datepicker.calendarWeeks ?: false},
                    todayHighlight: true,
                    autoclose: true
                }).on('changeDate', function (ev) {
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
                            <g:select from="${metadata.statusList}" name="status.id" optionKey="id"
                                      value="${crmBlogPost.status?.id}"/>
                        </f:field>

                        <div class="control-group">
                            <label class="control-label"><g:message code="crmBlogPost.visibleFrom.label"/></label>
                            <div class="controls">
                                <span class="input-append date"
                                      data-date="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleFrom ?: new Date())}">
                                    <g:textField name="visibleFrom" class="span10" size="10"
                                                 placeholder="ÅÅÅÅ-MM-DD"
                                                 value="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleFrom)}"/><span
                                        class="add-on"><i class="icon-th"></i></span>
                                </span>
                            </div>
                        </div>

                        <div class="control-group">
                            <label class="control-label"><g:message code="crmBlogPost.visibleTo.label"/></label>
                            <div class="controls">
                                <span class="input-append date"
                                      data-date="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleTo ?: new Date())}">
                                    <g:textField name="visibleTo" class="span10" size="10"
                                                 placeholder="ÅÅÅÅ-MM-DD"
                                                 value="${formatDate(format: 'yyyy-MM-dd', date: crmBlogPost.visibleTo)}"/><span
                                        class="add-on"><i class="icon-th"></i></span>
                                </span>
                            </div>
                        </div>

                        <f:field property="username">
                            <g:select name="username" from="${metadata.userList}" optionKey="username" optionValue="name"
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
        <crm:button action="create" visual="success" icon="icon-ok icon-white" label="crmBlogPost.button.save.label"/>
        <crm:button type="link" action="index" icon="icon-remove" label="crmBlogPost.button.back.label"/>
    </div>

</g:form>

</body>
</html>