<%@ taglib uri="/WEB-INF/tags/jmanage/html.tld" prefix="jmhtml"%>

<%
    User user = WebContext.get(request).getUser();
%>

<%@page import="org.jmanage.webui.view.UserViewHelper,
				org.jmanage.webui.util.WebContext,
                org.jmanage.core.auth.User"%>
<table width="900" border="0" cellspacing="0" cellpadding="0" bgcolor="#e8b120">
  <tr>
    <td><jmhtml:img src="/images/logoNew.gif" width="150" height="48" /></td>
    <td align="right" valign="bottom" class="plaintext">
        <%if(user != null){%>
        <div style="margin-right:3px;margin-bottom:3px">
        <a class="nav0" href="/config/managedApplications.do">Home</a>&nbsp;|&nbsp;
        <a class="nav0" href="/auth/profile.do">Profile</a>&nbsp;|&nbsp;
		<%if(UserViewHelper.hasAdminAccess(request)){ %>
        	<a class="nav0" href="/config/admin.do">Admin</a>&nbsp;|&nbsp;
		<%}%>
        <a class="nav0" href="/auth/logout.do">Logout</a>&nbsp;|&nbsp;
        Logged-in as <b><%=user.getName()%></b>
        </div>
        <%}else{%>
            &nbsp;
        <%}%>
    </td>
  </tr>
</table>
