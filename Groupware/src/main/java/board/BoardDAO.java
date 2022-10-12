package board;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import dbcon.DBConnPool;

public class BoardDAO extends DBConnPool{
	private static BoardDAO instance = new BoardDAO();
	
	private BoardDAO() {
		// TODO Auto-generated constructor stub
	}
	
	public static BoardDAO getInstance () {
		return instance;
	}
	
	public int insertWrite(BoardVO vo) {
		int result = 0;

		try {
			String query = "INSERT INTO BOARD2 VALUES (gw_seq.NEXTVAL, ?, ?, ?, ?, sysdate, 0)";

			psmt = con.prepareStatement(query); // ��������
			psmt.setString(1, vo.getCate());
			psmt.setString(2, vo.getUsercode());
			psmt.setString(3, vo.getTitle());
			psmt.setString(4, vo.getContent());

			result = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;

	}
	
	public int selectCount(Map<String, Object> map, String cate) {
		int totalCount = 0;

		String query = "SELECT COUNT(*) FROM board2 WHERE cate = "+cate;
		if (map.get("searchWord") != null) {
			query += " AND "+map.get("searchField") + " " + " LIKE '%" + map.get("searchWord") + "%'";
		}
		
		System.out.println("selectcount 쿼리 : "+query);
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return totalCount;
	}

	public List<BoardVO> selectListPage(Map<String, Object> map, String cate) {
		List<BoardVO> bbs = new Vector<BoardVO>();
		
		String query = "SELECT * FROM ( "
				+"	SELECT Tb.*, rownum  rNum, TO_CHAR(postdate, 'yyyy-mm-dd') FROM ( "
				+" 	SELECT * FROM BOARD2 WHERE cate = "+cate;
		
		if (map.get("searchWord") != null) {
			query += " AND "+ map.get("searchField")
			+ " LIKE '%" + map.get("searchWord") + "%' ";
		}
		
		query += " ORDER BY idx DESC "
				+ " ) Tb "
				+ " ) "
				+ " WHERE rNum BETWEEN ? AND ?";
		
		System.out.println("selectListpage 쿼리 : "+query);
		try {
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, map.get("start").toString());
			psmt.setString(2, map.get("end").toString());
			
			rs = psmt.executeQuery();

			while (rs.next()) {
				BoardVO vo = new BoardVO();
				
				vo.setIdx(rs.getString("idx"));
				vo.setNumber(rs.getString("rnum"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setUsercode(rs.getString("user_code"));
				vo.setVisitcount(rs.getString("visitcount"));
				vo.setPostdate(rs.getString(9));

				bbs.add(vo);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return bbs;
	}
	
	public List<BoardVO> selectListPage(String cate) {
		List<BoardVO> bbs = new Vector<BoardVO>();
		
		String query = "SELECT * FROM ( "
				+ "	SELECT Tb.*, rownum  rNum , TO_CHAR(postdate, 'yyyy-mm-dd') FROM ( "
				+ "	SELECT * FROM BOARD2 WHERE cate = "+cate+"  ORDER BY idx desc ) "
				+ "	Tb  ) "
				+ "WHERE rNum BETWEEN 1 AND 5";
		
		System.out.println("selectListpage 메인화면용 쿼리 : "+query);
		try {
			
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				BoardVO vo = new BoardVO();
				
				vo.setIdx(rs.getString("idx"));
				vo.setNumber(rs.getString("rnum"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setUsercode(rs.getString("user_code"));
				vo.setVisitcount(rs.getString("visitcount"));
				vo.setPostdate(rs.getString(9));
				
				bbs.add(vo);
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return bbs;
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

}
