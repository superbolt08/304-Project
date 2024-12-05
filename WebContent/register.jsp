<!DOCTYPE html>
<html>
<head>
    <title>Register Page</title>
    <style>
        /* Add basic styling for readability */
        body {
            font-family: Arial, Helvetica, sans-serif;
        }
        table {
            margin: 20px auto;
        }
        .submit {
            margin: 20px auto;
            display: block;
        }
    </style>
</head>
<body>
    <form name="MyForm" method="post" action="validateRegister.jsp" onsubmit="return validateForm()">
        <table>
            <tr>
                <td>Email:</td>
                <td><input type="email" name="email" required></td>
            </tr>
            <tr>
                <td>Username:</td>
                <td><input type="text" name="username" maxlength="10" placeholder="Max 10 characters" required></td>
            </tr>
            <tr>
                <td>Password:</td>
                <td><input id="pw-input" type="password" name="password" maxlength="10" placeholder="Max 10 characters" required></td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <input type="checkbox" onclick="togglePassword()"> Show password
                </td>
            </tr>
        </table>
        <input class="submit" type="submit" value="Register">
    </form>

    <script>
        function togglePassword() {
            let passwordInput = document.getElementById('pw-input');
            passwordInput.type = passwordInput.type === 'password' ? 'text' : 'password';
        }

        function validateForm() {
            const username = document.MyForm.username.value.trim();
            const password = document.MyForm.password.value.trim();

            if (username.length > 10 || password.length > 10) {
                alert('Username and Password must be at most 10 characters.');
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
