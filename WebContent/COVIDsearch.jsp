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

ol {
    padding-inline-start: 10px;
    maring-left:0;
    padding-left:15px;
}

ul {
	padding-inline-start: 10px;
    maring-left:0;
    padding-left:25px;
}


input {
    padding-left: 7px;
    -webkit-box-sizing: border-box; 
    -moz-box-sizing: border-box;    
    box-sizing: border-box;       
}

.desc-list{
	width=45%;
	display=inline-block;
}


</style>

<body class="home page-template-default page page-id-6 CD2H">
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>

	<div class="container-fluid" style="padding-left:5%; padding-right:5%;">
		<br/> <br/> 
		<div class="col">
			<h2><i style="color:#7bbac6;"class="fas fa-search"></i>COVIDsearch</h2>
			<div id=form>
				<form method='POST' action='COVIDsearch.jsp'>
					<fieldset>
						<input class='search-box' name="query" value="${param.query}" size=50> 
						<input type=submit name=submitButton value=Go!>
						<c:if test="${not empty param.query}">
							<a class="search-reset" href="COVIDsearch.jsp" title="Reset Search"><i class="far fa-times-circle"></i></a>
						</c:if>
					</fieldset>
				</form>
			</div>
			<br/>
			<c:choose>
			<c:when test="${not empty param.query}">
				<p/>
				<c:set var="host"><util:requestingHost /></c:set>
				<util:Log line="" message="requesting host: ${host}" page="ctsaSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${param.query}"	page="ctsaSearch" level="INFO"></util:Log>
				
				<h3><c:out value="${displayString}" /></h3>
                <div style="width: 100%; float: left">
				<lucene:taxonomy taxonomyPath="/usr/local/CD2H/lucene/covidsearch_tax">
					<lucene:countFacetRequest categoryPath="Source" depth="3" />
					<lucene:countFacetRequest categoryPath="Entity" depth="3" />
					<lucene:countFacetRequest categoryPath="Unit" depth="2" />
                    <lucene:countFacetRequest categoryPath="Site" depth="3" />
					<lucene:countFacetRequest categoryPath="CTSA" />
                    <lucene:countFacetRequest categoryPath="Year" />
                    <lucene:countFacetRequest categoryPath="Learning Level" />
                    <lucene:countFacetRequest categoryPath="Assessment Method" />
                    <lucene:countFacetRequest categoryPath="Competency Domain" />
                    <lucene:countFacetRequest categoryPath="Delivery Method" />
                    <lucene:countFacetRequest categoryPath="Status" />
                    <lucene:countFacetRequest categoryPath="Phase" />
                    <lucene:countFacetRequest categoryPath="Type" />
                    <lucene:countFacetRequest categoryPath="Condition" />
                    <lucene:countFacetRequest categoryPath="CPT" depth="4" />
					
					<c:set var="drillDownList"><lucene:drillDownProcessor categoryPaths="${param.drillDown}" drillUpCategory="${param.drillUp}" drillOutCategory="${param.drillOut}" /></c:set>

					<lucene:search lucenePath="/usr/local/CD2H/lucene/covidsearch" label="content" queryParserName="biomedical" queryString="${param.query}" >
						<div style="with: 100%">
							<div id ="facet-box" style="width: 40%; padding: 0px 80px 0px 0px; float: left">
								<h5>Drill down in these results by:</h5>
								<div class='card' style="with: 100%">
								<div class="card-body" style="padding-right:30px">
								<ol class="facetList" id='top'>
									<lucene:facetIterator>
										<c:set var="facet1"><lucene:facet label="content" /></c:set>
                                        <c:set var="facetCount"><lucene:facet label="count" /></c:set>
                                        <c:if test="${facetCount > 0 }">
                                        <div class = 'facet-top-content-box'>
                                        	<c:set var="chevrontop"> 
													<c:choose>
														<c:when test="${fn:contains(drillDownList, facet1)}">
															fas fa-chevron-down 
														</c:when>
														<c:otherwise>
															fas fa-chevron-right
														</c:otherwise>
													</c:choose>
											</c:set>
											<li>
												<div class = 'facet-list-dropdown'>
													<button class="btn btn-facet" type="button" data-toggle="collapse" data-target='${"#facet-med-content-box"}${fn:replace(facet1," ", "")}' aria-expanded="false" aria-controls='${"facet-med-content-box"}${fn:replace(facet1," ", "")}'>
														<span class="fas-li"><i class="${chevrontop}"></i></span>
													</button>
												</div>
												<div class = 'facet-list-item'>
													<lucene:facet label="content"> (<lucene:facet label="count" />)
												</div>
												
												<!-- Toggles Collapse based on which facets are hot  -->
												<c:set var="position_med"> 
													<c:choose>
														<c:when test="${fn:contains(drillDownList, facet1)}">
															'collapse show' 
														</c:when>
														<c:otherwise>
															'collapse'
														</c:otherwise>
													</c:choose>
												</c:set>
												
												<div class=${position_med} id ='${"facet-med-content-box"}${fn:replace(facet1," ", "")}'>
	                                            <ol class="facetList">
														<lucene:facetIterator>
															<c:set var="facet2path">${facet1}/<lucene:facet	label="content"/></c:set>
															<c:set var="facet2"><lucene:facet label="content" /></c:set>
															<lucene:facet label="none">
															
															<c:set var="count_children">0</c:set>
															<lucene:facetIterator>
																<c:set var="count_children">${count_children + 1}</c:set>
															</lucene:facetIterator>
															
																<c:choose>
																	<c:when test="${count_children == 0 and not fn:contains(drillDownList, facet2path.concat('|')) and not fn:contains(drillDownList, facet2path)}">
																		<li>
 																			<div class = 'facet-list-dropdown'> 
 																				<button class="btn btn-facet" type="button">
																					<span class="fas-li"><i class="fas fa-minus"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'>
																				<a href='COVIDsearch.jsp?query=${fn:replace(param.query,"&","%26")}&drillDown=${drillDownList}${facet2path}'>${facet2}</a> (<lucene:facet label="count" />)
																			</div>
																	</c:when>
																	<c:when	test="${fn:contains(drillDownList, facet2path.concat('|')) and count_children ==0}">
																		<li>
 																			<div class = 'facet-list-dropdown'> 
 																				<button class="btn btn-facet" type="button">
																					<span class="fas-li"><i class="fas fa-minus"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'>
																				<lucene:facet label="content" /> <a	class="facet-move" href='COVIDsearch.jsp?query=${fn:replace(param.query,"&","%26")}&drillDown=${drillDownList}&drillUp=${facet2path}' title="Remove Filter"><i class="far fa-times-circle"></i></a>
																			</div>
																	</c:when>
																	<c:when test="${fn:contains(drillDownList, facet2path) and count_children ==0}">
																		<li>
																			<div class = 'facet-list-dropdown'>
																				<button class="btn btn-facet" type="button">
																					<span class="fas-li"><i class="fas fa-minus"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'>
																				<lucene:facet label="content" />
																			</div>
																	</c:when>
																	<c:when	test="${fn:contains(drillDownList, facet2path.concat('|'))}">
																		<li>
 																			<div class = 'facet-list-dropdown'> 
 																				<button class="btn btn-facet" type="button" data-toggle="collapse" data-target='${"#facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}' aria-expanded="false" aria-controls='${"facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}'>
																					<span class="fas-li"><i class="fas fa-chevron-down"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'>
																				<lucene:facet label="content" /> <a	class="facet-move" href='COVIDsearch.jsp?query=${fn:replace(param.query,"&","%26")}&drillDown=${drillDownList}&drillUp=${facet2path}' title="Remove Filter"><i class="far fa-times-circle"></i></a>
																			</div>
																	</c:when>
																	<c:when test="${fn:contains(drillDownList, facet2path)}">
																		<li>
																			<div class = 'facet-list-dropdown'>
																				<button class="btn btn-facet" type="button" data-toggle="collapse" data-target='${"#facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}' aria-expanded="false" aria-controls='${"facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}'>
																					<span class="fas-li"><i class="fas fa-chevron-down"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'>
																				<lucene:facet label="content" />
																			</div>
																	</c:when>
																	<c:otherwise>
																		<li>
																			<div class = 'facet-list-dropdown'>
																				<button class="btn btn-facet" type="button" data-toggle="collapse" data-target='${"#facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}' aria-expanded="false" aria-controls='${"facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}'>
																					<span class="fas-li"><i class="fas fa-chevron-right"></i></span>
																				</button>
																			</div>
																			<div class = 'facet-list-item'> 
																				<a href='COVIDsearch.jsp?query=${fn:replace(param.query,"&","%26")}&drillDown=${drillDownList}${facet2path}'>${facet2}</a> (<lucene:facet label="count" />)
																			</div>
																	</c:otherwise>
																</c:choose>
															
															
																<!-- Toggles Collapse based on which facets are hot  -->
																	<c:set var="position_low"> 
																		<c:choose>
																			<c:when test="${fn:contains(drillDownList, facet2)}">
																				'collapse show' 
																			</c:when>
																			<c:otherwise>
																				'collapse'
																			</c:otherwise>
																		</c:choose>
																	</c:set>
																	<div class=${position_low} id ='${"facet-low-content-box"}${facet2.replaceAll("[\\W]+", "")}'>
																	<ul class="innerFacetList">
																		<lucene:facetIterator>
																			<c:set var="facet3path">${facet2path}/<lucene:facet	label="content" /></c:set>
																			<c:set var="facet3"><lucene:facet label="content" /></c:set>
																			<lucene:facet label="none">
																				<c:choose>
																					<c:when	test="${fn:contains(drillDownList, facet3path.concat('|'))}">
																						<li><lucene:facet label="content" />
																						<a	class='facet-move' href="COVIDsearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillOut=${facet3path}" title="Remove This Filter"><i class="far fa-arrow-alt-circle-left"></i></a>
				                                                                      	<a  class='facet-move' href="COVIDsearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet3path}" title="Remove All Filters in Category"><i class="far fa-times-circle"></i></a>
		        																	</c:when>
																					<c:when	test="${fn:contains(drillDownList, facet3path)}">
																						<li><lucene:facet label="content" />
																					</c:when>
																					<c:otherwise>
																						<li><a	href="COVIDsearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet3path}">${facet3}</a> (<lucene:facet label="count" />)
																					</c:otherwise>
																				</c:choose></li>
												                              </lucene:facet>
											                           </lucene:facetIterator>
										                            </ul>
										                            </div>
									                            </li>
									                        </lucene:facet>
									                    </lucene:facetIterator>
									                </ol>
									                </div>
									                    </lucene:facet>
									                </li>
									    </div>
                                        </c:if>
								        </lucene:facetIterator>
								</ol>
								</div>
								</div>
							</div>
							<div id="results-box">
								<div id="results-header-box">
									<h3 id="results-header">Search Results:</h3>
									<c:set var="count"><lucene:count/></c:set>
									<p>Result Count: <lucene:count /><c:if test="${count >=1000}">+ (search results currently limited to 1000)</c:if></p>
								</div>
								<div id="results-table" onscroll="scrollFunction()">
									<table style="width:100%">
	  									<tr>
	    									<th>Result</th>
	    									<th>Source</th> 
	  									</tr>
										<lucene:searchIterator>
											<tr>
												<td><a href="<lucene:hit label="uri" />" target="_parent"><lucene:hit label="label" /></a></td>
												<td> <lucene:hit label="source" /></td>
											<tr>
										</lucene:searchIterator>
									</table>
								</div>
								<div id="results-scroll" style="text-align:right;">
									<button id="backtop" title="Back to Top"><i class="fas fa-chevron-up"></i></button>
								</div>
							</div>
						</div>
					</lucene:search>
				</lucene:taxonomy>
                </div>
			</c:when>
			<c:otherwise>
			<div class="container-fluid">
			<hr>
			<h4 style="text-align:center; font-weight:400;"><i style="color:#6ba097;"class="fas fa-database"></i>   Sources and Entity Types:</h4><br>
			<div class="row">
 <sql:query var="sources" dataSource="jdbc/COVID">
    select source,description,to_char(last_update, 'YYYY-MM-DD HH:MI') as updated,count from covid.stats order by last_update desc;
</sql:query>
   <c:forEach items="${sources.rows}" var="row" varStatus="rowCounter">
   				<div class="col-sm-3">
    				<div class="card">
      					<div class="card-body">
        					<h5 class="card-title">${row.description}</h5>
        					<ul class="list-group">
									<li>Last Updated: ${row.updated}</li>
									<li>Entries: ${row.count}</li>
							</ul>
      					</div>
    				</div>
  				</div>
   </c:forEach>
</div>
  			<br/>
  			<h5>Embedding</h5>
  			<p>Feel free to embed COVIDsearch into your local environment using the following:</p>
  			<code>&lt;iframe src="https://labs.cd2h.org/search/COVIDsearch.jsp" /&gt;</code>
		</div>
	</div>
				
			
			</c:otherwise>
			</c:choose>
		</div>
	</div>

<script>
$('#backtop').on('click', function() {
	$('#results-table').scrollTop(0);
});


function scrollFunction() {
	  if ($('#results-table').scrollTop() < 1000) {
	    document.getElementById("backtop").style.opacity = 0;
	  } else {
	    document.getElementById("backtop").style.opacity = 0.8;
	  }
};


$('.collapse').on('show.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-down');
});

$('.collapse').on('hide.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-right');
});

$('.collapse').on('shown.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-down');
    if ($("#facet-box").height() > $(window).width()*.3){
    	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
    } else {
    	$("#results-table").css({'height':($(window).width()*.3+'px')});
    };
    
});

$('.collapse').on('hidden.bs.collapse', function(e) {
    $(e.target).siblings('.facet-list-dropdown').find('i').removeClass().addClass('fas fa-chevron-right');
    if ($("#facet-box").height() > $(window).width()*.3){
    	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
    } else {
    	$("#results-table").css({'height':($(window).width()*.3+'px')});
    };
});


if ($("#facet-box").height() > $(window).width()*.3){
	$("#results-table").css({'height':($("#facet-box").height()-$("#results-header-box").height()+'px')});
} else {
	$("#results-table").css({'height':($(window).width()*.3+'px')});
};

</script>
</body>

</html>
