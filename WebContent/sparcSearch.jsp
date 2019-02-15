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
			<div id=form>
				<form method='POST' action='sparcSearch.jsp'>
					<table>
						<tr>
							<td><fieldset>
									<legend>Query?</legend>
									<input name="query" value="${param.query}" size=50> <input type=submit name=submitButton value=Search>
                <a href="sparcSearch.jsp">reset</a>
								</fieldset></td>
						</tr>
					</table>
				</form>
			</div>
			<br/>
			<c:choose>
			<c:when test="${not empty param.query}">
				<p />
				<c:set var="host"><util:requestingHost /></c:set>
				<util:Log line="" message="requesting host: ${host}" page="ctsaSearch" level="INFO"></util:Log>
				<util:Log line="" message="query: ${param.query}"	page="ctsaSearch" level="INFO"></util:Log>
				<h3>Search Results:	<c:out value="${displayString}" /></h3>
                <div style="width: 100%; float: left">
				<lucene:taxonomy taxonomyPath="/usr/local/CD2H/lucene/sparc_tax">
					<lucene:countFacetRequest categoryPath="Source" depth="5" />
					<lucene:countFacetRequest categoryPath="Entity" depth="3" />
					<lucene:countFacetRequest categoryPath="CPT" depth="4"/>
					
					<c:set var="drillDownList"><lucene:drillDownProcessor categoryPaths="${param.drillDown}" drillUpCategory="${param.drillUp}" drillOutCategory="${param.drillOut}" /></c:set>

					<lucene:search lucenePath="/usr/local/CD2H/lucene/sparc" label="content" queryParserName="boolean" queryString="${param.query}" useConjunctionByDefault="true">
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
																	<li><lucene:facet label="content" /> <a	href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet2path}">x</a>
																</c:when>
																<c:when test="${fn:contains(drillDownList, facet2path)}">
																	<li><lucene:facet label="content" />
																</c:when>
																<c:otherwise>
																	<li><a href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet2path}">${facet2}</a> (<lucene:facet label="count" />)
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
																				<a	href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillOut=${facet3path}">&larr;</a>
		                                                                      <a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet3path}">x</a>
        																	</c:when>
																			<c:when	test="${fn:contains(drillDownList, facet3path)}">
																				<li><lucene:facet label="content" />
																			</c:when>
																			<c:otherwise>
																				<li><a	href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet3path}">${facet3}</a> (<lucene:facet label="count" />)
																			</c:otherwise>
																		</c:choose>
			                                                            <ol class="bulletedList">
			                                                                <lucene:facetIterator>
			                                                                    <c:set var="facet4path">${facet3path}/<lucene:facet label="content" /></c:set>
			                                                                    <c:set var="facet4"><lucene:facet label="content" /></c:set>
			                                                                    <lucene:facet label="none">
			                                                                        <c:choose>
			                                                                            <c:when test="${fn:contains(drillDownList, facet4path.concat('|'))}">
			                                                                                <li><lucene:facet label="content" />
			                                                                                <a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillOut=${facet4path}">&larr;</a>
			                                                                              <a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet4path}">x</a>
			                                                                            </c:when>
			                                                                            <c:when test="${fn:contains(drillDownList, facet4path)}">
			                                                                                <li><lucene:facet label="content" />
			                                                                            </c:when>
			                                                                            <c:otherwise>
			                                                                                <li><a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet4path}">${facet4}</a> (<lucene:facet label="count" />)
			                                                                            </c:otherwise>
			                                                                        </c:choose>
			                                                                        <ol class="bulletedList">
			                                                                            <lucene:facetIterator>
			                                                                                <c:set var="facet5path">${facet4path}/<lucene:facet label="content" /></c:set>
			                                                                                <c:set var="facet5"><lucene:facet label="content" /></c:set>
			                                                                                <lucene:facet label="none">
			                                                                                    <c:choose>
			                                                                                        <c:when test="${fn:contains(drillDownList, facet5path.concat('|'))}">
			                                                                                            <li><lucene:facet label="content" />
			                                                                                            <a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillOut=${facet5path}">&larr;</a>
			                                                                                          <a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}&drillUp=${facet5path}">x</a>
			                                                                                        </c:when>
			                                                                                        <c:when test="${fn:contains(drillDownList, facet5path)}">
			                                                                                            <li><lucene:facet label="content" />
			                                                                                        </c:when>
			                                                                                        <c:otherwise>
			                                                                                            <li><a  href="sparcSearch.jsp?query=${param.query}&drillDown=${drillDownList}${facet5path}">${facet5}</a> (<lucene:facet label="count" />)
			                                                                                        </c:otherwise>
			                                                                                    </c:choose>
			                                                                                  </li>
			                                                                                  </lucene:facet>
			                                                                           </lucene:facetIterator>
			                                                                        </ol>
			                                                                      </li>
			                                                                      </lucene:facet>
			                                                               </lucene:facetIterator>
			                                                            </ol>
																	  </li>
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
										<li><a href="sparcResult.jsp?id=<lucene:hit label="url" />"><lucene:hit label="label" /></a> [<lucene:hit label="source" />]</li>
									</lucene:searchIterator>
								</ol>
							</div>
						</div>
					</lucene:search>
				</lucene:taxonomy>
                </div>
			</c:when>
			<c:otherwise>
				This proof-of-concept explores the SPARC services at MUSC.
				<p>
				</c:otherwise>
			</c:choose>
            <div style="width: 100%; float: left">
                <jsp:include page="footer.jsp" flush="true" />
            </div>
		</div>
	</div>
</body>

</html>
