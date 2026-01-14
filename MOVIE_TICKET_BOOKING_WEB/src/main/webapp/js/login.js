function switchForm(formType) {
    var loginBox = document.getElementById('loginBox');
    var signupBox = document.getElementById('signupBox');
    var loginButton = document.getElementById('login');
    var signupButton = document.getElementById('signup');

    // ===== RESET INPUT (an toàn, không crash nếu field không tồn tại) =====
    if (document.forms.log) {
        if (document.forms.log.User) document.forms.log.User.value = '';
        if (document.forms.log.pass) document.forms.log.pass.value = '';
    }

    if (document.forms.Sign) {
        // form Sign Up mới: username + email
        if (document.forms.Sign.username) document.forms.Sign.username.value = '';
        if (document.forms.Sign.email) document.forms.Sign.email.value = '';
        if (document.forms.Sign.pass) document.forms.Sign.pass.value = '';
        if (document.forms.Sign.repass) document.forms.Sign.repass.value = '';
    }

    if (formType === 'login') {
        loginBox.classList.add('active');
        signupBox.classList.remove('active');
        loginButton.classList.add('active');
        signupButton.classList.remove('active');
    } else if (formType === 'signup') {
        signupBox.classList.add('active');
        loginBox.classList.remove('active');
        signupButton.classList.add('active');
        loginButton.classList.remove('active');
    }
}

Array.from(document.getElementsByClassName('login_input')).forEach((i, a) => {
    i.addEventListener('focus', () => {
        document.getElementsByClassName('login_field')[a].style.borderBottom = "2px solid #e50914";
    });
    i.addEventListener('focusout', () => {
        document.getElementsByClassName('login_field')[a].style.borderBottom = "2px solid gray";
    });
});

function checknull(txt) {
    return !txt || txt.value.trim().length === 0;
}

// (Bạn đang submit thật về servlet, nên 2 hàm dưới có thể không cần nữa)
// Mình vẫn sửa cho đúng field để khỏi lỗi nếu bạn có gọi ở đâu đó.

function login(l) {
    if (checknull(l.User)) {
        alert("User must be not null");
        l.User.focus();
        return;
    }
    if (checknull(l.pass)) {
        alert("pass must be not null");
        l.pass.focus();
        return;
    }
    alert("Login successful");
}

function signup(s) {
    if (checknull(s.username)) {
        alert("username must be not null");
        s.username.focus();
        return;
    }
    if (checknull(s.email)) {
        alert("email must be not null");
        s.email.focus();
        return;
    }
    if (checknull(s.pass)) {
        alert("pass must be not null");
        s.pass.focus();
        return;
    }
    if (checknull(s.repass)) {
        alert("repass must be not null");
        s.repass.focus();
        return;
    }
    if (s.pass.value !== s.repass.value) {
        alert("Pass and repass are not the same");
        return;
    }

    alert("signup successful");
    switchForm('login');
}
