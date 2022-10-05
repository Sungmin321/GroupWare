package edms;

import java.sql.SQLException;
import java.util.ArrayList;

import dbcon.DBConnPool;

public class EdmsDAO extends DBConnPool {
	private static EdmsDAO instance = new EdmsDAO();;
	
	private EdmsDAO() {
	}
	
	public static EdmsDAO getInstance() {
		return instance;
	}
	
	public ArrayList<EdmsInfoVO> findList(){
		ArrayList<EdmsInfoVO> list = new ArrayList<EdmsInfoVO>();
		
		String query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
				+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
				+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID\r\n"
				+ "ORDER BY u.POS_ID ";
		
		System.out.println(query);
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				EdmsInfoVO vo = new EdmsInfoVO();
				vo.setName(rs.getString(1)); //이름
				vo.setCode(Integer.toString(rs.getInt(2))); // 사원코드
				vo.setDeptkr(rs.getString(3)); //부서
				vo.setPoskr(rs.getString(4)); //직위
				System.out.println(vo);
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public ArrayList<EdmsInfoVO> findList(String cate, String searchWord){
		ArrayList<EdmsInfoVO> list = new ArrayList<EdmsInfoVO>();
		String query = "";
		switch (cate) {
		case "name" :
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND u.USER_NAME LIKE '%"+ searchWord +"%'";
			break;
		case "dept" :
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND d.DEPT_NAME_KOR  LIKE '%"+ searchWord +"%'";
			break;
		case "pos" :
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND j.POS_NAME_KOR  LIKE '%"+ searchWord +"%'";
			break;
		}
		
		System.out.println(query);
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				EdmsInfoVO vo = new EdmsInfoVO();
				vo.setName(rs.getString(1)); //이름
				vo.setCode(Integer.toString(rs.getInt(2))); // 사원코드
				vo.setDeptkr(rs.getString(3)); //부서
				vo.setPoskr(rs.getString(4)); //직위
				System.out.println(vo+" 검색 된 정보 ");
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
	
	public int insertEdms(EdmsVO eiv) {
		int result = 0;
		String query = "INSERT INTO edms(IDX, USER_CODE, TITLE, STATUS, LINE, CONFIRMED, DOCTYPE, CONTENT)"
				+ " VALUES(gw_seq.NEXTVAL, ?, ?, '1', ?, ?, ?, ?)";		
		
		System.out.println(query);
		try {
			psmt = con.prepareStatement(query);
//			System.out.println(eiv.getUser_code());
//			System.out.println(eiv.getTitle());
//			System.out.println(eiv.getLine());
//			System.out.println(eiv.getConfirmed());
//			System.out.println(eiv.getDoctype());
//			System.out.println(eiv.getContent());
			
			psmt.setString(1, eiv.getUser_code());
			psmt.setString(2, eiv.getTitle());
			psmt.setString(3, eiv.getLine());
			psmt.setString(4, eiv.getConfirmed());
			psmt.setString(5, eiv.getDoctype());
			psmt.setString(6, eiv.getContent());
			// ?에 들어갈 값을 세팅 한 후
			
			System.out.println(query);
			result = psmt.executeUpdate(); //쿼리실행, 
			System.out.println("생성된 데이터 : "+result+"행");
		}catch(SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public int getIdx(EdmsVO eiv) { //idx 값 가져오기.
		int idx = 0;
		String query = "SELECT idx FROM edms WHERE USER_CODE = ? AND title = ? AND LINE = ? AND CONFIRMED = ? AND DOCTYPE = ? AND CONTENT = ?";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, eiv.getUser_code());
			psmt.setString(2, eiv.getTitle());
			psmt.setString(3, eiv.getLine());
			psmt.setString(4, eiv.getConfirmed());
			psmt.setString(5, eiv.getDoctype());
			psmt.setString(6, eiv.getContent());
			
			rs = psmt.executeQuery();
			System.out.println(rs);
			rs.next();
			idx = rs.getInt(1);
			
		}catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		return idx;
	}
}
