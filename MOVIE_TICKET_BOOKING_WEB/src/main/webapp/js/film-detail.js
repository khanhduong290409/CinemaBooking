document.addEventListener("DOMContentLoaded", () => {
    const toggleText = document.getElementById("toggleText");
    const shortEl = document.getElementById("moviePlotShort");
    const fullEl = document.getElementById("moviePlotFull");

    if (!toggleText || !shortEl || !fullEl) return;

    // mặc định: show short, hide full
    shortEl.style.display = "inline";
    fullEl.style.display = "none";

    toggleText.addEventListener("click", () => {
        const isExpanded = toggleText.textContent.trim() === "Thu gọn";

        if (isExpanded) {
            shortEl.style.display = "inline";
            fullEl.style.display = "none";
            toggleText.textContent = "Xem thêm";
        } else {
            shortEl.style.display = "none";
            fullEl.style.display = "inline";
            toggleText.textContent = "Thu gọn";
        }
    });
});
