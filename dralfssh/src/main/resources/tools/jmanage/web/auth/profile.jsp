<!--    /auth/profile.jsp  -->
<%@ page errorPage="/error.jsp" %>
<%@ page import="org.jmanage.webui.util.WebContext,
                 org.jmanage.core.auth.User,
                 org.jmanage.core.auth.AuthConstants"%>
<%@ taglib uri="/WEB-INF/tags/jmanage/html.tld" prefix="jmhtml"%>
<%@ taglib uri="/WEB-INF/tags/jstl/c.tld" prefix="c"%>

<table cellspacing="0" cellpadding="5" width="400" class="table">
<tr class="tableHeader">
    <td colspan="2">User Profile</td>
</tr>
<tr>
    <td width="100" class="headtext1">Username</td>
    <td class="plaintext"><c:out value="${sessionScope.authenticatedUser.name}" /></td>
</tr>
<tr>
    <td class="headtext1">Roles</td>
    <td class="plaintext"><c:out value="${sessionScope.authenticatedUser.rolesAsString}" /></td>
</tr>
</table>
<%--TODO: if condition can be removed once the bug in ChangePasswordAction is fixed --%>
<c:if test="${sessionScope.authenticatedUser.name != 'admin' && !sessionScope.authenticatedUser.externalUser}" >
<p>
<jmhtml:link href="/auth/showChangePassword.do" styleClass="a">Change Password</jmhtml:link>
</p>
</c:if>