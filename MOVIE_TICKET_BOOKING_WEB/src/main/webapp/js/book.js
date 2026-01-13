// ======================= BOOKING PAGE (template style) =======================

const movieCode = document.getElementById("movieCode").value;
const ctxRaw = document.getElementById("contextPath").value || "";
const ctx = ctxRaw.endsWith("/") ? ctxRaw.slice(0, -1) : ctxRaw;

// ======================= STATE =======================
let selectedDateISO = null;        // yyyy-MM-dd
let selectedShowtimeId = null;
let selectedShowtimeTime = "";     // HH:mm
let selectedShowtimeFormat = "";   // 2D/3D/...

let selectedSeats = [];            // ["A1","A2",...]

// Giá ghế theo hàng (giống template)
const seatPriceMap = {
    A: 43000, B: 43000, C: 43000,
    D: 56000, E: 56000, F: 56000,
    G: 56000, H: 56000,
    I: 80000, J: 80000
};

const comboPrice = [68000, 88000];
let comboCount = [0, 0];

// Movie info for ticket
let movieTitle = "";
let movieBgUrl = "";

// ======================= ELEMENTS =======================
const popup = document.getElementById("popup_screen");
const totalTicket = document.getElementById("total_ticket");
const bookBtn = document.getElementById("book_ticket");
const backBtn = document.getElementById("back_ticket");
const priceEl = document.getElementById("price");
const totalPriceEl = document.querySelector(".total-price");

const screenEl = document.getElementById("screen");
const chairEl = document.getElementById("chair");
const detEl = document.getElementById("det");
const ticketEl = document.getElementById("ticket");

// ======================= HELPERS =======================
function api(path) {
    const p = path.startsWith("/") ? path : "/" + path;
    return ctx + p;
}

function joinCtx(p) {
    if (!p) return "";
    // DB lưu ../img/... => đổi về /img/...
    if (p.startsWith("../")) p = "/" + p.substring(3);
    if (/^https?:\/\//i.test(p)) return p;
    if (!p.startsWith("/")) p = "/" + p;
    return ctx + p;
}

function toISO(d) {
    const yyyy = d.getFullYear();
    const mm = String(d.getMonth() + 1).padStart(2, "0");
    const dd = String(d.getDate()).padStart(2, "0");
    return `${yyyy}-${mm}-${dd}`;
}

function formatMoney(v) {
    return (v || 0).toLocaleString("vi-VN") + "đ";
}

function parseISOToText(iso) {
    // iso yyyy-MM-dd
    const [y, m, d] = iso.split("-").map(n => parseInt(n, 10));
    const months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    ];
    return `${d} ${months[m - 1]} ${y}`;
}

function monthAbbrev(monthIndex0) {
    const months = [
        "Jan", "Feb", "Mar", "Apr", "May", "Jun",
        "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[monthIndex0] || "";
}

function resetSelection() {
    selectedShowtimeId = null;
    selectedShowtimeTime = "";
    selectedShowtimeFormat = "";
    selectedSeats = [];
    comboCount = [0, 0];
    document.querySelectorAll(".quantity").forEach(q => q.value = "0");
    chairEl.innerHTML = "";
    updatePrice();
    totalTicket.style.display = "none";
    bookBtn.style.display = "none";
}

function updatePrice() {
    const seatTotal = selectedSeats.reduce((sum, code) => {
        const row = code.charAt(0);
        return sum + (seatPriceMap[row] || 0);
    }, 0);

    const comboTotal = comboCount[0] * comboPrice[0] + comboCount[1] * comboPrice[1];
    const total = seatTotal + comboTotal;

    priceEl.innerText = formatMoney(total);
    if (totalPriceEl) totalPriceEl.innerText = formatMoney(total);
}

// ======================= INIT UI =======================
totalTicket.style.display = "none";
bookBtn.style.display = "none";
popup.style.display = "none";
ticketEl.style.display = "none";

// Ở template home icon sẽ hiện sau khi in vé
backBtn.style.display = "none";

// ======================= LOAD MOVIE INFO =======================
(async function loadMovie() {
    try {
        const res = await fetch(api(`/api/movie?code=${encodeURIComponent(movieCode)}`));
        const m = await res.json();

        movieTitle = m.title || "";
        document.getElementById("title").innerText = movieTitle;
        document.getElementById("directed").innerText = m.directed || m.director || "";
        document.getElementById("starring").innerText = m.starring || m.actors || "";
        document.getElementById("edited").innerText = m.genre || "";
        document.getElementById("time").innerHTML = `<i class="bi bi-clock"></i> ${(m.duration || "")} phút`;

        const posterUrl = m.poster ? joinCtx(m.poster) : joinCtx("/img/default-poster.png");
        document.getElementById("poster").src = posterUrl;

        movieBgUrl = m.background ? joinCtx(m.background) : "";
        if (movieBgUrl) {
            const styleElem = document.head.appendChild(document.createElement("style"));
            styleElem.innerHTML =
                `.book .right::before{background:url(${movieBgUrl}) no-repeat center -30px/cover !important;}`;
        }
    } catch (e) {
        console.error("[BOOK] Movie API error:", e);
    }
})();

// ======================= RENDER DATES =======================
const now = new Date();
const days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
];

function renderDates() {
    let liHTML = "";
    for (let i = 0; i < 7; i++) {
        const d = new Date();
        d.setDate(now.getDate() + i);
        const iso = toISO(d);

        liHTML += `
      <li>
        <h6>${days[d.getDay()]}</h6>
        <h6 class="date_point" data-iso="${iso}">${d.getDate()}</h6>
      </li>`;
    }

    document.getElementById("timedate").innerHTML = `
    <div class="time_date">
      <h6 class="title">${days[now.getDay()]} ${now.getDate()} ${months[now.getMonth()]}</h6>
      <div class="card_month crd">${liHTML}</div>
    </div>`;
}

renderDates();

// ======================= LOAD SHOWTIMES BY DATE =======================
document.addEventListener("click", async (e) => {
    const d = e.target.closest(".date_point");
    if (!d) return;

    selectedDateISO = d.dataset.iso;

    document.querySelectorAll(".date_point").forEach(x => x.classList.remove("h6_active"));
    d.classList.add("h6_active");

    resetSelection();
    document.querySelectorAll(".time_point").forEach(x => x.classList.remove("h6_active"));

    try {
        const res = await fetch(api(`/api/showtimes?movie=${encodeURIComponent(movieCode)}&date=${encodeURIComponent(selectedDateISO)}`));
        const list = await res.json();

        const box = document.getElementById("showtimeBox");
        box.innerHTML = "";

        if (!list || list.length === 0) {
            box.innerHTML = `<div style="color:#fff; opacity:.7; padding:6px 0;">Không có suất chiếu</div>`;
            return;
        }

        list.forEach(s => {
            const timeStr = (s.showTime || "").toString().substring(0, 5);
            box.innerHTML += `
        <li class="crds" data-id="${s.id}" data-format="${s.format || ""}" data-time="${timeStr}">
          <h6>${s.format || ""}</h6>
          <h6 class="time_point">${timeStr}</h6>
        </li>`;
        });
    } catch (err) {
        console.error("[BOOK] Showtime API error:", err);
    }
});

// Auto select today
setTimeout(() => {
    const first = document.querySelector(".date_point");
    if (first) first.click();
}, 0);

// ======================= SEATS =======================
document.addEventListener("click", async (e) => {
    const t = e.target.closest(".time_point");
    if (!t) return;

    const li = t.closest(".crds");
    if (!li) return;

    document.querySelectorAll(".time_point").forEach(x => x.classList.remove("h6_active"));
    t.classList.add("h6_active");

    selectedShowtimeId = li.dataset.id;
    selectedShowtimeTime = li.dataset.time || t.innerText;
    selectedShowtimeFormat = li.dataset.format || "";

    // reset chọn ghế/combo
    selectedSeats = [];
    comboCount = [0, 0];
    document.querySelectorAll(".quantity").forEach(q => q.value = "0");
    totalTicket.style.display = "none";
    bookBtn.style.display = "none";
    updatePrice();

    try {
        const res = await fetch(api(`/api/seats?showtimeId=${encodeURIComponent(selectedShowtimeId)}`));
        const booked = await res.json();
        renderSeats(booked);
    } catch (err) {
        console.error("[BOOK] Seats API error:", err);
    }
});

function renderSeats(bookedMap) {
    chairEl.innerHTML = "";

    // CSS đang canh hàng ghế bằng nth-child(6) + nth-last-child(6)
    // => ĐỪNG insert "space" li, chỉ render span + 24 ghế + span (fix lệch hàng)
    const rows = ["J", "I", "H", "G", "F", "E", "D", "C", "B", "A"];
    const seatCount = 24;

    rows.forEach(r => {
        const row = document.createElement("div");
        row.className = "row";

        const sp1 = document.createElement("span");
        sp1.innerText = r;
        row.appendChild(sp1);

        for (let i = 1; i <= seatCount; i++) {
            const seat = document.createElement("li");
            seat.className = "seat";
            seat.dataset.seat = r + i;
            seat.dataset.price = String(seatPriceMap[r] || 0);

            // Template hiển thị giá trên ghế (vd: 56 / 80 / 43)
            seat.innerText = String(Math.round((seatPriceMap[r] || 0) / 1000));

            if (bookedMap && bookedMap[r] && bookedMap[r].includes(i)) {
                seat.classList.add("booked");
            }

            seat.onclick = () => toggleSeat(seat);
            row.appendChild(seat);
        }

        const sp2 = document.createElement("span");
        sp2.innerText = r;
        row.appendChild(sp2);

        chairEl.appendChild(row);
    });
}

function toggleSeat(li) {
    if (li.classList.contains("booked")) return;

    li.classList.toggle("selected");
    const code = li.dataset.seat;

    if (li.classList.contains("selected")) {
        if (!selectedSeats.includes(code)) selectedSeats.push(code);
    } else {
        selectedSeats = selectedSeats.filter(x => x !== code);
    }

    updatePrice();

    if (selectedSeats.length > 0) {
        totalTicket.style.display = "flex";
        bookBtn.style.display = "flex";
    } else {
        totalTicket.style.display = "none";
        bookBtn.style.display = "none";
        comboCount = [0, 0];
        document.querySelectorAll(".quantity").forEach(q => q.value = "0");
        updatePrice();
    }
}

// ======================= COMBO =======================
document.querySelectorAll(".plus").forEach((btn, i) => {
    btn.onclick = () => {
        comboCount[i]++;
        const input = btn.previousElementSibling;
        if (input && input.classList.contains("quantity")) input.value = comboCount[i];
        updatePrice();
    };
});

document.querySelectorAll(".minus").forEach((btn, i) => {
    btn.onclick = () => {
        if (comboCount[i] > 0) comboCount[i]--;
        const input = btn.nextElementSibling;
        if (input && input.classList.contains("quantity")) input.value = comboCount[i];
        updatePrice();
    };
});

// ======================= POPUP =======================
bookBtn.onclick = () => {
    if (!selectedShowtimeId) {
        alert("Vui lòng chọn suất chiếu!");
        return;
    }
    if (selectedSeats.length === 0) {
        alert("Vui lòng chọn ghế!");
        return;
    }
    popup.style.display = "flex";
    document.body.classList.add("modal-open");
};

popup.addEventListener("click", (e) => {
    if (e.target === popup) {
        popup.style.display = "none";
        document.body.classList.remove("modal-open");
    }
});

// ======================= BOOKING + SHOW TICKET =======================
document.getElementById("continue").onclick = async () => {
    if (!selectedShowtimeId || selectedSeats.length === 0) {
        alert("Vui lòng chọn suất chiếu và ghế trước!");
        return;
    }

    // Total = (ghế + combo)
    const total = parseInt((priceEl.innerText || "0").replace(/\D/g, ""), 10) || 0;

    const payload = {
        showtimeId: parseInt(selectedShowtimeId, 10),
        seats: selectedSeats,
        total: total
    };

    try {
        const res = await fetch(api("/api/booking"), {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify(payload)
        });

        const text = await res.text();
        let data = {};
        try { data = text ? JSON.parse(text) : {}; } catch (_) {}

        if (!res.ok) {
            if (res.status === 409) {
                alert(data.message || "Ghế đã được đặt bởi người khác. Vui lòng chọn ghế khác!");
            } else {
                alert(data.message || "Đặt vé thất bại!");
            }
            popup.style.display = "none";
            document.body.classList.remove("modal-open");
            return;
        }

        // ✅ Thành công: render vé giống template
        popup.style.display = "none";
        document.body.classList.remove("modal-open");
        showTicket();

    } catch (err) {
        console.error("[BOOK] Booking error:", err);
        alert("Đặt vé thất bại! Vui lòng thử lại.");
    }
};

function showTicket() {
    // Ẩn layout chọn ghế
    screenEl.style.display = "none";
    chairEl.style.display = "none";
    detEl.style.display = "none";
    bookBtn.style.display = "none";
    totalTicket.style.display = "none";

    // Hiện ticket + home
    ticketEl.style.display = "block";
    backBtn.style.display = "unset";

    ticketEl.innerHTML = "";

    const d = selectedDateISO ? new Date(selectedDateISO) : new Date();
    const setDayText = selectedDateISO ? parseISOToText(selectedDateISO) : parseISOToText(toISO(new Date()));
    const dayNum = d.getDate();
    const abbr = monthAbbrev(d.getMonth());

    // Mỗi ghế 1 vé (giống template)
    selectedSeats.forEach((code, idx) => {
        const rowChar = code.charAt(0);
        const seatNo = code.substring(1);
        const seatPrice = seatPriceMap[rowChar] || 0;

        const svgId = `${rowChar}${seatNo}barcode_${Date.now()}_${idx}`;

        const tic = document.createElement("div");
        tic.className = "tic";
        tic.innerHTML = `
      <div class="barcode">
        <div class="card">
          <h6>ROW ${rowChar}</h6>
          <h6>${setDayText}</h6>
        </div>
        <div class="card">
          <h6>Seat ${seatNo}</h6>
          <h6>${selectedShowtimeTime}</h6>
        </div>

        <svg id="${svgId}"></svg>
        <h5>MOVIE CINEMA</h5>
      </div>

      <div class="tic_details" style="background:url(${movieBgUrl}) no-repeat center -35px/cover">
        <div class="type">${selectedShowtimeFormat}</div>
        <h5 class="pvr"><span>Movie</span> Cinema</h5>
        <h1>${movieTitle}</h1>

        <div class="seat_det">
          <div class="seat_cr">
            <h6>ROW</h6>
            <h6>${rowChar}</h6>
          </div>
          <div class="seat_cr">
            <h6>SEAT</h6>
            <h6>${seatNo}</h6>
          </div>
          <div class="seat_cr">
            <h6>DATE</h6>
            <h6>${dayNum} <sub>${abbr}</sub></h6>
          </div>
          <div class="seat_cr">
            <h6>TIME</h6>
            <h6>${selectedShowtimeTime}</h6>
          </div>
        </div>
      </div>
    `;

        ticketEl.appendChild(tic);

        // Barcode (cần JsBarcode CDN đã load)
        if (window.JsBarcode) {
            const dateCompact = (selectedDateISO || "").replace(/-/g, "");
            const codeText = `${rowChar}${seatNo}${seatPrice}${dateCompact}${selectedShowtimeId}`;
            window.JsBarcode(`#${svgId}`, codeText);
        }
    });
}

// ======================= NAV =======================
backBtn.onclick = () => {
    window.location.href = ctx + "/home";
};
