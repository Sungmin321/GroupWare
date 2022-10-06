package attachedfile;

import dbcon.DBConnPool;

public class AttachedFileDAO extends DBConnPool {
	public AttachedFileDAO() {
		super();
	}
	
	public AttachedFileVO selectView(int idx) {
		AttachedFileVO vo = new AttachedFileVO();
		
		String query = "SELECT * FROM attachedfile"
				+ " WHERE idx=?";
		
		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, idx);
			
			rs = psmt.executeQuery();
			
			while(rs.next()) {
				vo.setIdx(rs.getInt("idx"));
				vo.setOfile(rs.getString("ofile"));
				vo.setSfile(rs.getString("sfile"));
				vo.setPostdate(rs.getDate("postdate"));
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return vo;
	}

	public int inputFile(AttachedFileVO vo) {
		int result = 0;
		
		String query = "INSERT INTO attachedfile (idx, ofile, sfile, postdate)"
				+ " VALUES (?, ?, ?, sysdate)";

		try {
			psmt = con.prepareStatement(query);
			psmt.setInt(1, vo.getIdx());
			psmt.setString(2, vo.getOfile());
			psmt.setString(3, vo.getSfile());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public int update(AttachedFileVO vo) {
		int result = 0;
		
		String query = "UPDATE attachedfile"
				+ " SET ofile=?, sfile=?, postdate=SYSDATE"
				+ " WHERE idx=?";
		
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setString(1, vo.getOfile());
			psmt.setString(2, vo.getSfile());
			psmt.setInt(3, vo.getIdx());
			
			result = psmt.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public int delete(int idx) {
		int result = 0;
		
		String query = "DELETE FROM attachedfile"
				+ " WHERE idx=?";
		try {
			psmt = con.prepareStatement(query);
			
			psmt.setInt(1, idx);
			
			result = psmt.executeUpdate();
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return result; 
	}
}
