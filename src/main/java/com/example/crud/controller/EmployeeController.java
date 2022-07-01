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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.validation.Valid;
import java.util.List;

@Controller
public class EmployeeController {

    @Autowired
    EmployeeService employeeService;

    @RequestMapping("/emps")
    @ResponseBody
    public Msg getEmpsWithJson(@RequestParam(value = "pn", defaultValue = "1") Integer pn, Model model) {
        PageHelper.startPage(pn, 5);
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

}
