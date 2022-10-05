package edms;

public class EdmsInfoVO {

	String name;
	String code;
	String deptkr;
	String poskr;
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getDeptkr() {
		return deptkr;
	}

	public void setDeptkr(String deptkr) {
		this.deptkr = deptkr;
	}

	public String getPoskr() {
		return poskr;
	}

	public void setPoskr(String poskr) {
		this.poskr = poskr;
	}

	public EdmsInfoVO() {
	}
	
	public EdmsInfoVO(String name, String deptkr, String poskr) {
		super();
		this.name = name;
		this.deptkr = deptkr;
		this.poskr = poskr;
	}
	
	public EdmsInfoVO(String name, String code, String deptkr, String poskr) {
		super();
		this.name = name;
		this.code = code;
		this.deptkr = deptkr;
		this.poskr = poskr;
	}
	@Override
	public String toString() {
		return "EdmsInfoVO [name=" + name + ", code=" + code + ", deptkr=" + deptkr + ", poskr=" + poskr + "]";
	}
	
}
