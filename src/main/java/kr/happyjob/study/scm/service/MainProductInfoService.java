package kr.happyjob.study.scm.service;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import kr.happyjob.study.scm.model.GetWarehouseModel;
import kr.happyjob.study.scm.model.MainProductInfoModel;
import kr.happyjob.study.scm.model.MainProductModalModel;
import kr.happyjob.study.scm.model.MainProductModalSubModel;

public interface MainProductInfoService {
  /* 제품 목록 조회 */
  public List<MainProductInfoModel> listMainProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품 목록 카운트 조회 */
  public int totalCntMainProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품정보 관리 조회*/
  public MainProductInfoModel selectMainProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품정보 selectlist 조회*/
  public List<MainProductModalSubModel> selectSubProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품 상세정보 조회*/
  public MainProductModalModel mainProductModal(Map<String, Object> paramMap) throws Exception;
  
  //파일 업로드를 위해  file_no 조회
  public int selectFileNo()throws Exception;
  
  /* 창고정보 조회*/
  public GetWarehouseModel getWarehouseInfo(Map<String, Object> paramMap)throws Exception;
  /* 제품정보 저장 */
  public int insertMainProduct(Map<String, Object> paramMap) throws Exception;
  /* 제품정보 파일 저장 */
  public int insertFileMainProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품정보 수정 */
  public int updateMainProduct(Map<String, Object> paramMap) throws Exception;
  
  /* 제품정보 삭제 */
  public int deleteMainProduct(Map<String, Object> paramMap) throws Exception;
  /* 제품정보 파일 삭제 */
  public int deleteFileMainProduct(Map<String, Object> paramMap) throws Exception;
}
