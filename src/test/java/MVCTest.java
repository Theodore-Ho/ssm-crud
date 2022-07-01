import com.example.crud.bean.Employee;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations = {"classpath:applicationContext.xml","file:src/main/webapp/WEB-INF/dispatcherServlet-servlet.xml"})
public class MVCTest {

    @Autowired
    WebApplicationContext context;

    MockMvc mockMvc;

    @Before
    public void initMockMVC() {
        mockMvc = MockMvcBuilders.webAppContextSetup(context).build();
    }

    @Test
    public void testPage() throws Exception {
        MvcResult result = mockMvc.perform(MockMvcRequestBuilders.get("/emps").param("pn", "8")).andReturn();
        MockHttpServletRequest request = result.getRequest();
        PageInfo attribute = (PageInfo) request.getAttribute("pageInfo");
        System.out.println("current page number: " + attribute.getPageNum());
        System.out.println("total page number: " + attribute.getPages());
        System.out.println("total data number: " + attribute.getTotal());
        System.out.println("pages displayed number: ");
        int[] nums = attribute.getNavigatepageNums();
        for(int i : nums){
            System.out.print(i + " ");
        }
        System.out.println("");
        List<Employee> list = attribute.getList();
        for(Employee i : list){
            System.out.println("ID: " + i.getEmpId() + ", Name: " + i.getEmpName());
        }
    }

}
