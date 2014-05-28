jQuery(document).ready(function ($) {
    $('#tabs').tab();
    $(document).on("click", "#comment-button", hide_and_show);
});

function hide_and_show(event) {
    event.preventDefault();
    $(event.target).hide();
    $("#comment-form").show();
}

function help_dialog() {
    event.preventDefault();
    $("#dialog").dialog({
        position: {
            my: "right bottom",
            at: "right bottom",
            of: window
        },
        width: '600px'
    })
}

