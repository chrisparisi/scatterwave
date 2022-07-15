$(document).ready(function() {
    starRating('.d-star-rating');
});


/*  Star Rating
/*--------------------------*/
function starRating(ratingElem) {
    $(ratingElem).each(function() {
        var dataRating = $(this).attr('data-rating');
        // Rating Stars Output
        function starsOutput(firstStar, secondStar, thirdStar, fourthStar, fifthStar) {
            return(''+
                '<span class="'+firstStar+'"></span>'+
                '<span class="'+secondStar+'"></span>'+
                '<span class="'+thirdStar+'"></span>'+
                '<span class="'+fourthStar+'"></span>'+
                '<span class="'+fifthStar+'"></span>');
        }

        var fiveStars = starsOutput('fas fa-star','fas fa-star','fas fa-star','fas fa-star','fas fa-star');

        var fourHalfStars = starsOutput('fas fa-star','fas fa-star','fas fa-star','fas fa-star','fas fa-star-half-alt');
        var fourStars = starsOutput('fas fa-star','fas fa-star','fas fa-star','fas fa-star','far fa-star');

        var threeHalfStars = starsOutput('fas fa-star','fas fa-star','fas fa-star','fas fa-star-half-alt','far fa-star');
        var threeStars = starsOutput('fas fa-star','fas fa-star','fas fa-star','far fa-star','far fa-star');

        var twoHalfStars = starsOutput('fas fa-star','fas fa-star','fas fa-star-half-alt','far fa-star','far fa-star');
        var twoStars = starsOutput('fas fa-star','fas fa-star','far fa-star','far fa-star','far fa-star');

        var oneHalfStar = starsOutput('fas fa-star','fas fa-star-half-alt','far fa-star','far fa-star','far fa-star');
        var oneStar = starsOutput('fas fa-star','far fa-star','far fa-star','far fa-star','far fa-star');

        var noStar = starsOutput('far fa-star','far fa-star','far fa-star','far fa-star','far fa-star');

        // Rules
        if (dataRating >= 4.75) {
            $(this).html(fiveStars);
        } else if (dataRating >= 4.25) {
            $(this).html(fourHalfStars);
        } else if (dataRating >= 3.75) {
            $(this).html(fourStars);
        } else if (dataRating >= 3.25) {
            $(this).html(threeHalfStars);
        } else if (dataRating >= 2.75) {
            $(this).html(threeStars);
        } else if (dataRating >= 2.25) {
            $(this).html(twoHalfStars);
        } else if (dataRating >= 1.75) {
            $(this).html(twoStars);
        } else if (dataRating >= 1.25) {
            $(this).html(oneHalfStar);
        } else if (dataRating == 1) {
            $(this).html(oneStar);
        }else if (dataRating < 1 ) {
            $(this).html(noStar);
        }

    });
}

var SetRatingStar = function () {
    return $('.star-rating .far, .star-rating .fas').each(function () {
        if (parseInt($('.star-rating .far, .star-rating .fas').siblings('input.rating-value').val()) >= parseInt($(this).data('rating'))) {
            return $(this).removeClass('far fa-star').addClass('fas fa-star');
        } else {
            return $(this).removeClass('fas fa-star').addClass('far fa-star');
        }
    });
};

$(document).on('mouseover', '.star-rating .far, .star-rating .fas', function () {
    $('.star-rating .far, .star-rating .fas').siblings('input.rating-value').val($(this).data('rating'));
    return SetRatingStar();
});
