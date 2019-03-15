<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<%@include file="statisticsLoad.jsp"%>
<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";

.index-icon{
	text-align:center;
	color:grey;
	opacity: 0.7;
}
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<jsp:include page="header.jsp" flush="true" />

	<div class="container pl-0 pr-0">
		<br /> <br /> 
		<div class="container-fluid">

			<h2>What is CTSAsearch?</h2>
			<div style="width:80%;">
			<p>CTSAsearch is a federated search engine that targets Linked Open Data published by members
			 of the CTSA Consortium and other interested parties. Our goal is to address the information
			  needs of a variety of community members including basic scientists, informaticists, and clinicians.
			   We welcome any feedback to better design and build tools in our mission to support CTSA activities.</p>
			</div>
			<hr>
			
			<h4 style="text-align:center; font-weight:400;"><i style="color:#7bbac6;"class="fas fa-search"></i>   Tools:</h4><br>
			<div class="row justify-content-center">
  				<div class="col-sm-4">
    				<div class="card">
      					<div class="card-body">
        					<h5 class="card-title"><a href="<util:applicationRoot/>/search_home.jsp">People Search</a></h5>
        					<p>Search by keyword or UMLS concept for People and Expertise within data published by the CTSA consortium.</p>
        					<div class="index-icon"><i class="fas fa-user fa-3x"></i></div>
      					</div>
    				</div>
  				</div>
  				<div class="col-sm-4">
    				<div class="card">
      					<div class="card-body">
        					<h5 class="card-title"><a href="<util:applicationRoot/>/facetSearch.jsp">Faceted Search</a></h5>
        					<p>Search by keyword and browse our expanded data offering including a multitude of entities and data types.</p>
        					<div class="index-icon"><i class="fas fa-sitemap fa-3x"></i></div>
      					</div>
    				</div>
  				</div>
  			</div>

		</div>
		<jsp:include page="footer.jsp" flush="true" />
</body>

</html>
