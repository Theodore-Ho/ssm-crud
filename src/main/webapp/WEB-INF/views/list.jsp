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
    <div class="container">
        <div class="row">
            <div class="col-md-12">
                <h1>SSM-CRUD</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-4 col-md-offset-8">
                <button type="button" class="btn btn-primary">Add New</button>
                <button type="button" class="btn btn-danger">Delete</button>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <table class="table table-hover">
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Gender</th>
                        <th>Email</th>
                        <th>Department</th>
                        <th>Operation</th>
                    </tr>
                    <c:forEach items="${pageInfo.list}" var="emp">
                        <tr>
                            <td>${emp.empId}</td>
                            <td>${emp.empName}</td>
                            <td>${emp.gender=="M" ? "Male" : "Female"}</td>
                            <td>${emp.email}</td>
                            <td>${emp.department.deptName}</td>
                            <td>
                                <button type="button" class="btn btn-primary btn-sm" aria-label="Left Align">
                                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span> Edit
                                </button>
                                <button type="button" class="btn btn-danger btn-sm" aria-label="Left Align">
                                    <span class="glyphicon glyphicon-trash" aria-hidden="true"></span> Delete
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </div>
        <div class="row">
            <div class="col-md-6">
                Now at page ${pageInfo.pageNum}; Total ${pageInfo.pages} pages; Total ${pageInfo.total} data.
            </div>
            <div class="col-md-6">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <li>
                            <a href="${APP_PATH}/emps?pn=1">First</a>
                        </li>
                        <li>
                            <c:if test="${pageInfo.hasPreviousPage}">
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </c:if>
                        </li>
                        <c:forEach items="${pageInfo.navigatepageNums}" var="page_Num">
                            <c:if test="${page_Num == pageInfo.pageNum}">
                                <li class="active"><a href="#">${page_Num}</a></li>
                            </c:if>
                            <c:if test="${page_Num != pageInfo.pageNum}">
                                <li><a href="${APP_PATH}/emps?pn=${page_Num}">${page_Num}</a></li>
                            </c:if>
                        </c:forEach>
                        <li>
                            <c:if test="${pageInfo.hasNextPage}">
                                <a href="${APP_PATH}/emps?pn=${pageInfo.pageNum + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </c:if>
                        </li>
                        <li>
                            <a href="${APP_PATH}/emps?pn=${pageInfo.pages}">Last</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
    </div>
</body>
</html>
