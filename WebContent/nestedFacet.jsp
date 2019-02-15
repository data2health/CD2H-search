<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="lucene" uri="http://icts.uiowa.edu/lucene"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<ol class="bulletedList">
	<lucene:facetIterator>
		<c:set var="path">${param.parentPath}/<lucene:facet	label="content" /></c:set>
		<c:set var="facet"><lucene:facet label="content" /></c:set>
		<lucene:facet label="none">
			<c:choose>
				<c:when test="${fn:contains(param.drillDownList, path.concat('|'))}">
					<li><lucene:facet label="content" /> <a	href="sparcSearch.jsp?query=${param.query}&drillDown=${param.drillDownList}&drillOut=${path}">&larr;</a>
						<a href="sparcSearch.jsp?query=${param.query}&drillDown=${param.drillDownList}&drillUp=${path}">x</a>
				</c:when>
				<c:when test="${fn:contains(param.drillDownList, path)}">
					<li><lucene:facet label="content" />
				</c:when>
				<c:otherwise>
					<li><a href="sparcSearch.jsp?query=${param.query}&drillDown=${param.drillDownList}${path}">${facet}</a> (<lucene:facet label="count" />)
				</c:otherwise>
			</c:choose>
			</li>
		</lucene:facet>
	</lucene:facetIterator>
</ol>
