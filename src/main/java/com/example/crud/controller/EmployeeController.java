package com.example.crud.controller;

import com.example.crud.bean.Employee;
import com.example.crud.bean.Msg;
import com.example.crud.service.EmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn,
                               @RequestParam(value = "rows", defaultValue = "5") Integer rows,
                               Model model) {
        PageHelper.startPage(pn, rows);
        List<Employee> emps = employeeService.getAll();
        PageInfo page = new PageInfo(emps, 5);
        return Msg.success().add("pageInfo", page);
    }

    @RequestMapping(value="/emps", method = RequestMethod.POST)
    @ResponseBody
    public Msg saveEmp(@Valid Employee employee, BindingResult bindingResult) {
        if(bindingResult.hasErrors()){
            /* tutorial not work when display information at frontend,
               but can receive the json response with error code 200 */
//            Map<Object, String> map = new HashMap<>();
//            List<FieldError> fieldErrors = bindingResult.getFieldErrors();
//            for(FieldError e : fieldErrors){
//                map.put(e.getField(), e.getDefaultMessage());
//            }
            FieldError fieldError = bindingResult.getFieldError();
            assert fieldError != null;
            if(fieldError.getField().equals("empName")){
                return Msg.fail().add("backEndValidateError", "empName");
            } else {
                return Msg.fail().add("backEndValidateError", "email");
            }
        } else {
            employeeService.saveEmp(employee);
            return Msg.success();
        }
    }

    @RequestMapping(value="/checkuser")
    @ResponseBody
    public Msg checkUser(@RequestParam("empName") String empName) {
        String regx = "(^[a-zA-Z0-9_-]{6,16}$)|(^[\\u2E80-\\u9FFF]{2,5})";
        if(!empName.matches(regx)){
            return Msg.fail().add("va_msg", "User name should be 2-5 digits Chinese character or 6-16 English character with number. Symbol \"-\" and \"_\" is allowed.");
        }
        if(employeeService.checkUser(empName)) {
            return Msg.success();
        } else {
            return Msg.fail().add("va_msg", "User name is already exists.");
        }
    }

    @RequestMapping(value = "/emp/{id}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("id") Integer id) {
        Employee employee = employeeService.getEmp(id);
        return Msg.success().add("emp", employee);
    }

    @RequestMapping(value = "/emp/{empId}", method = RequestMethod.PUT)
    @ResponseBody
    public Msg saveEmp(Employee employee) {
        employeeService.updateEmp(employee);
        return Msg.success();
    }

    @RequestMapping(value = "/emp/{ids}", method = RequestMethod.DELETE)
    @ResponseBody
    public Msg deleteEmpById(@PathVariable("ids") String ids) {
        if(ids.contains("-")){
            List<Integer> del_ids = new ArrayList<>();
            String[] str_ids = ids.split("-");
            for(String id : str_ids){
                del_ids.add(Integer.parseInt(id));
            }
            employeeService.deleteBatch(del_ids);
        } else {
            Integer id = Integer.parseInt(ids);
            employeeService.deleteEmp(id);
        }
        return Msg.success();
    }

    // not finish
    @RequestMapping(value = "/find/{empName}", method = RequestMethod.GET)
    @ResponseBody
    public Msg getEmp(@PathVariable("empName") String empName) {
        boolean exist = employeeService.findEmpByName(empName);
        if(exist){
            List<Employee> emps = employeeService.getAll();
            Integer empIndex = 0;
            for(Employee e : emps){
                if(e.getEmpName().equalsIgnoreCase(empName)){
                    break;
                }
                System.out.println(empIndex);
                empIndex++;
            }
            return Msg.success().add("find_msg", empIndex);
        } else {
            return Msg.fail().add("find_msg", -1);
        }
    }

}
