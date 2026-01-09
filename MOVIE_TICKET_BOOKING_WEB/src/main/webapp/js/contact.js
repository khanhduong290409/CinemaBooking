// Gửi form bằng AJAX tới servlet /contact (POST)
function submitFeedback() {
    const city = document.getElementById("city").value;
    const name = document.getElementById("name").value.trim();
    const email = document.getElementById("email").value.trim();
    const phone = document.getElementById("phone").value.trim();
    const message = document.getElementById("message").value.trim();
    const msg = document.getElementById("feedbackMsg");

    if (!name || !email || !phone || !message) {
        if (msg) {
            msg.style.color = "red";
            msg.innerText = "Vui lòng điền đầy đủ thông tin!";
        } else {
            alert("Vui lòng điền đầy đủ thông tin!");
        }
        return;
    }

    const params = new URLSearchParams();
    params.append("city", city);
    params.append("name", name);
    params.append("email", email);
    params.append("phone", phone);
    params.append("message", message);

    fetch("contact", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: params.toString()
    })
        .then(response => response.json())
        .then(data => {
            if (msg) {
                if (data.success) {
                    msg.style.color = "green";
                    msg.innerText = data.message || "Gửi phản hồi thành công!";
                    document.getElementById("feedbackForm").reset();
                } else {
                    msg.style.color = "red";
                    msg.innerText = data.message || "Gửi phản hồi thất bại!";
                }
            } else {
                alert(data.message || (data.success ? "Thành công" : "Thất bại"));
            }
        })
        .catch(error => {
            console.error(error);
            if (msg) {
                msg.style.color = "red";
                msg.innerText = "Lỗi kết nối server!";
            } else {
                alert("Lỗi kết nối server!");
            }
        });
}

function resetForm() {
    const form = document.getElementById("feedbackForm");
    if (form) {
        form.reset();
    }
    const msg = document.getElementById("feedbackMsg");
    if (msg) {
        msg.innerText = "";
    }
}

/* Ẩn tất cả section */
function hideAllSections() {
    const sections = document.querySelectorAll(".section-content");
    sections.forEach(section => section.classList.add("hidden"));
}

/* Bỏ active trên tất cả link sidebar */
function deactivateAllLinks() {
    const links = document.querySelectorAll(".sidebar a");
    links.forEach(link => link.classList.remove("active"));
}

/* Hiện section theo id + set active sidebar */
function showSectionAndActivateLink(id) {
    if (!id) return;

    hideAllSections();
    deactivateAllLinks();

    const sectionToShow = document.getElementById(id);
    if (sectionToShow) {
        sectionToShow.classList.remove("hidden");
        window.scrollTo(0, 0);
    }

    const activeLink = document.getElementById("link-" + id);
    if (activeLink) {
        activeLink.classList.add("active");
    }
}

// Đảm bảo không đè window.onload của nav.js
window.addEventListener("load", function () {
    const hash = window.location.hash.substring(1);
    if (hash) {
        showSectionAndActivateLink(hash);
    } else {
        showSectionAndActivateLink("gioithieu");
    }

    // Set active cho nav trên header (nếu dùng route .jsp/.html thì phần này có thể chỉnh sau)
    const currentPage = window.location.pathname.split("/").pop().split("#")[0];
    const navLinks = document.querySelectorAll(".nav-items a");

    navLinks.forEach(link => link.classList.remove("active"));

    navLinks.forEach(link => {
        const href = link.getAttribute("href");
        if (!href) return;
        const linkPage = href.split("/").pop().split("#")[0];
        if (linkPage === currentPage) {
            link.classList.add("active");
        }
    });
});

// Chuyển section theo hash (#gioithieu, #lienhe,...)
window.addEventListener("hashchange", function () {
    const newHash = window.location.hash.substring(1);
    showSectionAndActivateLink(newHash);
});
