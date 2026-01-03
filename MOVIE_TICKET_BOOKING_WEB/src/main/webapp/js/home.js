document.addEventListener("DOMContentLoaded", function () {
    // Swiper
    if (typeof Swiper !== "undefined") {
        new Swiper(".mySwiper", {
            loop: true,
            navigation: {
                nextEl: ".swiper-button-next",
                prevEl: ".swiper-button-prev"
            },
            autoplay: {
                delay: 3500,
                disableOnInteraction: false
            }
        });
    }

    // Owl Carousel: Movie Selection
    if (window.jQuery) {
        $("#movieCarousel").owlCarousel({
            loop: true,
            margin: 20,
            nav: true,
            dots: false,
            responsive: {
                0: { items: 1 },
                600: { items: 2 },
                1000: { items: 4 }
            }
        });

        // Event slider (class owl-carousel owl-theme trong .slider-event)
        $(".slider-event .owl-carousel").owlCarousel({
            loop: true,
            margin: 20,
            nav: true,
            dots: false,
            responsive: {
                0: { items: 1 },
                600: { items: 2 },
                1000: { items: 3 }
            }
        });
    }
});
