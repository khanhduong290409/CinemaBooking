<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt Vé</title>

    <link rel="icon" href="<c:url value='/img/logo/logo.ico'/>">
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="<c:url value='/css/book.css'/>">
</head>
<body>

<!-- hidden data for JS -->
<input type="hidden" id="movieCode" value="${param.movie}">
<input type="hidden" id="contextPath" value="${pageContext.request.contextPath}">

<div class="book">
    <div class="left">
        <img id="poster">
        <div class="play">
            <i class="bi bi-play-fill"></i>
        </div>
        <div class="cont">
            <h6>Directed by</h6>
            <p id="directed"></p>
            <h6>Starring</h6>
            <p id="starring"></p>
            <h6>Genre</h6>
            <p id="edited"></p>
        </div>
    </div>

    <div class="right">

        <div class="head_time">
            <h1 id="title"></h1>
            <div class="time">
                <h6 id="time"><i class="bi bi-clock"></i></h6>
                <button>PG-13</button>
            </div>
        </div>

        <div class="date_type">
            <div class="left_card" id="timedate"></div>

            <div class="right_card">
                <h6 class="title">Show Time</h6>
                <div class="card_month crd" id="showtimeBox"></div>
            </div>
        </div>

        <div class="screen" id="screen">Screen</div>

        <!-- chairs -->
        <div class="chair" id="chair"></div>

        <!-- Ticket (ẩn, sẽ hiện sau khi đặt vé thành công) -->
        <div class="ticket" id="ticket"></div>

        <!-- Combo -->
        <div class="popup_overplay" id="popup_screen">
            <div class="popup_bx">
                <h2>Combo - Bắp nước</h2>

                <div class="combo-section">
                    <div class="combo-item">
                        <img src="<c:url value='/img/combo/combo1.png'/>">
                        <div class="combo-details">
                            <h3>Beta Combo 69oz - 68.000đ</h3>
                            <div class="quantity-control">
                                <button class="minus">-</button>
                                <input type="text" value="0" class="quantity">
                                <button class="plus">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="combo-item">
                        <img src="<c:url value='/img/combo/combo2.png'/>">
                        <div class="combo-details">
                            <h3>Sweet Combo 69oz - 88.000đ</h3>
                            <div class="quantity-control">
                                <button class="minus">-</button>
                                <input type="text" value="0" class="quantity">
                                <button class="plus">+</button>
                            </div>
                        </div>
                    </div>

                    <div class="total_combo">
                        <p>Tổng cộng</p>
                        <p class="total-price">0đ</p>
                    </div>

                    <div class="continue">
                        <button class="continue_btn" id="continue">Đồng Ý</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="details" id="det">
            <div class="details_chair">
                <li>Avalable</li>
                <li>Booked</li>
                <li>Selected</li>
            </div>
        </div>

        <div class="total" id="total_ticket">
            <h6>Tạm Tính:</h6>
            <p id="price">0đ</p>
        </div>

        <button class="book_tic" id="book_ticket">
            <i class="bi bi-arrow-right-short"></i>
        </button>

        <button class="book_tic" id="back_ticket">
            <i class="bi bi-house"></i>
        </button>

    </div>
</div>

<script src="<c:url value='/js/book.js'/>"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jsbarcode/3.11.5/JsBarcode.all.js"></script>
</body>
</html>
