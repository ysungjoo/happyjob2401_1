<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>기업고객관리 뷰로 전환하기</title>
<script src="https://cdn.jsdelivr.net/npm/vue@2"></script>
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
<jsp:include page="/WEB-INF/view/common/common_include.jsp"></jsp:include>
</head>
<body>
	<input type="hidden" id="currentPage" value="1">
	<input type="hidden" name="action" id="action" value="">
	<!-- 모달 배경 -->
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
					<!-- contents -->
					<h3 class="hidden">contents 영역</h3> <!-- content -->
					<div class="content">
						<p class="Location">
							<a href="#" class="btn_set home">메인으로</a><span
								class="btn_nav bold">기업고객 관리</span> <a
								href="javascript:window.location.reload();"
								class="btn_set refresh">새로고침</a>
						</p>
						<p class="conTitle">
							<span>기업고객 관리</span>
						</p>


						<form id="searchForm">
							<div class="row">
								<!-- searchbar -->
								<div class="conTitle"
									style="margin: 0 25px 10px 0; float: left;">
									<template v-for="key in selectList"> <select
										:id="'searchKey_' + key.id" name="searchKey"
										style="width: 100px;" v-model="key.selectedKey">
										<option value="all" selected="selected">전체</option>
										<option value="company_name" id="company_name">회사명</option>
										<option value="manager_name" id="manager_name">담당자명</option>
									</select> </template>
									<input type="text" style="width: 300px; height: 30px;"
										id="searchInfo" name="searchInfo" v-model="searchInfo">
									<!-- checkbox -->
									<div class="input-group"
										style="display: inline-block; vertical-align: middle; margin-left: 10px;">
										<input type="checkbox" id="searchUseYn" v-model="showY"
											v-on:change="fSearchCusList"> <label
											for="searchUseYn"
											style="display: inline-block; margin-top: 2px;">비활성화된
											항목 표시</label>
									</div>
									<!-- // checkbox -->
									<!-- button -->
									<a href="" class="btnType blue" id="searchBtn" name="btn"
										v-on:click="fSearchCusList"> <span>검색</span></a>
									<!-- button 끝-->
								</div>
							</div>
							<!-- /.row -->
						</form>
						<div id="cusListInfo">
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
									<tr v-if="cusList.length === 0">
										<td colspan="4">데이터가 존재하지 않습니다.</td>
									</tr>
									<tr v-for="(item,index) in cusList">
										<td><a href="cusInfoModalOpen(item.loginID);">
											  {{ item.company_nm }}</a></td>
										<td>{{ item.company_mng_nm }}</td>
										<td>{{ item.mng_tel }}</td>
										<td>{{ item.active }}</td>
									</tr>
								</tbody>
							</table>
							<input type="hidden" id="totCnt" v-model="cusListCnt" >
							<div>{{ cusListCnt }}</div>
						</div>
						 <div class="paging_area" id="Pagination"  v-model="Pagination" >
							<button :disabled="currentPage === 1" @click="prevPage" class="page-btn">이전</button>
							<span> {{ currentPage }}</span>
							<button :disabled="currentPage === totalPages" @click="nextPage" class="page-btn">다음</button>
						</div> 
					</div>
				</li>
			</ul>
		</div>
	</div>
</body>
<script type="text/javascript">
	

    var pageSizeInfo = 10;
    var pageBlockSize = 5;
    
    var searchoption;
    var list;
    var paginationHtml;
    
    
    /*OnLoad event*/
    $(document).ready(function(){
      console.log("메인페이지 함수 실행")
      
       fn_init();
      //고객 조회 
      /*  fCusList();  */
      
    }) 
     
  function fn_init() {
    list = new Vue({
        el: '#cusListInfo',
        data: {
            cusList: [ ],
            cusListCnt: 0,  // cusListCnt를 추가 & 초기값 설정
            totCnt: 0,
            param : {
            	currentPage : currentPage.value || 1,
            	pageSize : pageBlockSize
            }
        },
        created: function () {
        	console.log(this.param);
                axios.post('cusListInfo.do', this.param)
                   .then(response => {
                      console.log(response.data); // cusList 객체 구조가 있는지 확인 
                      this.cusList=response.data.cusList;
                      this.cusListCnt = response.data.totCnt; 
                      
                   // 페이지 네비게이션 생성
                      //initPagination(this.param.currentPage, this.cusListCnt, pageSizeInfo, pageBlockSize, 'fSearchCusList');
                      
                   })
                   .catch(error => {
                      console.log('Error fetching data:', error);
                   })
            },
             methods: {
		            
		        }
		    });
		}
    	
	    searchoption = new Vue({
	        el: '#searchForm',
	        data: {
	            showY: false, // 디폴트값 
	            selectList: [
	                { selectedKey: 'all' } // 초기 값 설정        
	            ],
	            searchInfo: '', // 검색어를 담을 변수
	            param: {
	            	currentPage : currentPage.value || 1,
	                pageSize: pageBlockSize
	            },
	            //totCnt: 0,  // 추가된 부분,
	            cusListCnt: 0,  // cusListCnt를 추가
	        },
	        methods: {
	            fSearchCusList: function (currentPage) {
	               currentPage = currentPage.value || 1;
	
	                // 서버에 보낼 데이터
	                let requestData = {
	                    currentPage: currentPage,
	                    pageSize: pageSizeInfo,
	                    showY: this.showY ? 'N' : 'Y', // showY가 true면 'N', false면 'Y'
	                    searchInfo: this.searchInfo,
	                    selectedKey: this.selectList[0].selectedKey // 수정된 부분
	                };
	                
	             	// 이벤트 핸들러에서 preventDefault 호출
	                event.preventDefault();
	             	
	                // axios를 사용한 AJAX 요청
	                axios.post('/scm/cusListInfo.do', requestData)
	                    .then(response => { 
	                    	console.log('Server response 데이터옴? :', response.data); // 추가된 부분
	                        let responseData = response.data;
	
	                        // 이후 responseData를 적절하게 활용
	                        this.fCusListResult(responseData, currentPage);
	                    })
	                    .catch(error => {
	                        console.error('Error fetching data:', error);
	                    });
			            },
			            fCusListResult: function (data, currentPage) {
			            	console.log('Received data from the server 결과데이터오냐고:', data);
			            	
			            	 console.log('cusList:', data.cusList);
			            
			            	 console.log('cusListCnt:', data.cusListCnt);
			            	 console.log('totCnt:', data.totCnt);
			            	 
			            	 // totCnt 확인
			            	 /*    if (data.hasOwnProperty('totCnt')) {
			            	        console.log('totCnt:', data.totCnt); */
			                
			                // Vue.js에서는 직접 DOM을 조작하는 것이 아니라 데이터를 갱신하여 반응형으로 화면을 업데이트
			                list.$set(list, 'cusList', data.cusList);

			                // 총 개수 추출
			                list.$set(list, 'totCnt', data.totCnt);
			                
			                 // 페이지 네비게이션 생성
                          //initPagination(lits.param.currentPage, data.totCnt, pageSizeInfo, pageBlockSize, 'fSearchCusList');
			          
			                // 현재 페이지 설정
			                this.$set(this.param, 'currentPage', currentPage);
			            
			        }
	            }
		    });
	    
	    function initPagination(currentPage, totCnt, pageSizeInfo, pageBlockSize, searchFunction) {
	        var paginationHtml = new Vue({
	            el: "#Pagination",
	            data: {
	                currentPage: currentPage,
	                totalPages: Math.ceil(totCnt / pageSizeInfo),
	                pageBlockSize: pageBlockSize,
	                pageSizeInfo: pageSizeInfo,
	            },
	            methods: {
	                prevPage() {
	                    if (this.currentPage > 1) {
	                        this.currentPage--;
	                    }
	                },
	                nextPage() {
	                    if (this.currentPage < this.totalPages) {
	                        this.currentPage++;
	                    }
	                }
	            }
	        });
	     }
	   
	 
</script>
</html>