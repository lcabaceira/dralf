<!--- /app/ClusterView.jsp -->
<%@ page errorPage="/error.jsp" %>
<%@ page import="org.jmanage.webui.util.WebContext,
                 org.jmanage.core.config.ApplicationClusterConfig,
                 java.util.List,
                 java.util.Iterator,
                 org.jmanage.core.config.ApplicationConfig,
                 org.jmanage.core.config.MBeanConfig,
                 org.jmanage.webui.util.RequestParams,
                 java.net.URLEncoder,
                 org.jmanage.webui.view.ApplicationViewHelper"%>
<%
    WebContext context = WebContext.get(request);
    ApplicationClusterConfig clusterConfig =
            (ApplicationClusterConfig)context.getApplicationConfig();
%>
<table border="0" cellspacing="0" cellpadding="5" width="600" class="table">
    <tr class="tableHeader">
        <td colspan="2">Applications</td>
    </tr>
<%
    List childApplications = clusterConfig.getApplications();
    for(Iterator it=childApplications.iterator(); it.hasNext();){
        ApplicationConfig appConfig = (ApplicationConfig)it.next();
%>
    <tr>
        <td class="plaintext" width="25%">
          <%if(ApplicationViewHelper.isApplicationUp(appConfig)) {%>        
	        <img src="/images/bullet/green.gif"/>
	      <%}else{ %>
	      	<img src="/images/bullet/red.gif"/>
	      <%} %>&nbsp;<a href="/app/appView.do?applicationId=<%=appConfig.getApplicationId()%>">
                    <%=appConfig.getName()%></a>
        </td>
        <td class="plaintext">
            <%=appConfig.getURL()%>
        </td>
    </tr>
<%
    }
%>
</table>
<br/><br/>
<%if(clusterConfig.getMBeans().size() > 0){%>
<table border="0" cellspacing="0" cellpadding="5" width="600" class="table">
    <tr class="tableHeader">
        <td colspan="2">Managed Objects</td>
    </tr>
<%
    List mbeans = clusterConfig.getMBeans();
    for(Iterator it=mbeans.iterator(); it.hasNext();){
        MBeanConfig mbeanConfig = (MBeanConfig)it.next();
%>
    <tr>
        <td class="plaintext" width="25%">
            <a href="/app/mbeanView.do?<%=RequestParams.APPLICATION_ID%>=<%=clusterConfig.getApplicationId()%>&<%=RequestParams.OBJECT_NAME%>=<%=URLEncoder.encode(mbeanConfig.getObjectName(), "UTF-8")%>">
                    <%=mbeanConfig.getName()%></a>
        </td>
        <td class="plaintext">
            <%=mbeanConfig.getObjectName()%>
        </td>
    </tr>
<%
    }
%>
</table>
<%}%>