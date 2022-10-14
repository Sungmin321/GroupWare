package board;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import dbcon.DBConnPool;

public class BoardDAO extends DBConnPool {
	private static BoardDAO instance = new BoardDAO();

	private BoardDAO() {
		// TODO Auto-generated constructor stub
	}

	public static BoardDAO getInstance() {
		return instance;
	}

	public BoardDAO(String edmsFile) {
		super();
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
		} finally {
			try {
				if (psmt != null)
					psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return result;

	}

	public int updateEdit(BoardVO vo, String idx) {
		int result = 0;

		try {
			String query = "UPDATE BOARD2 SET TITLE = ?, CONTENT = ? WHERE idx = " + idx;

			psmt = con.prepareStatement(query); // ��������
			psmt.setString(1, vo.getTitle());
			psmt.setString(2, vo.getContent());

			result = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (psmt != null)
					psmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		return result;
	}

	public int selectCount(Map<String, Object> map, String cate) {
		int totalCount = 0;

		String query = "SELECT COUNT(*) FROM board2 WHERE cate = " + cate;
		if (map.get("searchWord") != null) {
			query += " AND " + map.get("searchField") + " " + " LIKE '%" + map.get("searchWord") + "%'";
		}

		System.out.println("selectcount 쿼리 : " + query);
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		
		return totalCount;
	}

	public int selectCountFile(Map<String, Object> map, String cate) {
		int totalCount = 0;

		String query = "SELECT COUNT(*) FROM board2 b, userinfo u " + " WHERE b.user_code = u.user_code"
				+ " AND cate = " + cate;
		if (map.get("searchWord") != null) {
			query += " AND " + map.get("searchField") + " " + " LIKE '%" + map.get("searchWord") + "%'";
		}

//		System.out.println("selectcountFile 쿼리 : "+query);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			rs.next();
			totalCount = rs.getInt(1);
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		return totalCount;
	}

	public List<BoardVO> selectListPage(Map<String, Object> map, String cate) {
		List<BoardVO> bbs = new Vector<BoardVO>();

		String query = "SELECT * FROM ( " + "	SELECT Tb.*, rownum  rNum, TO_CHAR(postdate, 'yyyy-mm-dd') FROM ( "
				+ " 	SELECT * FROM BOARD2 WHERE cate = " + cate;

		if (map.get("searchWord") != null) {
			query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%' ";
		}

		query += " ORDER BY idx DESC " + " ) Tb " + " ) " + " WHERE rNum BETWEEN ? AND ?";

		System.out.println("selectListpage 쿼리 : " + query);
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
		} finally {
			try {
				if (psmt != null)
					psmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return bbs;
	}

	public List<BoardVO> selectList(Map<String, Object> map, String cate) {
		List<BoardVO> bbs = new Vector<BoardVO>();

		String query = "SELECT idx, cate, b.user_code, title, content, TO_CHAR(postdate, 'yyyy-mm-dd'), visitcount, user_name"
				+ " FROM board2 b, userinfo u" + " WHERE b.user_code = u.user_code" + " AND cate = " + cate;

		if (map.get("searchWord") != null) {
			query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%' ";
		}

		query += " ORDER BY idx DESC ";

//		System.out.println(query);

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				BoardVO vo = new BoardVO();

				vo.setIdx(rs.getString("idx"));
				vo.setCate(rs.getString("cate"));
				vo.setUsercode(rs.getString("user_code"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setPostdate(rs.getString(6));
				vo.setVisitcount(rs.getString("visitcount"));

				vo.setUser_name(rs.getString("user_name"));

				bbs.add(vo);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return bbs;
	}

	public List<BoardVO> selectListPage(String cate) {
		List<BoardVO> bbs = new Vector<BoardVO>();

		String query = "SELECT * FROM ( " + "	SELECT Tb.*, rownum  rNum , TO_CHAR(postdate, 'yyyy-mm-dd') FROM ( "
				+ "	SELECT * FROM BOARD2 WHERE cate = " + cate + "  ORDER BY idx desc ) " + "	Tb  ) "
				+ "WHERE rNum BETWEEN 1 AND 5";

		System.out.println("selectListpage 메인화면용 쿼리 : " + query);
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
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return bbs;
	}

	public BoardVO selectView(int idx) {
		BoardVO vo = new BoardVO();

		String query = "SELECT idx, cate, b.user_code, title, content, TO_CHAR(postdate, 'yyyy-mm-dd'), visitcount, user_name"
				+ " FROM board2 b, userinfo u" + " WHERE b.user_code = u.user_code" + " AND idx = " + idx;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				vo.setIdx(rs.getString("idx"));
				vo.setCate(rs.getString("cate"));
				vo.setUsercode(rs.getString("user_code"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setPostdate(rs.getString(6));
				vo.setVisitcount(rs.getString("visitcount"));

				vo.setUser_name(rs.getString("user_name"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return vo;
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
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return name;
	}

	public int getLastIdx() {
		int result = 0;

		String query = "SELECT idx FROM board2 ORDER BY idx DESC";

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				result = rs.getInt("idx");
				break;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		return result;
	}

	public int getIdx(BoardVO vo) { // idx 값 가져오기.
		int idx = 0;
		String query = "SELECT idx FROM BOARD2 b  WHERE b.USER_CODE = ? AND b.CATE = ? AND b.title = ? AND b.CONTENT = ?";

		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, vo.getUsercode());
			psmt.setString(2, vo.getCate());
			psmt.setString(3, vo.getTitle());
			psmt.setString(4, vo.getContent());

			rs = psmt.executeQuery();
//			System.out.println(rs);
			rs.next();
			idx = rs.getInt(1);

		} catch (SQLException e) {
			// TODO: handle exception
			e.printStackTrace();
		} finally {
			try {
				if (psmt != null)
					psmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return idx;
	}

	public BoardVO ViewBoard(String idx) {
		updateVisitCount(idx);
		BoardVO vo = new BoardVO();

		String query = "SELECT idx, USER_NAME , b.USER_CODE , TITLE , CONTENT , TO_CHAR(POSTDATE, 'yyyy-mm-dd') , VISITCOUNT "
				+ " FROM USERINFO u , BOARD2 b " + " WHERE idx = " + idx;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

			while (rs.next()) {
				vo.setIdx(rs.getString(1));
				vo.setName(rs.getString(2));
				vo.setUsercode(rs.getString(3));
				vo.setTitle(rs.getString(4));
				vo.setContent(rs.getString(5));
				vo.setPostdate(rs.getString(6));
				vo.setVisitcount(rs.getString(7));
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}

		return vo;
	}

	public void updateVisitCount(int idx) {
		String query = "UPDATE board2" + " SET visitcount = visitcount + 1" + " WHERE idx = " + idx;

		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);

		} catch (Exception e) {
			System.out.println("게시물 조회수 증가 중 예외 발생");
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
				if (rs != null)
					rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
	}

	public void updateVisitCount(String idx) {
		String query = "UPDATE BOARD2 SET VISITCOUNT = VISITCOUNT + 1 WHERE idx = " + idx;

		try {
			stmt = con.createStatement();
			stmt.execute(query);
			System.out.println("조회수 증가");

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
	}

	public int deletePost(String idx) {
		int result = 0;

		try {
			String query = "DELETE FROM board2 WHERE idx=" + idx;

			stmt = con.createStatement();
			result = stmt.executeUpdate(query);

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			try {
				if (stmt != null)
					stmt.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}

		}
		return result;
	}

}
