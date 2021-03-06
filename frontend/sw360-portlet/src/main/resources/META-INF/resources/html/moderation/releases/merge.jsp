<%--
  ~ Copyright Siemens AG, 2013-2019. Part of the SW360 Portal Project.
  ~
  ~ This program and the accompanying materials are made
  ~ available under the terms of the Eclipse Public License 2.0
  ~ which is available at https://www.eclipse.org/legal/epl-2.0/
  ~
  ~ SPDX-License-Identifier: EPL-2.0
  --%>
<%@include file="/html/init.jsp" %>
<%-- the following is needed by liferay to display error messages--%>
<%@include file="/html/utils/includes/errorKeyToMessage.jspf"%>

<portlet:defineObjects/>
<liferay-theme:defineObjects/>

<%@ page import="com.liferay.portal.kernel.portlet.PortletURLFactoryUtil" %>
<%@ page import="org.eclipse.sw360.datahandler.thrift.moderation.DocumentType" %>
<%@ page import="org.eclipse.sw360.portal.common.PortalConstants" %>
<%@ page import="javax.portlet.PortletRequest" %>
<%@ page import="org.eclipse.sw360.datahandler.thrift.components.ComponentType" %>

<jsp:useBean id="component" class="org.eclipse.sw360.datahandler.thrift.components.Component" scope="request"/>
<jsp:useBean id="moderationRequest" class="org.eclipse.sw360.datahandler.thrift.moderation.ModerationRequest" scope="request"/>
<jsp:useBean id="actual_release" class="org.eclipse.sw360.datahandler.thrift.components.Release" scope="request"/>
<jsp:useBean id="usingProjects" type="java.util.Set<org.eclipse.sw360.datahandler.thrift.projects.Project>" scope="request"/>
<jsp:useBean id="allUsingProjectsCount" type="java.lang.Integer" scope="request"/>

<core_rt:set var="release" value="${actual_release}" scope="request"/>
<core_rt:set var="releaseId" value="${moderationRequest.releaseAdditions.id}" scope="request"/>

<div class="container" id="moderation-request-merge" data-document-type="<%=DocumentType.RELEASE%>">

    <core_rt:if test="${empty moderationRequest.componentType}">
        <core_rt:set var="moderationTitle" value="Change ${sw360:printReleaseName(release)} (no type)" scope="request" />
    </core_rt:if>
    <core_rt:if test="${not empty moderationRequest.componentType}">
        <core_rt:set var="moderationTitle" value="Change ${sw360:printReleaseName(release)} (${sw360:enumToString(moderationRequest.componentType)})" scope="request" />
    </core_rt:if>
    <%@include file="/html/moderation/includes/moderationHeader.jspf"%>

    <div class="row">
        <div class="col">
            <div id="moderation-wizard" class="accordion">
                <div class="card">
                    <div id="moderation-header-heading" class="card-header">
                        <h2 class="mb-0">
                            <button class="btn btn-secondary btn-block" type="button" data-toggle="collapse" data-target="#moderation-header" aria-expanded="true" aria-controls="moderation-header">
                                <liferay-ui:message key="moderation.request.information" />
                            </button>
                        </h2>
                    </div>
                    <div id="moderation-header" class="collapse show" aria-labelledby="moderation-header-heading" data-parent="#moderation-wizard">
                        <div class="card-body">
                            <%@include file="/html/moderation/includes/moderationInfo.jspf"%>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div id="moderation-changes-heading" class="card-header">
                        <h2 class="mb-0">
                            <button class="btn btn-secondary btn-block" type="button" data-toggle="collapse" data-target="#moderation-changes" aria-expanded="false" aria-controls="moderation-changes">
                                <liferay-ui:message key="proposed.changes" />
                            </button>
                        </h2>
                    </div>
                    <div id="moderation-changes" class="collapse" aria-labelledby="moderation-changes-heading" data-parent="#moderation-wizard">
                        <div class="card-body">
                            <h4 class="mt-2"><liferay-ui:message key="basic.fields" /></h4>
                            <sw360:DisplayReleaseChanges
                                actual="${actual_release}"
                                additions="${moderationRequest.releaseAdditions}"
                                deletions="${moderationRequest.releaseDeletions}"
                                idPrefix="basicFields"
                                isClosedModeration="${not sw360:isOpenModerationRequest(moderationRequest)}"
                                tableClasses="table table-bordered"
                            />

                            <h4 class="mt-4"><liferay-ui:message key="attachments" /></h4>
                            <sw360:CompareAttachments
                                actual="${actual_release.attachments}"
                                additions="${moderationRequest.releaseAdditions.attachments}"
                                deletions="${moderationRequest.releaseDeletions.attachments}"
                                idPrefix="attachments"
                                isClosedModeration="${not sw360:isOpenModerationRequest(moderationRequest)}"
                                tableClasses="table table-bordered"
                                contextType="${component.type}"
                                contextId="${component.id}"/>
                        </div>
                    </div>
                </div>
                <div class="card">
                    <div id="current-document-heading" class="card-header">
                        <h2 class="mb-0">
                            <button class="btn btn-secondary btn-block" type="button" data-toggle="collapse" data-target="#current-document" aria-expanded="false" aria-controls="current-document">
                                <liferay-ui:message key="current.release" />
                            </button>
                        </h2>
                    </div>
                    <div id="current-document" class="collapse" aria-labelledby="current-document-heading" data-parent="#moderation-wizard">
                        <div class="card-body">
                            <core_rt:set var="inReleaseDetailsContext" value="false" scope="request"/>
                            <core_rt:set var="cotsMode" value="<%=component.componentType == ComponentType.COTS%>"/>
                            <%@include file="/html/utils/includes/requirejs.jspf" %>
                            <%@include file="/html/components/includes/releases/detailOverview.jspf"%>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
