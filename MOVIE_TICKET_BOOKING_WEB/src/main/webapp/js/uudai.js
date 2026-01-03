document.addEventListener("DOMContentLoaded", function () {
    const configs = [
        { openId: "openModal1", modalId: "modal1", closeId: "closeModal1" },
        { openId: "openModal2", modalId: "modal2", closeId: "closeModal2" },
        { openId: "openModal3", modalId: "modal3", closeId: "closeModal3" },
    ];

    function openModal(modal) {
        if (!modal) return;
        modal.style.display = "block";
        document.body.style.overflow = "hidden";
    }

    function closeModal(modal) {
        if (!modal) return;
        modal.style.display = "none";
        document.body.style.overflow = "";
    }

    // Bind open/close
    configs.forEach(({ openId, modalId, closeId }) => {
        const btn = document.getElementById(openId);
        const modal = document.getElementById(modalId);
        const close = document.getElementById(closeId);

        if (btn) {
            btn.addEventListener("click", function (e) {
                e.preventDefault(); // ✅ quan trọng cho cả 3 modal
                openModal(modal);
            });
        }

        if (close) {
            close.addEventListener("click", function () {
                closeModal(modal);
            });
        }
    });

    // Click ra ngoài modal-content để đóng
    document.addEventListener("click", function (e) {
        // nếu click trúng overlay .modal
        if (e.target && e.target.classList && e.target.classList.contains("modal")) {
            closeModal(e.target);
        }
    });

    // ESC để đóng tất cả
    document.addEventListener("keydown", function (e) {
        if (e.key === "Escape") {
            configs.forEach(({ modalId }) => closeModal(document.getElementById(modalId)));
        }
    });
});
