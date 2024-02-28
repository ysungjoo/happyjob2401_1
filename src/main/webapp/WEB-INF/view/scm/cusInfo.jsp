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
<!-- 우편번호 조회 -->
<script
	src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script type="text/javascript" charset="utf-8"
	src="${CTX_PATH}/js/popFindZipCode.js"></script>

<script type="text/javascript"
	src="http://code.jquery.com/jquery-latest.min.js"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
<!-- sweet alert import -->
<script src='${CTX_PATH}/js/sweetalert/sweetalert.min.js'></script>
<!-- seet swal import -->
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
										<select v-model="searchKey" name="searchKey"
											style="width: 90px; height: 34px;">
											<option value="all">전체</option>
											<option value="company_nm">회사명</option>
											<option value="company_mng_nm">담당자명</option>
										</select> <input type="text" v-model="searchInfo" id="searchInfo"
											name="searchInfo" class="form-control">
									</div>
								</div>
								<div class="btn-group" role="group">
									<button type="button" class="btn btn-default"
										onClick="javascript:fCusList()">검색</button>
								</div>

								<div class="input-group"
									style="display: inline-block; vertical-align: middle; margin-left: 10px;">
									<input type="checkbox" id="searchUseYn" name="searchUseYn"
										v-model="searchUseYn"> <label for="searchUseYn"
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
								<tbody id="cusListInfo">
									<tr v-for="item in cusList" @click="detailview(item.loginID)" style="cursor : pointer">
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
	var cusInfoLayer;

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
				pagehtml : "",
			},
			methods : {
				detailview : function(loginID) {
					cusInfoModalOpen(loginID);
				}
			}
		});

		cusInfoLayer = new Vue({
			el : "#layer1",
			data : {
				loginId : '',
				customeruserType : '',
				customeruserId : '',
				customername : '',
				customercompanyName : '',
				customerphoneNumber : '',
				customeremail : '',
				zipcode : '',
				addr : '',
				addrdetail : '',
			},
			methods : {
				execDaumPostcode : function() {
					execDaumPostcode();
					// 여기에 우편번호 찾기 로직 구현
				},
				cusInfoSave : function() {
					// 여기에 저장 로직 구현
					console.log("저장 로직 실행");
				},
				cusInfoDelete : function() {
					deleteCusInfo();
					// 여기에 삭제 로직 구현
					console.log("삭제 로직 실행");
				},
				cusInfoClose : function() {
					gfCloseModal();
					// 여기에 모달 취소 로직 구현
					console.log("모달 취소 로직 실행");
				},
				closeModal : function() {
					// 여기에 모달 닫기 로직 구현
					cusInfoModal();
					console.log("모달 닫기 로직 실행");
				}
			}
		});
	}

	$(function() {
		// 버튼 이벤트 등록
		fRegisterButtonClickEvent();
	});

	// 버튼 이벤트 등록 함수
	function fRegisterButtonClickEvent() {
		$('a[name=btn]').click(function(e) {
			e.preventDefault();
			var btnId = $(this).attr('id');
			// 적절한 메서드 호출
			switch (btnId) {
			case 'btnSaveGrpCod':
				modalApp.cusInfoSave();
				break;
			case 'btnDeleteGrpCod':
				modalApp.cusInfoDelete();
				break;
			case 'btnCloseGrpCod':
				modalApp.cusInfoClose();
				break;
			}
		});
	}

	/*기업 고객 조회*/
	function fCusList(currentPage) {

		currentPage = currentPage || 1;

		//var vm = this; // 현재 Vue 인스턴스 this를 vm 변수에 할당하여 콜백 함수 내에서 Vue 인스턴스에 접근
		var params = {
			searchKey : searchList.searchKey,
			searchInfo : searchList.searchInfo,
			searchUseYn : searchList.searchUseYn,
			currentPage : currentPage,
			pageSize : searchList.pageSizeInfo
		};

		$.ajax({
			url : '/scm/cusListInfoVue.do',
			type : 'POST',
			data : params,
			success : function(response) {
				console.log("!!!!!!!!!!!!!!!! : " + JSON.stringify(response));

				// Assuming the response is already a JavaScript object (not a string)
				searchList.cusList = response.cusList;

				console.log("11111111111111111111 : "
						+ JSON.stringify(this.cusList));

				searchList.cusListCnt = response.cusListCnt;

				searchList.pagehtml = getPaginationHtml(currentPage,
						searchList.cusListCnt, searchList.pageSizeInfo,
						searchList.pageBlockSize, 'fCusList');
				var paginationHtml = getPaginationHtml(currentPage,
						searchList.cusListCnt, searchList.pageSizeInfo,
						searchList.pageBlockSize, 'fCusList');
				console.log("paginationHtml : " + paginationHtml);

			},
			error : function(xhr, status, error) {
				console.error("AJAX 호출 중 오류 발생: ", error);
			}
		});
	};

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

	// fadeInModal
	function fadeInModal(identifier, loginId) {

		if (identifier == 'r') {
			swapModal(identifier);
			//  모달 초기화
			initModal(identifier);
			//  단건 조회
			selectDetail(loginId, identifier);
			console.log('fadeInModal : ' + identifier)
			console.log('login_id : ' + loginId)
		}
		// 모달 팝업
		gfModalPop("#layer1");
	}

	function swapModal(identifier) {
		if (identifier == 'r') {

			$('#dt_title').show();

			$('#btnDeleteGrpCod').show();
			$('#btnDeleteGrpCod').show();

			$('#datice_date_block').show();
			$('#customer_name').attr('readonly', false);
			$('#customer_companyName').attr('readonly', false);

		}
	}

	function initModal(identifier, result) {
		var name = $('customer_name').val();

		if (identifier == 'r') {
			console.log('단건조회', result)
			if (result) {

				cusInfoLayer.loginId = result.loginId;
				cusInfoLayer.customer_name = result.customer_name;
				cusInfoLayer.customer_companyName = result.customer_companyName;
				cusInfoLayer.customer_phoneNumber = result.customer_phoneNumber;
				cusInfoLayer.customer_email = result.customer_email;
				cusInfoLayer.zip_code = result.zip_code;
				cusInfoLayer.addr = result.addr;
				cusInfoLayer.addr_detail = result.addr_detail;

			}
		}
	}

	function selectDetail(loginId, identifier) {

		var param = {
			loginId : loginId
		};

		// 공지사항  작성 모달
		function resultCallback(result) {

			// 공지사항  작성 모달
			gfModalPop("#layer1");
			initModal(identifier, result);

		}
		callAjax("/scm/cusDetailInfo.do", "post", "json", true, param,
				resultCallback);
	}

	/** 그룹코드 모달 실행 */
	function fPopModalComnGrpCod(company_mng_nm) {

		// 신규 저장
		if (company_mng_nm == null || company_mng_nm == "") {
			//swal("여기도 찍어봅세  ");
			// Tranjection type 설정
			$("#action").val("I");

			// 그룹코드 폼 초기화
			fInitFormGrpCod();

			// 모달 팝업
			gfModalPop("#layer1");

			// 수정 저장
		} else {
			// Tranjection type 설정
			$("#action").val("U");

			// 그룹코드 단건 조회
			fSelectGrpCod(company_mng_nm);
		}
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

	/* 공지사항 삭제 함수 */
	function deleteCusInfo() {
		var isDelete = confirm('정말 삭제하시겠습니까?');

		if (isDelete) {
			var login_id = cusInfoarea.loginId;

			var param = {
				login_id : login_id,
			}

			// 콜백
			function resultCallback(result) {
				if (result == 1) {
					gfCloseModal();
					fCusList();
				} else {
					swal('서버에서 에러가 발생했습니다');
				}
			}
			;

			callAjax("/scm/deleteCusInfo.do", "post", "text", true, param,
					resultCallback);
		} else {
			return false;
		}
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
	//우편번호 api
	function execDaumPostcode(q) {
		new daum.Postcode({
			oncomplete : function(data) {
				// 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if (data.userSelectedType === 'R') {
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', '
								+ data.buildingName : data.buildingName);
					}
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('zip_code').value = data.zonecode;
				document.getElementById("addr").value = addr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("addr_detail").focus();
			}
		}).open({
			q : q
		});
	}
</script>

</html>