package dao;

public class ProjectObj {
private String id, name, createdat, projectleader;

public ProjectObj(String id, String name, String createdat, String projectleader) {
this.id = id;
this.name = name;
this.createdat = createdat;
this.projectleader = projectleader;
}
public String getId() { return this.id; }
public String getName() { return this.name; }
public String getCreatedat() { return this.createdat; }
public String getProjectleader() { return this.projectleader; }
}