<!DOCTYPE html>
<html>
<head>
    <meta name="layout" content="main">
    <g:set var="entityName" value="${message(code: 'crmBlogPost.label', default: 'Blog Post')}"/>
    <title><g:message code="crmBlogPost.show.title" args="[entityName, crmBlogPost]"/></title>
</head>

<body>

<div class="row-fluid">
    <div class="span9">

        <crm:header title="crmBlogPost.show.title" subtitle="${crmBlogPost.status}" args="[entityName, crmBlogPost]"/>

        <div class="tabbable">
            <ul class="nav nav-tabs">
                <li class="active"><a href="#main" data-toggle="tab"><g:message
                        code="crmBlogPost.tab.layout.label"/></a>
                </li>
                <crm:pluginViews location="tabs" var="view">
                    <crm:pluginTab id="${view.id}" label="${view.label}" count="${view.model?.totalCount}"/>
                </crm:pluginViews>
            </ul>

            <div class="tab-content">

                <div class="tab-pane active" id="main">
                    <div class="clearfix">
                        <g:if test="${template}">
                            <crm:render template="${template}" parser="${crmBlogPost.parser}"
                                        authorized="true" model="${crmBlogPost.dao}"/>
                        </g:if>
                        <g:else>
                            No content!
                        </g:else>
                    </div>


                    <div class="form-actions">
                        <g:form>
                            <g:hiddenField name="id" value="${crmBlogPost?.id}"/>

                            <crm:selectionMenu location="crmBlogPost" visual="primary">
                                <crm:button type="link" controller="crmBlogPost" action="index"
                                            visual="primary" icon="icon-search icon-white"
                                            label="crmBlogPost.button.find.label"/>
                            </crm:selectionMenu>

                            <crm:button type="link" action="edit" id="${crmBlogPost?.id}" visual="warning"
                                        icon="icon-pencil icon-white"
                                        label="crmBlogPost.button.edit.label" permission="crmBlogPost:edit">
                            </crm:button>

                            <crm:button type="link" action="create"
                                        visual="success"
                                        icon="icon-file icon-white"
                                        label="crmBlogPost.button.create.label"
                                        title="crmBlogPost.button.create.help"
                                        permission="crmBlogPost:create"/>
                        </g:form>
                    </div>
                </div>

                <crm:pluginViews location="tabs" var="view">
                    <div class="tab-pane tab-${view.id}" id="${view.id}">
                        <g:render template="${view.template}" model="${view.model}" plugin="${view.plugin}"/>
                    </div>
                </crm:pluginViews>
            </div>

        </div>

    </div>

    <div class="span3">

        <g:render template="/tags" plugin="crm-tags" model="${[bean: crmBlogPost]}"/>

        <div class="well well-small">
            <dl>
                <g:if test="${crmBlogPost.title}">
                    <dt><g:message code="crmBlogPost.title.label" default="Title"/></dt>
                    <dd><g:fieldValue bean="${crmBlogPost}" field="title"/></dd>
                </g:if>
                <g:if test="${crmBlogPost.description}">
                    <dt><g:message code="crmBlogPost.description.label" default="Description"/></dt>
                    <dd><g:decorate encode="HTML">${crmBlogPost.description}</g:decorate></dd>
                </g:if>
                <g:if test="${crmBlogPost?.status}">
                    <dt><g:message code="crmBlogPost.status.label" default="Status"/></dt>
                    <dd><g:fieldValue bean="${crmBlogPost}" field="status"/></dd>
                </g:if>
                <g:if test="${crmBlogPost.date}">
                    <dt><g:message code="crmBlogPost.date.label" default="Date"/></dt>
                    <dd class="nowrap"><g:formatDate date="${crmBlogPost.date}"
                                                     format="EEE d MMMM yyyy"/></dd>
                </g:if>
                <g:if test="${crmBlogPost.visibleFrom && crmBlogPost.visibleTo}">
                    <dt><g:message code="crmBlogPost.visible.label" default="Visible"/></dt>
                    <dd>
                        <span class="nowrap">
                            <g:formatDate date="${crmBlogPost.visibleFrom}" format="d MMM yyyy"/>
                        </span>
                        -
                        <span class="nowrap">
                            <g:formatDate date="${crmBlogPost.visibleTo}" format="d MMM yyyy"/>
                        </span>
                    </dd>
                </g:if>
                <g:else>
                    <g:if test="${crmBlogPost.visibleFrom}">
                        <dt><g:message code="crmBlogPost.visibleFrom.label" default="Visible From"/></dt>
                        <dd class="nowrap"><g:formatDate date="${crmBlogPost.visibleFrom}"
                                                         format="d MMMM yyyy"/></dd>
                    </g:if>
                    <g:if test="${crmBlogPost.visibleTo}">
                        <dt><g:message code="crmBlogPost.visibleTo.label" default="Visible To"/></dt>
                        <dd class="nowrap"><g:formatDate date="${crmBlogPost.visibleTo}"
                                                         format="d MMMM yyyy"/></dd>
                    </g:if>
                </g:else>
                <g:if test="${crmBlogPost.username}">
                    <dt><g:message code="crmBlogPost.username.label" default="Author"/></dt>
                    <dd><crm:user username="${crmBlogPost.username}">${name}</crm:user></dd>
                </g:if>
            </dl>
        </div>
    </div>
</div>

</body>
</html>
