<!--/app/graphView.jsp-->
<%@ page errorPage="/error.jsp" %>
<%@ taglib uri="/WEB-INF/tags/jmanage/jm.tld" prefix="jm"%>

<p>
<jm:graph id='<%=request.getParameter("graphId")%>' width="600" height="500"/>
</p>
