<!--  /config/editConnector.jsp  -->
<%@ page errorPage="/error.jsp" %>
<%@ page import="org.jmanage.core.config.ApplicationConfig"%>
<%@ taglib uri="/WEB-INF/tags/jmanage/html.tld" prefix="jmhtml"%>
<%@ taglib uri="/WEB-INF/tags/struts/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tags/jstl/c.tld" prefix="c"%>

<script language="JavaScript">
    function showManagedApplications(){
        document.forms[0].action="/config/managedApplications.do";
        document.forms[0].submit();
    }
</script>

<!-- <jmhtml:javascript formName="connectorForm" /> -->

<jmhtml:errors />

<jmhtml:form action="/config/editConnector.do" method="post"
             onsubmit="return validateConnectorForm(this)">

<jmhtml:hidden property="type"/>

<logic:iterate id="configName" property="configNames"
               name="connectorForm"
               indexId="ctr">
    <c:if test = "${!empty configName}" >
        <jmhtml:hidden name="connectorForm"
                property='<%= "configName[" + ctr + "]" %>' />
    </c:if>
</logic:iterate>

<table class="table" border="0" cellspacing="0" cellpadding="5" width="500">
    <tr class="tableHeader">
    <td colspan="2">Add Application</td>
    </tr>
    <tr>
      <td class="headtext1">Connector:</td>
      <td class="plaintext">
        <c:out value="${requestScope.connectorForm.connectorName}" />
        <jmhtml:hidden property="connectorId" />
      </td>
    </tr>

    <tr>
      <td class="headtext1">Name:</td>
      <td><jmhtml:text property="name" size="50"/></td>
    </tr>

    <logic:iterate id="configName" property="configNames" name="connectorForm"
                   indexId="ctr">
    <c:if test = "${!empty configName}" >
    <tr>
      <td class="headtext1"><c:out value="${configName}"/></td>
      <td>
      <c:choose>
       <c:when test="${configName == 'Password' || configName == 'password'
                    || configName == 'PASSWORD'}" >
        <jmhtml:password name="connectorForm" size="50"
                property='<%= "configValue[" + ctr + "]" %>' />
       </c:when>
       <c:otherwise>
        <jmhtml:text name="connectorForm" size="50"
                property='<%= "configValue[" + ctr + "]" %>' />
       </c:otherwise>
       </c:choose>
      </td>
    </tr>
    </c:if>
    </logic:iterate>

    <tr>
        <td>&nbsp;</td>
        <td>
            <jmhtml:submit value="Save" styleClass="Inside3d"/>&nbsp;&nbsp;&nbsp;
            <jmhtml:button property="" value="Cancel"
                    onclick="showManagedApplications()"
                    styleClass="Inside3d" />
        </td>
    </tr>
  </table>
</jmhtml:form>
