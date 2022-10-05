package mail;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import dbcon.DBConnPool;

public class MailDAO extends DBConnPool{
	public MailDAO() {
		super();
	}
	
//	public List<MailVO> selectList(Map<String, Object> map){
	public List<MailVO> findAll(Map<String, Object> map){
		List<MailVO> list = new ArrayList<MailVO>();
		
		String query = "SELECT m.*, u.USER_NAME FROM mail m, userinfo u"
				+ " WHERE u.USER_CODE = m.SENDER";
		
		String user_code = String.valueOf(map.get("user_code"));
		
		int tmp = Integer.parseInt(String.valueOf(map.get("status"))) % 10;
		String status = String.valueOf(tmp);
		
//		System.out.println(status);
		
		if(status.equals("2")) { // 받은메일함
			query += " AND status >= 1 AND status <= ?"
					+ " AND recipients LIKE '%" + user_code + "%'";
			if(map.get("searchWord") != null) {
				query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%'";
			}
			query += " ORDER BY status, idx DESC";
			
		}else if(status.equals("3") || status.equals("4")) { // 보낸메일함, 임시보관함
			query += " AND status = ?" 
					+ " AND sender = '" + user_code + "'";
			if (map.get("searchWord") != null) {
				query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%'";
			}
			query += " ORDER BY idx DESC";

		} else if (status.equals("5")) { // 휴지통
			query += " AND status = ?" 
					+ " AND (sender = '" + user_code + "' OR recipients LIKE '%" + user_code + "%')";
			if (map.get("searchWord") != null) {
				query += " AND " + map.get("searchField") + " LIKE '%" + map.get("searchWord") + "%'";
			}
			query += " ORDER BY idx DESC";

		}
		
//		System.out.println(query);
		
		try{
			psmt = con.prepareStatement(query);
			psmt.setString(1, status);
			rs = psmt.executeQuery();
			
//			System.out.println(query);
			
			while(rs.next()) {
				MailVO vo = new MailVO();
				
				vo.setIdx(rs.getInt("idx"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setStatus(rs.getInt("status"));
				vo.setSenddate(rs.getDate("senddate"));
				vo.setSender(rs.getString("sender"));
				vo.setCheckdate(rs.getDate("checkdate"));
				vo.setRecipients(rs.getString("recipients"));
				vo.setUser_name(rs.getString("user_name"));
				
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
			
		return list;
	}
	
	public MailVO selectView(int idx) {
		MailVO vo = new MailVO();
		
		String query = "SELECT m.*, u.USER_NAME FROM mail m, userinfo u"
				+ " WHERE u.USER_CODE = m.SENDER"
				+ " AND idx=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, idx);
			rs = psmt.executeQuery();
			
			if(rs.next()) {
				vo.setIdx(rs.getInt("idx"));
				vo.setTitle(rs.getString("title"));
				vo.setContent(rs.getString("content"));
				vo.setStatus(rs.getInt("status"));
				vo.setSenddate(rs.getDate("senddate"));
				vo.setSender(rs.getString("sender"));
				vo.setCheckdate(rs.getDate("checkdate"));
				vo.setRecipients(rs.getString("recipients"));
				
				vo.setUser_name(rs.getString("user_name"));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return vo;
	}
	
	public int getFileIdx(){
		int result = 0;
		
		String query = "SELECT idx FROM mail ORDER BY idx DESC";
		
		try {
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				result = rs.getInt("idx");
				break;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int inputMail(MailVO vo) {
		int result = 0;
		
		String query = "INSERT INTO mail(idx, title, content, status, senddate, sender, recipients)"
				+ " VALUES(gw_seq.NEXTVAL, ?, ?, ?, sysdate, ?, ?)";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, vo.getTitle());
			psmt.setString(2, vo.getContent());
			psmt.setInt(3, vo.getStatus());
			psmt.setString(4, vo.getSender());
			psmt.setString(5, vo.getRecipients());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public int inputMailContentNull(MailVO vo) {
		int result = 0;
		
		String query = "INSERT INTO mail(idx, title, status, senddate, sender, recipients)"
				+ " VALUES(gw_seq.NEXTVAL, ?, ?, sysdate, ?, ?)";
		
//		System.out.println(query);
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, vo.getTitle());
			psmt.setInt(2, vo.getStatus());
			psmt.setString(3, vo.getSender());
			psmt.setString(4, vo.getRecipients());
			
//			System.out.println(query);

			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public int update(MailVO vo) {
		int result = 0;
		
		String query = "UPDATE mail"
				+ " SET title=?, content=? status=?, senddate=SYSDATE, sender=?, recipients=?"
				+ " WHERE idx=?";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, vo.getTitle());
			psmt.setString(2, vo.getContent());
			psmt.setInt(3, vo.getStatus());
			psmt.setString(4, vo.getSender());
			psmt.setString(5, vo.getRecipients());
			psmt.setInt(6, vo.getIdx());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int updateContentNull(MailVO vo) {
		int result = 0;
		
		String query = "UPDATE mail"
				+ " SET title=?, status=?, senddate=SYSDATE, sender=?, recipients=?"
				+ " WHERE idx=?";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, vo.getTitle());
			psmt.setInt(2, vo.getStatus());
			psmt.setString(3, vo.getSender());
			psmt.setString(4, vo.getRecipients());
			psmt.setInt(5, vo.getIdx());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
}