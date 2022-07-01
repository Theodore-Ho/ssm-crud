<%--
  Created by IntelliJ IDEA.
  User: yuhong
  Date: 23/06/2022
  Time: 00:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
  <meta charset="UTF-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Employee List</title>
  <%
    pageContext.setAttribute("APP_PATH", request.getContextPath());
    String app_path = (String) pageContext.getAttribute("APP_PATH");
  %>
  <script type="text/javascript" src="<%=app_path%>/static/js/jquery-1.12.4.min.js"></script>
  <link href="<%=app_path%>/static/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <script src="<%=app_path%>/static/bootstrap/js/bootstrap.min.js"></script>
</head>
<body>
<!-- Modal -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Add new employee</h4>
      </div>
      <div class="modal-body">
        <form class="form-horizontal">
          <div class="form-group">
            <label class="col-sm-2 control-label">Name</label>
            <div class="col-sm-10">
              <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="Employee name">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Email</label>
            <div class="col-sm-10">
              <input type="text" name="email" class="form-control" id="empEmail_add_input" placeholder="example@gmail.com">
              <span class="help-block"></span>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Gender</label>
            <div class="col-sm-10">
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender1_add_input" value="M" checked="checked"> Male
              </label>
              <label class="radio-inline">
                <input type="radio" name="gender" id="gender2_add_input" value="F"> Female
              </label>
            </div>
          </div>
          <div class="form-group">
            <label class="col-sm-2 control-label">Department</label>
            <div class="col-sm-4">
              <select class="form-control" name="dId"></select>
            </div>
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="emp_save_btn">Save</button>
      </div>
    </div>
  </div>
</div>
<div class="container">
  <div class="row">
    <div class="col-md-12">
      <h1>SSM-CRUD</h1>
    </div>
  </div>
  <div class="row">
    <div class="col-md-4 col-md-offset-8">
      <button type="button" class="btn btn-primary" id="emp_add_modal_btn">Add New</button>
      <button type="button" class="btn btn-danger">Delete</button>
    </div>
  </div>
  <div class="row">
    <div class="col-md-12">
      <table class="table table-hover" id="emps_table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Gender</th>
            <th>Email</th>
            <th>Department</th>
            <th>Operation</th>
          </tr>
        </thead>
        <tbody></tbody>
      </table>
    </div>
  </div>
  <div class="row">
    <div class="col-md-6" id="page_info_area"></div>
    <div class="col-md-6" id="page_nav_area"></div>
  </div>
</div>
<script type="text/javascript">

  var totalRecord;
  var empName_add_input = "#empName_add_input";
  var empEmail_add_input = "#empEmail_add_input";

  $(function (){
    to_page(1);
  });

  function to_page(pn) {
    $.ajax({
      url:"${APP_PATH}/emps",
      data:"pn=" + pn,
      type:"GET",
      success:function(result){
        //console.log(result)
        build_emps_table(result);
        build_page_info(result);
        build_page_nav(result);
      }
    });
  }

  function build_emps_table(result) {
    $("#emps_table tbody").empty();
    var emps = result.extend.pageInfo.list;
    $.each(emps, function(index, item){
      var empIdTd = $("<td></td>").append(item.empId);
      var empNameTd = $("<td></td>").append(item.empName);
      var genderTd = $("<td></td>").append(item.gender === 'M' ? "Male" : "Female");
      var emailTd = $("<td></td>").append(item.email);
      var deptNameTd = $("<td></td>").append(item.department.deptName);
      var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm")
              .append($("<span></span>").addClass("glyphicon glyphicon-pencil")).append("Edit");
      var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm")
              .append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("Delete");
      var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);
      $("<tr></tr>").append(empIdTd).append(empNameTd).append(genderTd)
              .append(emailTd).append(deptNameTd).append(btnTd)
              .appendTo("#emps_table tbody");
    })
  }

  function build_page_info(result) {
    $("#page_info_area").empty();
    $("#page_info_area").append("Now at page " + result.extend.pageInfo.pageNum + "; Total " + result.extend.pageInfo.pages + " pages ; Total " + result.extend.pageInfo.total + " data.");
    totalRecord = result.extend.pageInfo.total;
  }

  function build_page_nav(result) {

    $("#page_nav_area").empty();

    var ul = $("<ul></ul>").addClass("pagination");
    var firstPageLi = $("<li></li>").append($("<a></a>").append("First").attr("href", "#"));
    var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;").attr("href", "#"));
    if(result.extend.pageInfo.hasPreviousPage === false) {
      firstPageLi.addClass("disabled");
      prePageLi.addClass("disabled");
    } else {
      firstPageLi.click(function() {
        to_page(1);
      });
      prePageLi.click(function() {
        to_page(result.extend.pageInfo.pageNum - 1);
      });
    }
    ul.append(firstPageLi).append(prePageLi);

    $.each(result.extend.pageInfo.navigatepageNums, function(index, item){
      var numLi = $("<li></li>").append($("<a></a>").append(item).attr("href", "#"));
      if(result.extend.pageInfo.pageNum === item) {
        numLi.addClass("active");
      }
      numLi.click(function() {
        to_page(item);
      });
      ul.append(numLi)
    });

    var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;").attr("href", "#"));
    var lastPageLi = $("<li></li>").append($("<a></a>").append("Last").attr("href", "#"));
    if(result.extend.pageInfo.hasNextPage === false) {
      nextPageLi.addClass("disabled");
      lastPageLi.addClass("disabled");
    } else {
      nextPageLi.click(function() {
        to_page(result.extend.pageInfo.pageNum + 1);
      });
      lastPageLi.click(function() {
        to_page(result.extend.pageInfo.pages);
      });
    }
    ul.append(nextPageLi).append(lastPageLi);

    var nav = $("<nav></nav>").append(ul);
    nav.appendTo("#page_nav_area");
  }

  function reset_form(element) {
    $(element)[0].reset();
    $(element).find("*").removeClass("has-error has-success");
    $(element).find(".help-block").text("");
  }

  $("#emp_add_modal_btn").click(function() {
    reset_form("#empAddModal form");
    getDepts("#empAddModal select");
    $("#empAddModal").modal({
      backdrop:"static"
    });
  });

  function getDepts(element) {
    $(element).empty();
    $.ajax({
      url:"${APP_PATH}/depts",
      type:"GET",
      success:function(result) {
        $.each(result.extend.depts, function() {
          var optionEle = $("<option></option>").append(this.deptName).attr("value", this.deptId);
          optionEle.appendTo("#empAddModal select");
        });
      }
    });
  }

  function validate_add_form() {
    var empName = $(empName_add_input).val();
    var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
    if(empName === ""){
      show_validate_msg(empName_add_input, "error", "User name is required.");
      return false;
    }
    else if(!regName.test(empName)){
      show_validate_msg(empName_add_input, "error", "User Name should be 2-5 digits Chinese character or 6-16 English character with number and \"-\", \"_\".");
      return false;
    } else {
      show_validate_msg(empName_add_input, "success", "");
    }
    var empEmail = $(empEmail_add_input).val();
    var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
    if(empEmail === ""){
      show_validate_msg(empEmail_add_input, "error", "Email is required.");
      return false;
    }
    else if(!regEmail.test(empEmail)){
      show_validate_msg(empEmail_add_input, "error", "Email format incorrect.")
      return false;
    } else {
      show_validate_msg(empEmail_add_input, "success", "")
    }
    return true;
  }

  function show_validate_msg(element, status, msg) {
    $(element).parent().removeClass("has-success has-error");
    $(element).next("span").text("");
    if("success"===status){
      $(element).parent().addClass("has-success");
      $(element).next("span").text("");
    } else if("error"===status){
      $(element).parent().addClass("has-error");
      $(element).next("span").text(msg);
    }
  }

  $("#emp_save_btn").click(function() {
    if(!validate_add_form()){
      return false;
    }
    if($(this).attr("ajax-validate") === "error"){
      return false;
    }
    $.ajax({
      url:"${APP_PATH}/emps",
      type:"POST",
      data:$("#empAddModal form").serialize(),
      success:function(result){
        if(result.code === 100) {
          $("#empAddModal").modal('hide');
          to_page(totalRecord);
        } else {
          if(result.extend.backEndValidateError === "empName"){
            show_validate_msg(empName_add_input, "error", "User Name should be 2-5 digits Chinese character or 6-16 English character with number and \"-\", \"_\".");
          } else if(result.extend.backEndValidateError === "email") {
            show_validate_msg(empEmail_add_input, "error", "Email format incorrect.");
          }
        }
      }
    });
  });

  $(empName_add_input).change(function() {
    $.ajax({
      url:"${APP_PATH}/checkuser",
      data:"empName=" + this.value,
      type:"POST",
      success:function(result){
        if(result.code === 100){
          show_validate_msg(empName_add_input, "success", "");
          $("#emp_save_btn").attr("ajax-validate", "success");
        } else {
          show_validate_msg(empName_add_input, "error", result.extend.va_msg);
          $("#emp_save_btn").attr("ajax-validate", "error");
        }
      }
    });
  });

  $(empEmail_add_input).change(function() {
    var empEmail = $(empEmail_add_input).val();
    var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
    if(!regEmail.test(empEmail)){
      show_validate_msg(empEmail_add_input, "error", "Email format incorrect.")
      return false;
    } else {
      show_validate_msg(empEmail_add_input, "success", "")
    }
    return true;
  });
</script>
</body>
</html>
