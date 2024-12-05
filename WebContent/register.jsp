<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>

</head>
<body>

<form name="MyForm" method=post action="validateRegister.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email:</font></div></td>
	<td><input type="email" name="email"></td>
</tr>
<tr>
	<td><div align="right"><font id="usrnme-input-label" face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username" maxlength="10" placeholder="Max 10 characters"></td>
</tr>
<tr>
	<td><div align="right"><font id="pw-input-label" face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input id="pw-input" type="password" name="password" maxlength="10" placeholder="Max 10 characters"></td>
</tr>
<tr>
    <td></td>
    <td><div style="display: flex; align-items: center;"><input type="checkbox" onclick="showPw();"><font face="Arial, Helvetica, sans-serif" size="2">Show password</font></div></td>
</tr>
</table>
<br><br>
<input class="submit" type="submit" name="Submit2" value="Register">
</form>


<script>
    function showPw() {
        let x=document.getElementById('pw-input');
        if(x.type === 'password'){
            x.type = 'text';
        }else{
            x.type = 'password';
        }
    }

    function adjustLabels() {
        if (sessionStorage.getItem("fromRegister") == 'false') {
            document.getElementById('usrnme-input-label').innerText = "New Username:";
            document.getElementById('pw-input-label').innerText = "New Password:";
        }
    }
    function adjustLabels();
    
</script>
</body>
</html>

