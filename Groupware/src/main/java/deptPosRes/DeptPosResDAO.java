package deptPosRes;

import java.util.ArrayList;
import java.util.List;

import dbcon.DBConnPool;

public class DeptPosResDAO extends DBConnPool{
	public DeptPosResDAO() {
		super();
	}
	
	public List<DeptPosResVO> selectList(String tableName){
		List<DeptPosResVO> list = new ArrayList<DeptPosResVO>();
		
		String query = "SELECT * from " + tableName;
		
		try{
			stmt = con.createStatement();
			rs = stmt.executeQuery(query);
			
			while(rs.next()) {
				DeptPosResVO vo = new DeptPosResVO();
				
				vo.setId(rs.getInt(1));
				vo.setName(rs.getString(2));
				vo.setName_kor(rs.getString(3));
				
				list.add(vo);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}
		
		return list;
	}
}
