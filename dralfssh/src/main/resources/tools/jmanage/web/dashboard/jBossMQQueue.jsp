<!--/dashboard/jBossMQQueue.jsp-->
<%@ taglib uri="/WEB-INF/tags/jmanage/jm.tld" prefix="jm"%>
<table class="plaintext" cellspacing="5" width="800" style="border:1;border-style:solid;border-width:1px;border-color:#C0C0C0">
	<tr><td align="right"><img src="/images/dashboards/jboss.gif"/></td><td><b>Server MQ stats</b></td></tr>
	<tr class="tableHeader"><td colspan="2">Queue statistics</td></tr>
    <tr><td colspan="2"><jm:dashboardComponent id="com1"/></td></tr>
	<tr class="tableHeader"><td colspan="2">Topic statistics</td></tr>
    <tr><td colspan="2"><jm:dashboardComponent id="com2"/></td></tr>
</table>