// Film page: chỉ toggle 2 tab "Đang Chiếu" / "Sắp Chiếu".
// Dữ liệu list phim được render bằng JSTL (không fetch JSON).

document.addEventListener('DOMContentLoaded', () => {
    const nowBtn = document.getElementById('now-showing');
    const upcomingBtn = document.getElementById('upcoming-movies');
    const nowContent = document.getElementById('now-showing-content');
    const upcomingContent = document.getElementById('upcoming-content');

    if (!nowBtn || !upcomingBtn || !nowContent || !upcomingContent) return;

    const showNow = (e) => {
        if (e) e.preventDefault();
        nowBtn.classList.add('active');
        upcomingBtn.classList.remove('active');
        nowContent.classList.remove('d-none');
        upcomingContent.classList.add('d-none');
    };

    const showUpcoming = (e) => {
        if (e) e.preventDefault();
        upcomingBtn.classList.add('active');
        nowBtn.classList.remove('active');
        upcomingContent.classList.remove('d-none');
        nowContent.classList.add('d-none');
    };

    nowBtn.addEventListener('click', showNow);
    upcomingBtn.addEventListener('click', showUpcoming);
});
