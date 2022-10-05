package edms;

import java.sql.SQLException;
import java.util.ArrayList;

import org.apache.catalina.tribes.util.Arrays;

import dbcon.DBConnPool;

public class EdmsDAO extends DBConnPool {
	private static EdmsDAO instance = new EdmsDAO();;

	private EdmsDAO() {
	}

	public static EdmsDAO getInstance() {
		return instance;
	}

	public ArrayList<EdmsInfoVO> findList() {
		ArrayList<EdmsInfoVO> list = new ArrayList<EdmsInfoVO>();

		String query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
				+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
				+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID\r\n" + "ORDER BY u.POS_ID ";

		System.out.println(query);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				EdmsInfoVO vo = new EdmsInfoVO();
				vo.setName(rs.getString(1)); // 이름
				vo.setCode(Integer.toString(rs.getInt(2))); // 사원코드
				vo.setDeptkr(rs.getString(3)); // 부서
				vo.setPoskr(rs.getString(4)); // 직위
//				System.out.println(vo);
				list.add(vo);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public ArrayList<EdmsInfoVO> findList(String cate, String searchWord) {
		ArrayList<EdmsInfoVO> list = new ArrayList<EdmsInfoVO>();
		String query = "";
		switch (cate) {
		case "name":
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND u.USER_NAME LIKE '%" + searchWord
					+ "%'";
			break;
		case "dept":
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND d.DEPT_NAME_KOR  LIKE '%" + searchWord
					+ "%'";
			break;
		case "pos":
			query = "SELECT USER_NAME , USER_CODE , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
					+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
					+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND j.POS_NAME_KOR  LIKE '%" + searchWord
					+ "%'";
			break;
		}

		System.out.println(query);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				EdmsInfoVO vo = new EdmsInfoVO();
				vo.setName(rs.getString(1)); // 이름
				vo.setCode(Integer.toString(rs.getInt(2))); // 사원코드
				vo.setDeptkr(rs.getString(3)); // 부서
				vo.setPoskr(rs.getString(4)); // 직위
//				System.out.println(vo + " 검색 된 정보 ");
				list.add(vo);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public ArrayList<EdmsInfoVO> findList(String codes[]) {
		ArrayList<EdmsInfoVO> list = new ArrayList<EdmsInfoVO>();

		String query = "";

		try {
			stmt = con.createStatement();

			for (int i = 0; i < codes.length; i++) {
				query = "SELECT USER_NAME , d.DEPT_NAME_KOR, j.POS_NAME_KOR  \r\n"
						+ "FROM USERINFO u, DEPARTMENT2 d, JOBPOSITION j  \r\n"
						+ "WHERE u.DEPT_ID  = d.DEPT_ID AND u.POS_ID = j.POS_ID  AND u.USER_CODE LIKE " + codes[i];
				rs = stmt.executeQuery(query);

				while (rs.next()) {
					EdmsInfoVO vo = new EdmsInfoVO();
					vo.setName(rs.getString(1)); // 이름
					vo.setDeptkr(rs.getString(2)); // 부서
					vo.setPoskr(rs.getString(3)); // 직위
					list.add(vo);
				}

			}

		} catch (Exception e) {
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

//			System.out.println(query);
			result = psmt.executeUpdate(); // 쿼리실행,
			System.out.println("생성된 데이터 : " + result + "행");

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return result;
	}

	public int getIdx(EdmsVO eiv) { // idx 값 가져오기.
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
//			System.out.println(rs);
			rs.next();
			idx = rs.getInt(1);

		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		}

		return idx;
	}

	public ArrayList<EdmsVO> getListAll() {
		ArrayList<EdmsVO> list = new ArrayList<EdmsVO>();

		String query = "SELECT IDX , TITLE , USER_CODE , DOCTYPE , TO_CHAR(POSTDATE, 'yyyy-mm-dd'), STATUS , TO_CHAR(LASTCONFIRMDATE, 'yyyy-mm-dd') FROM EDMS e ORDER BY IDX DESC";

		System.out.println(query);
		// 번호 제목 기안자 문서유형 기안일 결재상태 기안완료일
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				EdmsVO VO = new EdmsVO();
				VO.setIdx(rs.getString(1));// idx
				VO.setTitle(rs.getString(2));// 제목
				VO.setUser_code(rs.getString(3));// 사번
				VO.setDoctype(rs.getString(4));// 문서유형
				VO.setPostdate(rs.getString(5));// 작성일자
				VO.setStatus(rs.getString(6));// 문서상태
				VO.setLastdate(rs.getString(7)); // 완료일자
				list.add(VO);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public ArrayList<EdmsVO> getApprovalWaitingList(String user_code) {
		ArrayList<EdmsVO> list = new ArrayList<EdmsVO>();

		String query = "SELECT LINE , CONFIRMED , IDX , TITLE , USER_CODE , DOCTYPE , TO_CHAR(POSTDATE, 'yyyy-mm-dd'), STATUS , TO_CHAR(LASTCONFIRMDATE, 'yyyy-mm-dd') FROM EDMS e WHERE STATUS = 1 ORDER BY IDX DESC";

		System.out.println(query);
		// 번호 제목 기안자 문서유형 기안일 결재상태 기안완료일
		// status가 1인 것만 불러오기.

		try {
			stmt = con.createStatement();

			rs = stmt.executeQuery(query);

			while (rs.next()) {
				boolean flag = false;
//				System.out.println(flag);
				String codes[] = rs.getString(1).split("/");
				String confirmeds[] = rs.getString(2).split("/");
//				System.out.println(Arrays.toString(codes));
//				System.out.println(Arrays.toString(confirmeds));

				for (int i = codes.length - 1; i >= 0; i--) {
					// 미결재상태와 usercode가 만족하는 사람.
					// System.out.println("confirmeds : "+confirmeds[i]);
					// System.out.println("codes : "+codes[i]);
					// System.out.println("user_code : "+user_code);
					if (confirmeds[i].equals("1") && codes[i].equals(user_code)) {
						System.out.println("승인대기 게시물 : true");
						flag = true;
						// flag를 true로 바꾸고 for문을 나와라.
						break;
					}

				}
//				System.out.println(flag);
				if (flag) {
					EdmsVO VO = new EdmsVO();
					VO.setLine(rs.getString(1));
					VO.setConfirmed(rs.getString(2));
					VO.setIdx(rs.getString(3));// idx
					VO.setTitle(rs.getString(4));// 제목
					VO.setUser_code(rs.getString(5));// 사번
					VO.setDoctype(rs.getString(6));// 문서유형
					VO.setPostdate(rs.getString(7));// 작성일자
					VO.setStatus(rs.getString(8));// 문서상태
					VO.setLastdate(rs.getString(9)); // 완료일자
					list.add(VO);
				}

			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public int updateApprovalConfirmed(String user_code, String idx) {
		int result = 0;

		String query = "SELECT LINE , CONFIRMED  FROM EDMS e WHERE idx = " + idx;

		System.out.println(query);
		// 결재권자, 결재상태 받아오기.

		try {
			stmt = con.createStatement();

			rs = stmt.executeQuery(query);

			rs.next(); // rs 결과물을 받아서
			
			String codes[] = rs.getString(1).split("/"); // String[]로 받아서
			String confirmeds[] = rs.getString(2).split("/");
			
			System.out.println(Arrays.toString(codes));
			System.out.println(Arrays.toString(confirmeds));

			for (int i = codes.length - 1; i >= 0; i--) {
				if (confirmeds[i].equals("1") && codes[i].equals(user_code)) { // 상태가 1이고 usercode가 같은게 있다면 2로 변경.
					confirmeds[i] = "2";
					System.out.println("승인 완료 confirmeds["+i+"] : "+confirmeds[i]);
				}
			}
			
			String confirmed = "";
			
			for(int i=0; i<confirmeds.length; i++) {
				confirmed += confirmeds[i]+"/";
			}
			
			confirmed = confirmed.substring(0,confirmed.length()-1);
			System.out.println(confirmed);
			
			query = "UPDATE EDMS SET CONFIRMED = '"+confirmed+"' WHERE idx = "+idx;
			System.out.println("[[수정 쿼리 : "+query+"]]");
			
			result = stmt.executeUpdate(query); // 업데이트 !! 
			
			if (confirmed.indexOf("1")==-1){
				//1이 없으면 -1이 나옴.
				System.out.println(confirmed);
				query = "UPDATE EDMS SET STATUS = 2 WHERE idx = "+idx;
				System.out.println("전체승인 확인 후 status -> 2로 바꾸는 쿼리 실행");
				stmt.executeUpdate(query); // 업데이트 !! 
			}
				
			
			// 그리고 confirmed를 다 돌면서 3이 없고 2만 있으면 status를 2나 3으로 바꿈.
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

	public int updateReferConfirmed(String user_code, String idx) {
		int result = 0;
		
		String query = "SELECT LINE , CONFIRMED  FROM EDMS e WHERE idx = " + idx;
		
		System.out.println(query);
		// 결재권자, 결재상태 받아오기.
		
		try {
			stmt = con.createStatement();
			
			rs = stmt.executeQuery(query);
			
			rs.next(); // rs 결과물을 받아서
			
			String codes[] = rs.getString(1).split("/"); // String[]로 받아서
			String confirmeds[] = rs.getString(2).split("/");
			
			System.out.println(Arrays.toString(codes));
			System.out.println(Arrays.toString(confirmeds));
			
			for (int i = codes.length - 1; i >= 0; i--) {
				if (confirmeds[i].equals("1") && codes[i].equals(user_code)) { // 상태가 1이고 usercode가 같은게 있다면 2로 변경.
					confirmeds[i] = "3";
					System.out.println("반려 완료 confirmeds["+i+"] : "+confirmeds[i]);
				}
			}
			
			String confirmed = "";
			
			for(int i=0; i<confirmeds.length; i++) {
				confirmed += confirmeds[i]+"/";
			}
			
			confirmed = confirmed.substring(0,confirmed.length()-1);
			System.out.println(confirmed);
			
			query = "UPDATE EDMS SET CONFIRMED = '"+confirmed+"' WHERE idx = "+idx;
			System.out.println("[[수정 쿼리 : "+query+"]]");
			
			result = stmt.executeUpdate(query); // 업데이트 !! 
			
			if (confirmed.indexOf("3")>=0){
				//1이 없으면 -1이 나옴.
				System.out.println(confirmed);
				query = "UPDATE EDMS SET STATUS = 3 WHERE idx = "+idx;
				System.out.println("전체승인 확인 후 status -> 3로 바꾸는 쿼리 실행");
				stmt.executeUpdate(query); // 업데이트 !! 
			}
			
			
			// 그리고 confirmed를 다 돌면서 3이 없고 2만 있으면 status를 2나 3으로 바꿈.
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public String getName(String user_code) {
		String name = "";

		String query = "SELECT USER_NAME FROM USERINFO u WHERE USER_CODE = " + user_code;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				name = rs.getString(1);
			}
//			System.out.println(name);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return name;
	}

	public EdmsVO viewEdms(String idx) {
		EdmsVO evo = new EdmsVO();

		String query = "SELECT USER_CODE , TITLE , TO_CHAR(POSTDATE, 'yyyy-mm-dd'), TO_CHAR(LASTCONFIRMDATE, 'yyyy-mm-dd'), STATUS , DOCTYPE , CONTENT , LINE , CONFIRMED  FROM EDMS e WHERE IDX = "
				+ idx;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				evo.setUser_code(rs.getString(1));
				evo.setTitle(rs.getString(2));
				evo.setPostdate(rs.getString(3));
				evo.setLastdate(rs.getString(4));
				evo.setStatus(rs.getString(5));
				evo.setDoctype(rs.getString(6));
				evo.setContent(rs.getString(7));
				evo.setLine(rs.getString(8));
				evo.setConfirmed(rs.getString(9));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return evo;
	}

}
