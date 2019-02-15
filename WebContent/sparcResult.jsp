<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="rdf" uri="http://icts.uiowa.edu/RDFUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<jsp:include page="header.jsp" flush="true" />

	<div class="container pl-0 pr-0">
		<br/> <br/> <br/> <br/> <br/>
		<div class="container-fluid">
			<h3>MUSC SPARC Search</h3>
<sql:query var="nodes" dataSource="jdbc/RDFUtil">
        select service.name,description,abbreviation,components,organization.name as org_name from sparc_musc.service,sparc_musc.organization where service.id = ?::int and organization_id=organization.id;
        <sql:param>${param.id}</sql:param>
</sql:query>
<c:forEach items="${nodes.rows}" var="row" varStatus="rowCounter">
<h2>${row.name}</h2>
<p>${row.description}</p>
<p><b>Abbreviation: </b>${row.abbreviation}</p>
<p><b>Components: </b>${row.components}</p>
<p><b>Organization: </b>${row.org_name}</p>
</c:forEach>
		</div>
	</div>
</body>

</html>
