<%-- <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>제품 정보 관리</title>
<script src="https://code.jquery.com/jquery-3.4.1.js" integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<script type="text/javascript">
function modalPopup(){
	$('#layer1').show();
}

function clearText(){
	document.getElementById("registerProduct").reset();
}

function detailProduct(product_code){

	location.href = "/scm/productDetail.do?product_code="+product_code;
}

$(function(){
	//페이징 설정
	var pageSize = 5;
	var pageBlock = 5;
	//리스트 로우의 총 개수 추출
	var totalCount = $("#totalCount").val();
	var currentPage = $("#currentPage").val();

	console.log("totalCount: " + totalCount + "currentPage: " + currentPage + "pageSize: " + pageSize);

	// 페이지 네비게이션 생성
	var paginationHtml = getPaginationHtml(currentPage, totalCount, pageSize, pageBlock, 'selectList');

	$("#pagination").empty().append(paginationHtml);

	// 현재 페이지 설정
	$("#currentPageCod").val(currentPage);
})

</script>

</head>
<body>
<!-- 모달 배경 -->
<div id="mask"></div>
<div id="wrap_area">

	<h2 class="hidden">header 영역</h2>
	<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>

	<h2 class="hidden">컨텐츠 영역</h2>
      <div id="container">
        <ul>
          <li class="lnb">
            <!-- lnb 영역 -->
            <jsp:include page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include>
            <!--// lnb 영역 -->
          </li>

          <li class="contents">
            <!-- contents -->
            <h3 class="hidden">contents 영역</h3>

              <p class="Location">
                <a href="#" class="btn_set home">메인으로</a><span class="btn_nav bold">제품 정보 관리</span> <a href="javascript:window.location.reload();" class="btn_set refresh">새로고침</a>
              </p>

              <p class="conTitle">
                <span>제품 정보 관리</span>
              </p>

		<form action="/scm/searchList.do" method="post">
			<div class="row">
			<!-- searchbar -->
				<div class="col-lg-6">
					<div class="input-group">
						<select style="width: 90px; height: 34px;" name="option">
							<option value="all" selected>전체</option>
							<option value="product_name">제품명</option>
							<option value="product_model_name">모델명</option>
							<option value="produce_company_name">제조사</option>
						</select>
						<input type="text" class="form-control" aria-label="..." name="keyword" autocomplete="off">
					</div>
				</div>
				<!-- // searchbar -->
				<!-- button -->
				<div class="btn-group" role="group" aria-label="...">
					<button type="submit" class="btn btn-default" id="search_button" onclick="searchProduct()">검색</button>
					<button type="button" class="btn btn-default" id="register_modal_button" onclick="modalPopup()">제품 등록</button>
				</div>
				<!-- // button -->
				<div class="btn-wrap"></div>
			</div>
			<!-- /.row -->
			<div class="divComGrpCodList">
				<table class="col">
					<caption>caption</caption>
						<colgroup>
							<col width="10%">
							<col width="30%">
							<col width="10%">
							<col width="20%">
							<col width="10%">
							<col width="20%">
						</colgroup>
					<thead>
						<tr>
							<th scope="col">모델번호</th>
							<th scope="col">모델명</th>
							<th scope="col">제품번호</th>
							<th scope="col">제품명</th>
							<th scope="col">제조사</th>
							<th scope="col">판매가</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${productList}" var="list">
							<tr>
								<td>${list.product_model_number}</td>
								<td><a href="/scm/productDetail.do?product_code=${list.product_code }">${list.product_model_name }</a></td>
								<td id="product_code">${list.product_code }</td>
								<td>${list.product_name }</td>
								<td>${list.produce_company_name }</td>
								<td>${list.product_model_price }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</form>

		<div class="paging_area" id="pagination">
			<input type="hidden" value="${totalCount }" id="totalCount"/><input type="hidden" value="${currentPage }" id="currentPage"/><input type="hidden" value="${pageSize }" id="pageSize"/>
		</div>
		<h3 class="hidden">풋터 영역</h3>
			<jsp:include page="/WEB-INF/view/common/footer.jsp"></jsp:include>
	</li>
</ul>
</div>
</div>

<!-- 등록 모달 시작-->
<form id="productForm" action="/scm/registerProductInfo.do" method="post" enctype="multipart/form-data">
	<div id="layer1" class="layerPop layerType2" style="width: 1000px;">
		<input type="hidden" id="product_code">
      	<dl>
        	<dt id="dt_write">
          		<strong>제품 등록</strong>
        	</dt>
        	<dd class="content">
          	<table class="row">
            	<caption>caption</caption>
            	<colgroup>
              		<col width="120px">
              		<col width="*">
              		<col width="120px">
              		<col width="*">
              		<col width="120px">
              		<col width="*">
            	</colgroup>
            	<tbody>
              		<tr>
                		<th scope="row">모델 번호</th>
                		<td colspan="5">
                			<input type="text" class="inputTxt p100" name="product_model_number" id="product_model_number" autocomplete="off" required />
                		</td>
              		</tr>
              		<tr id="add_file">
                		<th scope="row">첨부파일</th>
                		<td colspan="4"><input type="file" class="inputTxt p100" id="uploadFile" name="file" accept="image/*" /></td>
              		</tr>
              	</tbody>
			</table>
			<table class="row">
				<caption>caption</caption>
            	<colgroup>
              		<col width="120px">
              		<col width="*">
              		<col width="120px">
              		<col width="*">
              		<col width="120px">
              		<col width="*">
            	</colgroup>
            	<tbody>
              		<tr id="datice_date_block">
              		</tr>
              		<tr id="datice_date_block">
              			<th scope="row">제품번호</th>
                		<td colspan="2"><input type="text" class="inputTxt p100" name="product_code" id="product_code" autocomplete="off" required /></td>
                		<th scope="row">모델명</th>
                		<td colspan="2"><input type="text" class="inputTxt p100" name="product_model_name" id="product_model_name" autocomplete="off" required /></td>
              		</tr>
              		<tr class="auth_block">
                		<th scope="row">장비 구분</th>
                		<td>
                  			<select class="auth_block" id="product_category" name="product_category">
                    		<c:forEach var="pd" items="${productList }">
    							<option value="${pd.product_category}">${pd.product_category}</option>
							</c:forEach>
                  			</select>
                		</td>
                		<th scope="row">제조사</th>
                		<td>
                  			<select class="auth_block" id="produce_company_name" name="produce_company_name">
                    		<c:forEach var="pd" items="${productList }">
    							<option value="${pd.produce_company_name}">${pd.produce_company_name}</option>
							</c:forEach>
                  			</select>
                		</td>
                		<th scope="row">판매업체</th>
                		<td>
                  			<select class="auth_block" id="company_class_name" name="company_class_name">
                    		<c:forEach var="pd" items="${productList }">
    							<option value="${pd.company_class_name}">${pd.company_class_name}</option>
							</c:forEach>
                  			</select>
                		</td>
              		</tr>
              		<tr id="datice_date_block">
                		<th scope="row">제품명</th>
                		<td colspan="2"><input type="text" class="inputTxt p100" name="product_name" id="product_name" autocomplete="off" required /></td>
                		<th scope="row">제품가격</th>
                		<td colspan="2"><input type="text" class="inputTxt p100" name="product_model_price" id="product_model_price" autocomplete="off" required /></td>
              		</tr>
              		<tr>
              			<th scope="row">상세정보</th>
                		<td colspan="5"><textarea class="inputTxt p100" name="detail" id="detail" placeholder="최대 1000자까지 입력 가능합니다" required></textarea>
                  			<p class="pull-right" id="count_cotent">
                    			<span id="count">0</span>/1000
                  			</p>
                		</td>
              		</tr>
              		<tr>
                		<td colspan="4" style="position:absolute; top:100%; left:35%; border-right:none; border-left:none">
                  		<c:if test="${sessionScope.userType == 'E'}">
                    		<div class="btn-group">
                      			<button class="btn-default btn-sm" id="register_button" onclick="registerProduct()">저장</button>
                      			<button class="btn-default btn-sm" id="close_button" onclick="clearText()">취소</button>
                    		</div>
                  		</c:if>
                		</td>
              		</tr>
            	</tbody>
          </table>
        </dd>
      </dl>
      <a class="closePop" id="closePop_button"><span class="hidden">닫기</span></a>
    </div>
<!-- 모달 끝 -->

<jsp:include page="/WEB-INF/view/scm/MainProductView.jsp"></jsp:include>

</form>
</body>
</html> --%>