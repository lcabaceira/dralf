<!--/dashboard/oraclePerformance.jsp-->
<%@ taglib uri="/WEB-INF/tags/jmanage/jm.tld" prefix="jm"%>

<table class="plaintext" cellspacing="5" width="900" style="border:1;border-style:solid;border-width:1px;border-color:#C0C0C0">
    <tr><td colspan="2" align="center"><b><u>Performance Summary</u></b></td></tr>
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr>
    	<td align="center"><b>Dictionary Hit Ratio</b> <jm:dashboardComponent id="dictionaryHitRatio"/></td>
    	<td align="center"><b>Block Buffer Hit Ratio</b> <jm:dashboardComponent id="blockBufferHitRatio"/></td>
    </tr>
    <tr>
    	<td align="center"><b>Pin Hit Ratio</b> <jm:dashboardComponent id="sharedSQLPinHitRatio"/></td>
    	<td align="center"><b>Reload Hit Ratio</b> <jm:dashboardComponent id="sharedSQLReloadHitRatio"/></td>
    </tr>
    <tr><td colspan="2">&nbsp;</td></tr>
</table>
