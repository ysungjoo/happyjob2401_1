<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>기업고객관리</title>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
<script src="https://unpkg.com/axios@0.12.0/dist/axios.min.js"></script>
<script src="https://unpkg.com/lodash@4.13.1/lodash.min.js"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
</head>
<body>
	<input type="hidden" id="currentPage" value="1">
	<div id="mask"></div>
	<div id="wrap_area">
		<h2 class="hidden">header 영역</h2>
		<jsp:include page="/WEB-INF/view/common/header.jsp"></jsp:include>
		<h2 class="hidden">컨텐츠 영역</h2>
		<div id="container">
			<ul>
				<li class="lnb">
					<!-- lnb 영역 --> <jsp:include
						page="/WEB-INF/view/common/lnbMenu.jsp"></jsp:include> <!--// lnb 영역 -->
				</li>
				<li class="contents">
					<h3 class="hidden">contents 영역</h3>
					<div class="content" style="margin-bottom: 20px;">
						<p class="Location">
							<a href="/system/notice.do" class="btn_set home">메인으로</a> <a
								class="btn_nav">기준정보</a> <span class="btn_nav bold">기업고객관리</span>
							<a href="" class="btn_set refresh">새로고침</a>
						</p>
						<div id="cusdata">
						
						
						
						
							<div class="row">
								<div class="col-lg-6">
									<div class="input-group">
										<select v-model="searchKey"
											style="width: 90px; height: 34px;">
											<option value="all">전체</option>
											<option value="company_nm">회사명</option>
											<option value="company_mng_nm">담당자명</option>
										</select> <input type="text" v-model="searchInfo" class="form-control">
									</div>
								</div>
								<div class="btn-group" role="group">
									<button type="button" class="btn btn-default"
										onClick="javascript:fCusList()">검색</button>
								</div>

								<div class="input-group"
									style="display: inline-block; vertical-align: middle; margin-left: 10px;">
									<input type="checkbox" id="searchUseYn" v-model="searchUseYn">
									<label for="searchUseYn"
										style="display: inline-block; margin-top: 2px;">비활성화된
										항목 표시</label>
								</div>
							</div>
							
							
							
							<table class="col" style="margin-top: 15px;">
								<caption>caption</caption>
								<colgroup>
									<col width="12%">
									<col width="12%">
									<col width="12%">
									<col width="12%">
								</colgroup>
								<thead>
									<tr>
										<th scope="col">회사명</th>
										<th scope="col">담당자명</th>
										<th scope="col">연락처</th>
										<th scope="col">활성화여부</th>
									</tr>
								</thead>
								<tbody>
									<tr v-for="item in cusList">
										<td>{{ item.company_nm }}</td>
										<td>{{ item.company_mng_nm }}</td>
										<td>{{ item.mng_tel }}</td>
										<td>{{ item.active }}</td>
									</tr>
								</tbody>
							</table>
							
							
							<div class="paging_area" id="Pagination" v-html="pagehtml"></div>
							
							
						</div>

					</div>
				</li>
			</ul>
		</div>
	</div>
</body>
<script type="text/javascript">

    var searchList;

	$(document).ready(function() {
		fn_init();
		console.log("메인페이지 함수 실행");
		fCusList();
	});


	function fn_init() {
		searchList = new Vue({
			el : '#cusdata',
			data : {
				pageSizeInfo : 10,
				pageBlockSize : 5,
				currentPage : 1,
				cusList : [], // 고객 리스트
				cusListCnt : 0,
				searchKey : 'all',
				searchInfo : '',
				searchUseYn : false,
				currentPage : 1,
				pageSizeInfo : 10,
				pagehtml :"",
			},
		});
	}

	function fCusList(currentPage) {
		
		currentPage = currentPage || 1;					
		
		console.log("메인페이지 함수 실행3");
		//var vm = this; // 현재 Vue 인스턴스 this를 vm 변수에 할당하여 콜백 함수 내에서 Vue 인스턴스에 접근
		var params = {
			searchKey : searchList.searchKey,
			searchInfo : searchList.searchInfo,
			searchUseYn : searchList.searchUseYn,
			currentPage : currentPage,
			pageSize : searchList.pageSizeInfo
		};
		console.log("메인페이지 함수 실행4")
		// Using jQuery AJAX to perform the POST request
		$.ajax({
			url : '/scm/cusListInfoVue.do',
			type : 'POST',
			data : params,
			success : function(response) {
				console.log("!!!!!!!!!!!!!!!! : " + JSON.stringify(response));
				
				// Assuming the response is already a JavaScript object (not a string)
				searchList.cusList = response.cusList;
				
				console.log("11111111111111111111 : " + JSON.stringify(this.cusList));
				
				searchList.cusListCnt = response.cusListCnt;
				
				searchList.pagehtml = getPaginationHtml(currentPage, searchList.cusListCnt, searchList.pageSizeInfo, searchList.pageBlockSize, 'fCusList');
				var paginationHtml = getPaginationHtml(currentPage, searchList.cusListCnt, searchList.pageSizeInfo, searchList.pageBlockSize, 'fCusList');
			    console.log("paginationHtml : " + paginationHtml);
				
			},
			error : function(xhr, status, error) {
				console.error("AJAX 호출 중 오류 발생: ", error);
			}
		});
	};
	

/*   	function fSearchCusList(currentPage) {

		if ($("input:checkbox[id='searchUseYn']").is(":checked") == false) {

			currentPage = currentPage || 1;

			var param = $('#searchForm').serialize();

			param += "&currentPage=" + currentPage;
			param += "&pageSize=" + pageSizeInfo;

			console.log("검색조건에 대한 param : " + param);
			console.log("currentPage : " + currentPage);

			var resultCallback = function(data) {
				fCusListResult(data, currentPage);
			};

			//Ajax실행 방식
			//callAjax("Url",type,return,async or sync방식,넘겨준 값,Callback함수 이름)
			callAjax("/scm/cusListInfoVue.do", "post", "text", true, param,
					resultCallback);
		} else {
			currentPage = currentPage || 1;

			var param = $('#searchForm').serialize();

			param += "&currentPage=" + currentPage;
			param += "&pageSize=" + pageSizeInfo;
			param += "&showY=N";

			console.log("검색조건에 대한 param : " + param);
			console.log("currentPage : " + currentPage);

			var resultCallback = function(data) {
				fCusListResult(data, currentPage);
			};

			//Ajax실행 방식
			//callAjax("Url",type,return,async or sync방식,넘겨준 값,Callback함수 이름)
			callAjax("/scm/cusListInfo.do", "post", "text", true, param,
					resultCallback);
		}

	}  */

	/* 고객 조회 콜백 함수 */
	function fCusListResult(data, currentPage) {

		// console.log(data);

		//기존 목록 삭제 및 신규 목록 삽입
		$('#cusListInfo').empty().append(data);

		// 총 개수 추출
		var totCnt = $("#totCnt").val();

		//페이지 네비게이션 생성
		var paginationHtml = getPaginationHtml(currentPage, totCnt,
				pageSizeInfo, pageBlockSize, 'fSearchCusList');
		$("#Pagination").empty().append(paginationHtml);

		//현재 페이지 설정
		$("#currentPage").val(currentPage);
	}

	// 기업고객 모달창
	var cusInfoModal = new tingle.modal({
		footer : true,
		stickyFooter : false,
		closeMethods : [ 'button' ],
		closeLabel : "Close",
		cssClass : [ 'custom-class-1', 'custom-class-2' ],
		onOpen : function() {
			console.log('modal open');
		},
		onClose : function() {
			console.log('modal closed');
		},
		beforeClose : function() {
			// here's goes some logic
			// e.g. save content before closing the modal
			return true; // close the modal
			return false; // nothing happens
		}
	});

	// 모달창에 들어갈 데이터
	function cusInfoModalOpen(loginID) {
		console.log("컨트롤러로 넘어가는 loginID : " + loginID)
		cusDetailInfoDirection(loginID)
		cusInfoModal.open();
	}

	// 저장 버튼 추가 및 리스트 Ajax    
	cusInfoModal.addFooterBtn('저장', 'tingle-btn tingle-btn--primary',
			function() {

				var param = $('#modifyActiveFrom').serialize();

				console.log(param);

				var resultCallback = function(data) {
					getUpdateMessage(data);
				}

				callAjax("/scm/sendCusActiveModify.do", "post", "json", true,
						param, resultCallback);
				cusInfoModal.close();
			});

	// 닫기 버튼
	cusInfoModal.addFooterBtn('닫기', 'tingle-btn tingle-btn--danger',
			function() {
				cusInfoModal.close();
			});

	// 모달창에 가져올 데이터
	function cusDetailInfoDirection(loginID) {
		console.log("=== 1.모달창에 뿌릴 데이터 가져오기 시작 ===");

		var param = {
			loginID : loginID
		};

		var resultCallback = function(data) {
			cusInfoModalResult(data);
		};

		// Ajax 실행 방식
		// callAjax("Url", type, return, async or sync방식, 넘겨준거, Callback함수 이름)
		// html로 받을거라 text
		callAjax("/scm/cusDetailInfo.do", "post", "text", true, param,
				resultCallback);
	}

	function cusInfoModalResult(data) {

		// console.log("=== 2.모달창에 뿌릴 데이터 === : " + data);

		cusInfoModal.setContent(data);
		return;
	}

	// DB업데이트 상태 
	function getUpdateMessage(data) {
		if (data.result === "SUCCESS") {
			swal(data.resultMsg).then(function() {
				window.location.reload(); // 새로고침
			});
			console.log("상태 업데이트 완료");
			return 1;
		} else {
			swal(data.resultMsg).then(function() {
				window.location.reload(); // 새로고침
			});
			console.log("상태 업데이트 실패");
			return 0;
		}
	}
</script>

</html>