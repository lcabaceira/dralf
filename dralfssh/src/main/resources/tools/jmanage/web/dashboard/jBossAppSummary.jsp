<!--/dashboard/jBossAppSummary.jsp-->
<%@ taglib uri="/WEB-INF/tags/jmanage/jm.tld" prefix="jm"%>
<table class="plaintext" cellspacing="5" width="800" style="border:1;border-style:solid;border-width:1px;border-color:#C0C0C0">
	<tr><td align="right"><img src="/images/dashboards/jboss.gif"/></td><td><b>Application Summary</b></td></tr>
	<tr class="tableHeader"><td colspan="2">Installation</td></tr>
    <tr><td colspan="2"><jm:dashboardComponent id="com1"/></td></tr>
    <tr><td><jm:dashboardComponent id="com2"/></td><td><jm:dashboardComponent id="com3"/></td></tr>
    <tr><td><jm:dashboardComponent id="com4"/></td><td><jm:dashboardComponent id="com5"/></td></tr>
    <tr><td><jm:dashboardComponent id="com11"/></td><td>&nbsp;</td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
	<tr class="tableHeader"><td colspan="2">Environment Info</td></tr>
    <tr><td><jm:dashboardComponent id="com6"/></td><td><jm:dashboardComponent id="com7"/></td></tr>
    <tr><td><jm:dashboardComponent id="com8"/></td><td><jm:dashboardComponent id="com9"/></td></tr>
    <tr><td><jm:dashboardComponent id="com10"/></td><td>&nbsp;</td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
	<tr class="tableHeader"><td colspan="2">Memory Usage</td></tr>
    <tr><td><jm:dashboardComponent id="com13"/></td><td><jm:dashboardComponent id="com14"/></td></tr>
	<tr><td><jm:dashboardComponent id="com12"/></td><td>&nbsp;</td></tr>
</table>