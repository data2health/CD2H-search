<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="../head.jsp" flush="true">
    <jsp:param name="title" value="CTSAsearch REDCap Result" />
</jsp:include>
<style type="text/css" media="all">
@import "../resources/layout.css";

.index-icon{
    text-align:center;
    color:grey;
    opacity: 0.7;
}
</style>

<body class="home page-template-default page page-id-6 CD2H">
    <jsp:include page="../header.jsp" flush="true" />

    <div class="container pl-0 pr-0">
        <br /> <br /> 
        <div class="container-fluid">
        <h3><a href="http://labs.cd2h.org:5000/graphiql">REDCap Library Instrument</a></h3>
<sql:query var="domains" dataSource="jdbc/RDFUtil">
    select instrument_title,date_added,download_count,description,acknowledgement,terms_of_use from redcap.library_instrument where id=?::int;
    <sql:param>${param.id}</sql:param>
</sql:query>

    <table>
    <c:forEach items="${domains.rows}" var="row" varStatus="rowCounter">
        <tr><th>Title</th><td>${row.instrument_title}</td></tr>
        <tr><th>Date Added</th><td>${row.date_added}</td></tr>
        <tr><th>Download Count</th><td>${row.download_count}</td></tr>
        <tr><th>Description</th><td>${row.description}</td></tr>
        <tr><th>Acknowledgement</th><td>${row.acknowledgement}</td></tr>
        <tr><th>Terms of Use</th><td>${row.terms_of_use}</td></tr>
    </c:forEach>
    </table>
        </div>
        <jsp:include page="../footer.jsp" flush="true" />
        </div>
</body>

</html>
