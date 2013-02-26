<!--/dashboard/default.jsp-->
<%@ taglib uri="/WEB-INF/tags/jmanage/jm.tld" prefix="jm"%>
<table class="plaintext" cellspacing="5" width="800" style="border:1;border-style:solid;border-width:1px;border-color:#C0C0C0">
 <tr>
  <td>
	<div class="plaintext">
	<p>
	<jm:dashboardComponent id="com1" width="600" height="400"/>
	</p>
	<p>
	<table border="0" cellpadding="5">
	<tr>
	<td valign="top">
		<jm:dashboardComponent id="com2"/>
	</td>
	<td valign="top">
		<jm:dashboardComponent id="com3"/>
	</td>
	</tr>
	</table>
	<a href="JavaScript:history.back()">back</a>
	</p>
	</div>
  </td>
 </tr>
</table>