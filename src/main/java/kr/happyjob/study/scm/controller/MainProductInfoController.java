package kr.happyjob.study.scm.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import kr.happyjob.study.common.comnUtils.FileUtilCho;
import kr.happyjob.study.scm.model.GetWarehouseModel;
import kr.happyjob.study.scm.model.MainProductInfoModel;
import kr.happyjob.study.scm.model.MainProductModalModel;
import kr.happyjob.study.scm.model.MainProductModalSubModel;
import kr.happyjob.study.scm.service.MainProductInfoService;

@Controller
@RequestMapping("/scm")
public class MainProductInfoController {
   // 파일 업로드에 사용 될 property
  // 물리경로(상위)
  @Value("${fileUpload.rootPath}")
  private String rootPath;
  
  // 물리경로(하위)-공지사항 이미지 저장용 폴더
  @Value("${fileUpload.productPath}")
  private String mainProductPath;
  
  // 상대경로
  @Value("${fileUpload.productRelativePath}")
  private String fileRelativePath;
  
  @Autowired
  MainProductInfoService mainProductInfoService;
  
  private static final Logger logger = LoggerFactory.getLogger(MainProductInfoController.class);
  private final String className = this.getClass().toString();
  
  @RequestMapping("mainProductInfo.do")
  public String initMainProductInfo(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession Session) throws Exception {
    
    logger.info("+ Start " + className + ".initMainProductInfo");
    logger.info("   - paramMap : " + paramMap);
    
    logger.info("+ End " + className + ".initMainProductInfo");
    
    return "scm/mainProductInfo";
  }
  
  // 제품 조회
  @RequestMapping("listMainProduct.do")
  public String listWarehouse(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
    
    logger.info("+ Start " + className + ".listWarehouse");
    logger.info("   - paramMap : " + paramMap);
    
    int currentPage = Integer.parseInt((String) paramMap.get("currentPage")); // 현재 페이지 번호
    int pageSize = Integer.parseInt((String) paramMap.get("pageSize")); // 페이지 사이즈
    int pageIndex = (currentPage - 1) * pageSize; // 페이지 시작 row 번호
    
    paramMap.put("pageIndex", pageIndex);
    paramMap.put("pageSize", pageSize);
    
    // 제품 목록 조회
    List<MainProductInfoModel> listMainProductModel = mainProductInfoService.listMainProduct(paramMap);
    model.addAttribute("listMainProductModel", listMainProductModel);
    
    // 제품 목록 카운트 조회
    int totalCount = mainProductInfoService.totalCntMainProduct(paramMap);
    model.addAttribute("totalMainProduct", totalCount);
    
    model.addAttribute("pageSize", pageSize);
    model.addAttribute("currentPageMainProduct", currentPage);
    
    logger.info("+ End " + className + ".listMainProduct");
    
    return "scm/listMainProduct";
  }
  
//제품 조회 Vue
 @RequestMapping("listMainProductVue.do")
 @ResponseBody
 public Map<String, Object> listWarehouseVue(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
   
   logger.info("+ Start " + className + ".listWarehouse");
   logger.info("   - paramMap : " + paramMap);
   
   int currentPage = Integer.parseInt((String) paramMap.get("currentPage")); // 현재 페이지 번호
   int pageSize = Integer.parseInt((String) paramMap.get("pageSize")); // 페이지 사이즈
   int pageIndex = (currentPage - 1) * pageSize; // 페이지 시작 row 번호
   
   paramMap.put("pageIndex", pageIndex);
   paramMap.put("pageSize", pageSize);
   
   Map<String, Object> resultMap = new HashMap<String, Object>();
   
   // 제품 목록 조회
   List<MainProductInfoModel> listMainProductModel = mainProductInfoService.listMainProduct(paramMap);
   resultMap.put("listMainProductModel", listMainProductModel);
   
   // 제품 목록 카운트 조회
   int totalCount = mainProductInfoService.totalCntMainProduct(paramMap);
   resultMap.put("totalMainProduct", totalCount);
   resultMap.put("pageSize", pageSize);
   resultMap.put("currentPageMainProduct", currentPage);
   
   logger.info("+ End " + className + ".listMainProduct");
   
   return resultMap;
 }
  
  // 제품정보 관리 조회
  @RequestMapping("selectMainProduct.do")
  @ResponseBody
  public Map<String, Object> selectMainProduct(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
    logger.info("+ Start " + className + ".selectMainProduct");
    logger.info("   - paramMap : " + paramMap);
    
    String result = "SUCCESS";
    String resultMsg = "조회 되었습니다.";
    
    MainProductInfoModel mainProductInfoModel = mainProductInfoService.selectMainProduct(paramMap);
    
    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("result", result);
    resultMap.put("resultMsg", resultMsg);
    resultMap.put("mainProductInfoModel", mainProductInfoModel);
    
    logger.info("+ End " + className + ".selectMainProduct");
    
    System.out.println(resultMap);
    return resultMap;
  }
  
  //제품정보 selectList 조회
 @RequestMapping("selectSubProduct.do")
 @ResponseBody
 public Map<String, Object> selectSubProduct(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
   logger.info("+ Start " + className + ".selectMainProduct");
   logger.info("   - paramMap : " + paramMap);
   
   String result = "SUCCESS";
   String resultMsg = "조회 되었습니다.";
   
   List<MainProductModalSubModel> mainProductInfoModel = mainProductInfoService.selectSubProduct(paramMap);
   
   Map<String, Object> resultMap = new HashMap<String, Object>();
   resultMap.put("result", result);
   resultMap.put("resultMsg", resultMsg);
   resultMap.put("mainProductInfoModel", mainProductInfoModel);
   
   logger.info("+ End " + className + ".selectMainProduct");
   
   System.out.println(resultMap);
   return resultMap;
 }
  
  @RequestMapping("saveMainProduct.do")
  @ResponseBody
  public Map<String, Object> saveMainProduct(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
    logger.info("+ Start " + className + ".saveMainProduct");
    logger.info("   - paramMap : " + paramMap);
    
    String action = (String) paramMap.get("action");
    
    String result = "SUCCESS";
    String resultMsg = "";
    int saveResult=0;
    
    MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
    
    // file_no 조회
    int file_no = mainProductInfoService.selectFileNo();
    System.out.println("file_no::"+file_no);
    System.out.println("paramMap isFile::"+paramMap.containsKey("isFile"));
    
    String imgPath = mainProductPath + File.separator + file_no + File.separator;
    FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, imgPath);
    Map<String, Object> fileUtilModel = fileUtil.uploadFiles();
    System.out.println("fileUtilModel:::"+fileUtilModel);
    String delimiter = "/";
    String file_ofname = (String) fileUtilModel.get("file_nm");
    String file_local_path = (String) fileUtilModel.get("file_loc");
    String file_size = (String) fileUtilModel.get("file_size");
    String file_relative_path = fileRelativePath + delimiter + mainProductPath + delimiter + file_no + delimiter + file_ofname;
    
    if ("I".equals(action)) {
        System.out.println("paramMap isFile1::"+paramMap.containsKey("isFile"));

       // 첨부파일이 있을 경우
        if(paramMap.containsKey("isFile")) {
          
//          MultipartHttpServletRequest multipartHttpServletRequest = (MultipartHttpServletRequest) request;
//           
//          // file_no 조회
//          int file_no = mainProductInfoService.selectFileNo();
////          int file_no = 23434;
//          System.out.println("file_no::"+file_no);
//          System.out.println("paramMap isFile::"+paramMap.containsKey("isFile"));
//          
//          String imgPath = mainProductPath + File.separator + file_no + File.separator;
//          FileUtilCho fileUtil = new FileUtilCho(multipartHttpServletRequest, rootPath, imgPath);
//          Map<String, Object> fileUtilModel = fileUtil.uploadFiles();
//          System.out.println("fileUtilModel:::"+fileUtilModel);
//          String delimiter = "/";
//          String file_ofname = (String) fileUtilModel.get("file_nm");
//          String file_local_path = (String) fileUtilModel.get("file_loc");
//          String file_size = (String) fileUtilModel.get("file_size");
//          String file_relative_path = fileRelativePath + delimiter + mainProductPath + delimiter + file_no + delimiter + file_ofname;
          
          // DB에 등록할 파일 정보
          paramMap.put("file_no", file_no);
          paramMap.put("file_local_path", file_local_path);
          paramMap.put("file_relative_path", file_relative_path);
          paramMap.put("file_ofname", file_ofname);
          paramMap.put("file_size", file_size);
          System.out.println("product_cd::"+paramMap.get("product_cd"));
          // DB에 파일  등록  
          saveResult = mainProductInfoService.insertMainProduct(paramMap);
          int fileResult = mainProductInfoService.insertFileMainProduct(paramMap);
          
      } 
      else {
         // 등록
         saveResult = mainProductInfoService.insertMainProduct(paramMap);
      }
        
      if (saveResult == 0) {
        result = "FAIL";
        resultMsg = "중복된 코드입니다.";
      } else{
      resultMsg = "등록 완료"; }
    } else if ("U".equals(action)) {
      // 수정
       
       
       if(paramMap.containsKey("noFile")){
          saveResult = mainProductInfoService.updateMainProduct(paramMap);
       } else if(paramMap.containsKey("deleted")) {
             // 기존 첨부파일 삭제  + 글수정
           file_no = Integer.parseInt((String)paramMap.get("file_no"));
             
             
             // 글 업데이트
             int updateResult = mainProductInfoService.updateMainProduct(paramMap);
             // DB에서 파일 삭제
             int deleteResult = mainProductInfoService.deleteFileMainProduct(paramMap);
             
             
             // 물리경로에서 파일 삭제
             fileUtil.deleteFiles(paramMap);
             if(deleteResult == 1) {
               if (file_ofname != null && !"".equals(file_ofname)) {
                 File file = new File(imgPath + file_ofname);
                 File folder = new File(imgPath);
                 if (file.exists()) file.delete();
                 if (folder.exists()) folder.delete();
                 
                 saveResult = 1;
               }
             }
       } 
       
       else if(paramMap.containsKey("modified")|| paramMap.containsKey("added")) { // 첨부파일 수정 + 글수정
             // 첨부파일 신규등록 || 첨부파일 수정
             // 기존 파일 번호
             int formerFileNo = file_no;
             
             // 신규파일 등록을 위한 파일번호
             file_no = mainProductInfoService.selectFileNo();
             
             
             
             // DB에 등록할 파일 정보
             paramMap.put("file_no", file_no);
             paramMap.put("file_local_path", file_local_path);
             paramMap.put("file_relative_path", file_relative_path);
             paramMap.put("file_ofname", file_ofname);
             paramMap.put("file_size", file_size);
             
             // DB에 신규 파일  등록  
             int fileResult = mainProductInfoService.insertFileMainProduct(paramMap);
             
             // 파일 신규 등록에 성공한 경우 공지사항 글 업데이트
             if(fileResult == 1) {
               // 공지사항 정보 업데이트
               saveResult = mainProductInfoService.updateMainProduct(paramMap);
               
               // 기존 파일 삭제
               if(formerFileNo != 0) {
                 //db에서 삭제
                 int deleteResult = mainProductInfoService.deleteFileMainProduct(paramMap);
                 
                 // 물리경로에서 파일 삭제
                 if(deleteResult == 1) {
                   if (file_ofname != null && !"".equals(file_ofname)) {
                     File file = new File(imgPath + file_ofname);
                     File folder = new File(imgPath);
                     if (file.exists()) file.delete();
                     if (folder.exists()) folder.delete();
                     
                     saveResult = 1;
                   }
                 }
               }// 기존 파일 삭제 끝
             }// 파일 신규등록 성공 끝
            }
       
       
       
       
      resultMsg = "수정 완료";
    } else if ("D".equals(action)) {
      // 삭제       
//       if(paramMap.containsKey("file_no")){
          mainProductInfoService.deleteFileMainProduct(paramMap);
//       }
      mainProductInfoService.deleteMainProduct(paramMap);
      resultMsg = "삭제 완료";
    } else {
      result = "FALSE";
      resultMsg = "저장 실패";
    }
    
    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("result", result);
    resultMap.put("resultMsg", resultMsg);
    
    logger.info("+ End " + className + ".saveMainProduct");
    
    return resultMap;
  }
  
 //창고정보 조회
  @RequestMapping("getWarehouseInfo.do")
  @ResponseBody
  public Map<String, Object> getWarehouseInfo(Model model, @RequestParam Map<String, Object> paramMap, 
      HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception{
    
    GetWarehouseModel warehouseInfo = mainProductInfoService.getWarehouseInfo(paramMap);
    
    model.addAttribute("warehouseInfo",warehouseInfo);
 
    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("warehouseInfo", warehouseInfo);
    
    return resultMap;
  }
  
  // 제품 상세정보 조회
  @RequestMapping("mainProductModal.do")
  @ResponseBody
  public Map<String, Object> mainProductModal(Model model, @RequestParam Map<String, Object> paramMap, HttpServletRequest request, HttpServletResponse response, HttpSession session) throws Exception {
    logger.info("+ Start " + className + ".mainProductModal");
    logger.info("   - paramMap : " + paramMap);
    
    String result = "SUCCESS";
    String resultMsg = "조회 되었습니다.";
    
    MainProductModalModel mainProductModalModel = mainProductInfoService.mainProductModal(paramMap);
    
    Map<String, Object> resultMap = new HashMap<String, Object>();
    resultMap.put("result", result);
    resultMap.put("resultMsg", resultMsg);
    resultMap.put("mainProductModalModel", mainProductModalModel);
    
    logger.info("+ End " + className + ".mainProductModal");
    
    System.out.println(resultMap);
    return resultMap;
  }
  

}