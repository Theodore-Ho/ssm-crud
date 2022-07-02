import com.example.crud.bean.Department;
import com.example.crud.bean.Employee;
import com.example.crud.dao.DepartmentMapper;
import com.example.crud.dao.EmployeeMapper;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

import static org.junit.Assert.assertNotNull;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = {"classpath:applicationContext.xml"})
public class MapperTest {

    @Autowired
    DepartmentMapper departmentMapper;

    @Autowired
    EmployeeMapper employeeMapper;

    @Autowired
    SqlSession sqlSession;

    @Test
    public void testConnect() {
        assertNotNull(departmentMapper);
    }

    @Test
    public void testInsertDept() {
        departmentMapper.insertSelective(new Department(null, "sem"));
        departmentMapper.insertSelective(new Department(null, "display"));
    }

    @Test
    public void testInsertEmployee() {
        employeeMapper.insertSelective(new Employee(null, "Alex", "M", "alex@gmail.com", 3));
        employeeMapper.insertSelective(new Employee(null, "Bobby", "M", "bobby@gmail.com", 4));
    }

    @Test
    public void testSqlSession() {
        EmployeeMapper mapper = sqlSession.getMapper(EmployeeMapper.class);
        for(int i = 0; i < 200; i++){
            String uid = UUID.randomUUID().toString().substring(0, 5) + i;
            mapper.insert(new Employee(null, uid, "M", "example@gmail.com", 3));
        }
    }

}
