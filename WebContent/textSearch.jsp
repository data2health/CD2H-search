<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="rdf" uri="http://icts.uiowa.edu/RDFUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@include file="statisticsLoad.jsp"%>

<!DOCTYPE html>
<html lang="en-US">
<jsp:include page="head.jsp" flush="true">
	<jsp:param name="title" value="CTSAsearch" />
</jsp:include>
<style type="text/css" media="all">
@import "resources/layout.css";
</style>

<body class="home page-template-default page page-id-6 CD2H">
	<script type="text/javascript">
		var pressed = false;

		function alterAction() {
			if (pressed)
				document.queryForm.action = 'ctsaCommunityMap.jsp';
			else
				document.queryForm.action = 'ctsaSearch.jsp';
			return true;
		}
	</script>
	<jsp:include page="header.jsp" flush="true" />

	<div class="container pl-0 pr-0">
    <br/>
    <br/>
    <br/>
    <br/>
	<br/>
		<div class="container-fluid">
			<h2>Search for Investigators at ${count_institutions}
				Institutions</h2>
			<c:choose>
				<c:when test="${param.mode == 'text'}">
					<c:set var="mode" value="text" />
				</c:when>
				<c:otherwise>
					<c:set var="mode" value="concept" />
				</c:otherwise>
			</c:choose>
			<div id=form>
				<form method='POST' action='textSearch.jsp'>
					<table>
						<tr>
							<td><fieldset>
									<legend>Handling of query terms?</legend>
									<input type="radio" name="mode" value="text"
										<c:if test="${mode == 'text'}">checked</c:if>> Text
									only<br> <input type="radio" name="mode" value="concept"
										<c:if test="${mode == 'concept'}">checked</c:if>> UMLS
									concepts (including support for boolean search using &amp;, |,
									and !)<br>
								</fieldset></td>
						</tr>
						<tr>
							<td><fieldset>
									<legend>Query?</legend>
									<input name="query" value="${param.query}" size=50> <input
										type=submit name=submitButton value=Search>
								</fieldset></td>
						</tr>
					</table>
				</form>
			</div>
			<br />
			<c:if test="${not empty param.query}">
				<c:choose>
					<c:when test="${param.mode == 'mixed'}">
						<h3>UMLS concepts recognized in your query:</h3>
						<c:set var="queryString" value="${param.query}" />
						<c:set var="displayString" value="${param.query}" />
						<ol class="bulletedList">
							<rdf:foreachConcept var="x" queryString="${param.query}">
								<rdf:concept>
									<li><a href="textSearch.jsp?query=<rdf:conceptCUI/>"><rdf:conceptCUI /></a>
										- <rdf:conceptPhrase /> <c:set var="cui" scope="request">
											<rdf:conceptCUI />
										</c:set> <c:set var="queryString" value="${queryString} ${cui}" /> <c:set
											var="displayString" value="${displayString} ${cui}" />
										<ol class="bulletedList">
											<rdf:foreachSubconcept var="y">
												<c:set var="subcui" scope="request">
													<rdf:subconceptCUI />
												</c:set>
												<c:set var="queryString" value="${queryString} ${subcui}" />
											</rdf:foreachSubconcept>
										</ol>
								</rdf:concept>
							</rdf:foreachConcept>
						</ol>
					</c:when>
					<c:when test="${param.mode == 'concept'}">
						<c:set var="tempDrill" value=""/>
						<c:if test="${not empty param.drillDown}">
							<c:set var="tempDrill" value="&drillDown=${param.drillDown}"/>
						</c:if>
						<c:if test="${not empty param.drillUp}">
							<c:set var="tempDrill" value="${param.tempDrill}&drillUp=${param.drillDown}"/>
						</c:if>
						<c:if test="${not empty param.drillOut}">
							<c:set var="tempDrill" value="${param.tempDrill}&drillUp=${param.drillOut}"/>
						</c:if>
						<jsp:include page="conceptHierarchy.jsp" flush="true">
							<jsp:param name="target_page" value="textSearch.jsp" />
							<jsp:param name="drilling" value="${tempDrill}" />
						</jsp:include>
					</c:when>
					<c:otherwise>
						<c:set var="queryString" value="${param.query}" />
						<c:set var="displayString" value="${param.query}" />
					</c:otherwise>
				</c:choose>
				<c:url var="encodedURL" value="visualSearch.jsp">
					<c:param name="mode" value="${param.mode}" />
					<c:param name="query" value="${param.query}" />
					<c:param name="detectionAlg" value="site" />
				</c:url>
				<h3>
					<a href="${encodedURL}">Graph view of this query</a>
				</h3>
				<p />
				<c:set var="host">
					<util:requestingHost />
				</c:set>
				<util:Log line="" message="requesting host: ${host}"
					page="ctsaSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${displayString}"
					page="ctsaSearch" level="INFO"></util:Log>
				<h3>
					Search Results:
					<c:out value="${displayString}" />
				</h3>
				<!-- Query string: <c:out value="${queryString}"/> -->

				<lucene:taxonomy taxonomyPath="/usr/local/RAID/CTSAsearch/lucene/ctsasearch_tax">
					<lucene:countFacetRequest categoryPath="Unit" depth="2" />
                    <lucene:countFacetRequest categoryPath="Site" depth="3" />
					<lucene:countFacetRequest categoryPath="CTSA" />
					
					<c:set var="drillDownList"><lucene:drillDownProcessor categoryPaths="${param.drillDown}" drillUpCategory="${param.drillUp}" drillOutCategory="${param.drillOut}" /></c:set>

					<lucene:search lucenePath="/usr/local/RAID/CTSAsearch/lucene/ctsasearch" label="content" queryParserName="boolean" queryString="${queryString}" useConjunctionByDefault="true">
						<div style="with: 100%">
							<div style="width: 40%; padding: 0px 120px 0px 0px; float: left">
								<h5>Facets:</h5>
								<ol class="bulletedList">
									<lucene:facetIterator>
										<c:set var="facet1"><lucene:facet label="content" /></c:set>
                                        <c:set var="facetCount"><lucene:facet label="count" /></c:set>
                                        <c:if test="${facetCount > 0 }">
										<li><lucene:facet label="content"> (<lucene:facet label="count" />)
                                            <ol class="bulletedList">
													<lucene:facetIterator>
														<c:set var="facet2path">${facet1}/<lucene:facet	label="content" /></c:set>
														<c:set var="facet2"><lucene:facet label="content" /></c:set>
														<lucene:facet label="none">
															<c:choose>
																<c:when	test="${fn:contains(drillDownList, facet2path.concat('|'))}">
																	<li><lucene:facet label="content" /> <a	href="textSearch.jsp?mode=${param.mode}&query=${param.query}&drillDown=${drillDownList}&drillUp=${facet2path}">x</a>
																</c:when>
																<c:when test="${fn:contains(drillDownList, facet2path)}">
																	<li><lucene:facet label="content" />
																</c:when>
																<c:otherwise>
																	<li><a href="textSearch.jsp?mode=${param.mode}&query=${param.query}&drillDown=${drillDownList}${facet2path}">${facet2}</a> (<lucene:facet label="count" />)
																</c:otherwise>
															</c:choose>
															<ol class="bulletedList">
																<lucene:facetIterator>
																	<c:set var="facet3path">${facet2path}/<lucene:facet	label="content" /></c:set>
																	<c:set var="facet3"><lucene:facet label="content" /></c:set>
																	<lucene:facet label="none">
																		<c:choose>
																			<c:when	test="${fn:contains(drillDownList, facet3path.concat('|'))}">
																				<li><lucene:facet label="content" />
																				<a	href="textSearch.jsp?mode=${param.mode}&query=${param.query}&drillDown=${drillDownList}&drillOut=${facet3path}">&larr;</a>
		                                                                      <a  href="textSearch.jsp?mode=${param.mode}&query=${param.query}&drillDown=${drillDownList}&drillUp=${facet3path}">x</a>
        																	</c:when>
																			<c:when	test="${fn:contains(drillDownList, facet3path)}">
																				<li><lucene:facet label="content" />
																			</c:when>
																			<c:otherwise>
																				<li><a	href="textSearch.jsp?mode=${param.mode}&query=${param.query}&drillDown=${drillDownList}${facet3path}">${facet3}</a> (<lucene:facet label="count" />)
																			</c:otherwise>
																		</c:choose></li>
										                              </lucene:facet>
									                           </lucene:facetIterator>
								                            </ol>
								                            </li>
								                        </lucene:facet>
								                    </lucene:facetIterator>
								                </ol>
								                    </lucene:facet>
								                </li>
                                        </c:if>
								        </lucene:facetIterator>
								</ol>
							</div>
							<div style="width: 60%; float: left">
								<p>Result Count: <lucene:count /></p>
								<ol class="bulletedList">
									<lucene:searchIterator>
									<li><a href="<lucene:hit label="url"/>"><lucene:hit label="label" /></a>, <sql:query var="years" dataSource="jdbc/RDFUtil">
					                    select description
					                    from vivo.site
					                    where id = ?::int
					            	<sql:param>
										<lucene:hit label="site" />
									</sql:param>
								</sql:query> <c:forEach items="${years.rows}" var="yrow"
									varStatus="yrowCounter">
									<c:out value="${yrow.description}" />
								</c:forEach></li>
									</lucene:searchIterator>
								</ol>
							</div>
						</div>
					</lucene:search>
				</lucene:taxonomy>
			</c:if>
		</div>
	</div>
</body>

</html>
